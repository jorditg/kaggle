require 'torch'   -- torch
require 'xlua'    -- xlua provides useful tools, like progress bars
require 'optim'   -- an optimization package, for online and batch methods

----------------------------------------------------------------------
print '==> defining some tools'

batchSize = 128

-- classes
--classes = {'1','2','3','4','0'}
classes = {'1', '0'}
-- This matrix records the current confusion across classes
confusion = optim.ConfusionMatrix(classes)

-- Log results to files
trainLogger = optim.Logger('train.log')
testLogger = optim.Logger('test.log')

-- Retrieve parameters and gradients:
-- this extracts and flattens all the trainable parameters of the mode
-- into a 1-dim vector
if model then
   parameters,gradParameters = model:getParameters()
end

----------------------------------------------------------------------
print '==> configuring optimizer'

optimState = {
   learningRate = 0.1,
   weightDecay = 0.00005,
   momentum = 0.9,
   learningRateDecay = 1e-7
}

----------------------------------------------------------------------
print '==> defining training procedure'

testData = torch.load('../data/0vsall-test.th7')
trainData = torch.load('../data/0vsall.th7') 

function train()

   -- epoch tracker
   epoch = epoch or 1

   -- local vars
   local time = sys.clock()

   -- set model to training mode (for modules that differ in training and testing, like Dropout)
   model:training()
  
--   if epoch % 1 == 1 then
--     local ch = torch.random(6)
--     if ch == 1 then
--	  trainData = torch.load('../data/01.th7')
--     elseif ch == 2 then
--	  trainData = torch.load('../data/02.th7')
--     elseif ch == 3 then
--	  trainData = torch.load('../data/03.th7')
--     elseif ch == 4 then
--	  trainData = torch.load('../data/04.th7')
--     elseif ch == 5 then
--	  trainData = torch.load('../data/05.th7')
--     elseif ch == 6 then
--        trainData = torch.load('../data/06.th7')
--     end
--   end

--   trainData.data = trainData.data[{{},{1,2},{}, {}}]

   -- shuffle at each epoch
   shuffle = torch.randperm(trainData:size())

   -- do one epoch
   print('==> doing epoch on training data:')
   print("==> online epoch # " .. epoch .. ' [batchSize = ' .. batchSize .. ']')
   for t = 1,trainData:size(), batchSize do
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
                          local err = criterion:forward(output, targets[i])
                          f = f + err

                          -- estimate df/dW
                          local df_do = criterion:backward(output, targets[i])
                          model:backward(inputs[i], df_do)

                          -- update confusion
                          confusion:add(output, targets[i])
                       end

                       -- normalize gradients and f(X)
                       gradParameters:div(#inputs)
                       f = f/#inputs

                       -- return f and df/dX
                       return f,gradParameters
                    end

      -- optimize on current mini-batch
      optim.sgd(feval, parameters, optimState)
   end

   -- time taken
   time = sys.clock() - time
   time = time / trainData:size()
   print("\n==> time to learn 1 sample = " .. (time*1000) .. 'ms')

   -- print confusion matrix
   print(confusion)

   -- update logger/plot
   trainLogger:add{['% mean class accuracy (train set)'] = confusion.totalValid * 100}

   trainLogger:style{['% mean class accuracy (train set)'] = '-'}
   trainLogger:plot()

   -- save/log current net
   local filename = 'model.net'
   os.execute('mkdir -p ' .. sys.dirname(filename))
   print('==> saving model to '..filename)
   torch.save(filename, model)

   -- next epoch
   confusion:zero()
   epoch = epoch + 1
end
