require 'torch'   -- torch
require 'xlua'    -- xlua provides useful tools, like progress bars
require 'optim'   -- an optimization package, for online and batch methods

----------------------------------------------------------------------
print '==> defining some tools'


-- Log results to files
trainLogger = optim.Logger(paths.concat('./', 'train.log'))
testLogger = optim.Logger(paths.concat('./', 'test.log'))

-- Retrieve parameters and gradients:
-- this extracts and flattens all the trainable parameters of the mode
-- into a 1-dim vector
if model then
   parameters,gradParameters = model:getParameters()
end

----------------------------------------------------------------------
print '==> configuring optimizer'

optimState = {
   learningRate = 0.0001,
--   weightDecay = 0.00005,
   momentum = 0.9,
--   learningRateDecay = 1e-7
}

optimMethod = optim.sgd
batchSize = 128

----------------------------------------------------------------------
print '==> defining training procedure'

function train()
 
   -- epoch tracker
   epoch = epoch or 1

   -- local vars
   local time = sys.clock()

   -- set model to training mode (for modules that differ in training and testing, like Dropout)
   model:training()

   -- shuffle at each epoch
   shuffle = torch.randperm(trsize)

   -- do one epoch
   print('==> doing epoch on training data:')
   print("==> online epoch # " .. epoch .. ' [batchSize = ' .. batchSize .. ']')
   local err = 0
   for t = 1,trainData:size(),batchSize do
      -- disp progress
      xlua.progress(t, trainData:size())

      -- create mini batch
      local inputs = {}
      local targets = {}
      for i = t,math.min(t+batchSize-1,trainData:size()) do
         -- load new sample
         local input = trainData.data[shuffle[i]]
         local target = trainData.labels[shuffle[i]]
         table.insert(inputs, input)
         table.insert(targets, target)
      end

      -- create closure to evaluate f(X) and df/dX
      local feval = function(x)
                       -- get new parameters
                       if x ~= parameters then
                          parameters:copy(x)
                       end

                       -- reset gradients
                       gradParameters:zero()

                       -- f is the average of all criterions
                       local f = 0

                       -- evaluate function for complete mini batch
                       for i = 1,#inputs do
                          -- estimate f
                          local output = model:forward(inputs[i])
			  targ = torch.Tensor(1)
			  targ[1] = targets[i]
                          local err = criterion:forward(output, targ)
                          f = f + err

                          -- estimate df/dW
                          local df_do = criterion:backward(output, targ)
                          model:backward(inputs[i], df_do)

                       end

                       -- normalize gradients and f(X)
                       gradParameters:div(#inputs)
                       f = f/#inputs

                       -- return f and df/dX
                       return f,gradParameters
                    end

      -- optimize on current mini-batch
      _,fs = optimMethod(feval, parameters, optimState)
     err = err + fs[1]
   end
   err = err/trainData:size()

   -- time taken
   time = sys.clock() - time
   time = time / trainData:size()
   print("\n==> time to learn 1 sample = " .. (time*1000) .. 'ms')
   print("\n==> Error: " .. err)
   -- update logger/plot
   trainLogger:add{['current loss training set'] = err}
   trainLogger:style{['current loss training set'] = '-'}
   trainLogger:plot()

   -- save/log current net
   local filename = paths.concat('./', 'model.net')
   os.execute('mkdir -p ' .. sys.dirname(filename))
   print('==> saving model to '..filename)
   torch.save(filename, model)

   epoch = epoch + 1
end
