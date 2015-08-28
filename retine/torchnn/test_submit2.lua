require 'torch'   -- torch
require 'nn'
require 'image'

-- local vars
local test_file = '../data/test-data11.th7'
local model_file = './kaggle-net/model-0.37-vote7.net'

local model = torch.load(model_file)
local testData = torch.load(test_file)

-- set model to evaluate mode (for modules that differ in training and testing, like Dropout)
model:evaluate()

local time = sys.clock()

-- test over test data
--print('==> testing on test set:')
for t = 1,testData:size() do
  -- get new sample
   local input = testData.data[t]

      -- test sample
   local pred = model:forward(input)
   print(tostring(torch.exp(pred[5]))..','..tostring(torch.exp(pred[1]))..','..tostring(torch.exp(pred[2]))..','..tostring(torch.exp(pred[3]))..','..tostring(torch.exp(pred[4])))
end

-- timing
--time = sys.clock() - time
--time = time / testData:size()
--print("\n==> time to test 1 sample = " .. (time*1000) .. 'ms')

