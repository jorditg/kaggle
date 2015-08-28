require 'torch'   -- torch
require 'nn'
require 'image'

  idx = {1,2,3,32,47,74,75,77,83,84,86,87,94,95}
  vals = {}
  vals[1] = { 9.7219019607843, 5.168072126006}	
  vals[2] = { 12.847333333333, 6.2559406655057}	
  vals[3] = { 3.1859411764706, 1.7394091027747}	
  vals[4] = { 7.0203137254902, 3.5953779744123}	
  vals[5] = { 13.995980392157, 4.6478664273327}	
  vals[6] = { 57.578921568627, 23.500970625056}
  vals[7] = { 12.41937254902, 4.7836800656939}	
  vals[8] = { 10.259294117647, 4.8521728267424}	
  vals[9] = { 1.9481764705882, 0.80015526263232}	
  vals[10] = { 33.487098039216, 5.8358653907967}	
  vals[11] = { 12.492784313725, 7.31492545197}
  vals[12] = { 4.496431372549, 1.8968030295142}	
  vals[13] = { 2.4510784313725, 1.2601083719297}	
  vals[14] = { 3.4844117647059, 3.0767536806032}

function scale (val, index)
  for i=1,#idx do
    if index == idx[i] then
      return (val - vals[i][1])/vals[i][2]
    end
  end
  return val
end

-- local vars
local test_file = '../data/test96.th7'
local model_file = 'model.net'

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

   for i = 1, 95 do
	input[1][1][i] = scale(input[1][1][i], i)
   end
      -- test sample
   local pred = model:forward(input)
   print(pred[1])
--   print(tostring(4.0227058823529 + 4.021193551685*pred[1]))
end

-- timing
--time = sys.clock() - time
--time = time / testData:size()
--print("\n==> time to test 1 sample = " .. (time*1000) .. 'ms')

