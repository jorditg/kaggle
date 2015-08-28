#!/usr/bin/env th

require 'torch'   -- torch
require 'image'   -- for color transforms
require 'nn'      -- provides a normalization operator

-----------------------------------
-----------------------------------
------ Variables to enter ---------
local dataSrcFile = '05.bin'
local outputFilePath = '05.th7'
---- End variables to enter -------
-----------------------------------
-----------------------------------

local file = torch.DiskFile(dataSrcFile, 'r')
file:binary()
local height = 100
local width = 100
local channels = 3
local label_size = 1
local control_size = 1

-- get the number of bytes of the file
file:seekEnd()
local size = file:position()

-- return to the begining
file:seek(1)
local buf_size = channels * height * width + label_size + control_size
print('Buffer size: ', buf_size)
local rows = size / buf_size
print('Rows to process: ', rows)

local data_v = torch.ByteTensor(rows, channels, height, width)
local target_v = torch.ByteTensor(rows)

local i = 1
while i <= rows do
  buffer = file:readByte(buf_size)
  for c = 1,channels do
     for j = 1, height do
	for k = 1, width do
	   data_v[i][c][j][k] = buffer[(c - 1) * (height * width)
		                       + j + (k - 1) * width]
	end
     end
  end
  target_v[i] = buffer[buf_size - 1]
  print("Processing row: ", i, " Target: ", target_v[i])
  control_byte = buffer[buf_size]
  if control_byte ~= 255 then
     print('Error reading binary file. Incorrect control byte')
     os.exit()
  end
  i = i + 1
end

local count_0 = 0
local count_1 = 0
local count_2 = 0
local count_3 = 0
local count_4 = 0
for i = 1,rows do
   if target_v[i] == 0 then
      count_0 = count_0 + 1
   elseif target_v[i] == 1 then
      count_1 = count_1 + 1
   elseif target_v[i] == 2 then
      count_2 = count_2 + 1
   elseif target_v[i] == 3 then
      count_3 = count_3 + 1
   elseif target_v[i] == 4 then
      count_4 = count_4 + 1
   end
end

print('0s = ' .. count_0)
print('1s = ' .. count_1)
print('2s = ' .. count_2)
print('3s = ' .. count_3)
print('4s = ' .. count_4)

-- Serialize tensors

trainData = {
   data = data_v,
   labels = target_v,
   trsize = rows,
   size = function() return trainData.trsize end
}

----------------------------------------------------------------------
print '==> preprocessing data'

-- Preprocessing requires a floating point representation (the original
-- data is stored on bytes). Types can be easily converted in Torch, 
-- in general by doing: dst = src:type('torch.TypeTensor'), 
-- where Type=='Float','Double','Byte','Int',... Shortcuts are provided
-- for simplicity (float(),double(),cuda(),...):

trainData.data = trainData.data:float()

-- We now preprocess the data. Preprocessing is crucial
-- when applying pretty much any kind of machine learning algorithm.

-- For natural images, we use several intuitive tricks:
--   + images are mapped into YUV space, to separate luminance information
--     from color information
--   + the luminance channel (Y) is locally normalized, using a contrastive
--     normalization operator: for each neighborhood, defined by a Gaussian
--     kernel, the mean is suppressed, and the standard deviation is normalized
--     to one.
--   + color channels are normalized globally, across the entire dataset;
--     as a result, each color component has 0-mean and 1-norm across the dataset.


-- class 0 will be 5
for i = 1,trainData:size() do
   if trainData.labels[i] == 0 then
      trainData.labels[i] = 5
   end
end

-- Convert all images to YUV
print '==> preprocessing data: colorspace RGB -> YUV'
for i = 1,trainData:size() do
   trainData.data[i] = image.rgb2yuv(trainData.data[i])
end

-- Name channels for convenience
channels = {'y','u','v'}

-- Normalize each channel, and store mean/std
-- per channel. These values are important, as they are part of
-- the trainable parameters. At test time, test data will be normalized
-- using these values.
print '==> preprocessing data: normalize each feature (channel) globally'
mean = {}
std = {}
for i,channel in ipairs(channels) do
   -- normalize each channel globally:
   mean[i] = trainData.data[{ {},i,{},{} }]:mean()
   std[i] = trainData.data[{ {},i,{},{} }]:std()
   trainData.data[{ {},i,{},{} }]:add(-mean[i])
   trainData.data[{ {},i,{},{} }]:div(std[i])
end

-- Local normalization
print '==> preprocessing data: normalize all three channels locally'

-- Define the normalization neighborhood:
neighborhood = image.gaussian1D(13)

-- Define our local normalization operator (It is an actual nn module, 
-- which could be inserted into a trainable model):
normalization = nn.SpatialContrastiveNormalization(1, neighborhood, 1):float()

-- Normalize all channels locally:
for c in ipairs(channels) do
   for i = 1,trainData:size() do
      trainData.data[{ i,{c},{},{} }] = normalization:forward(trainData.data[{ i,{c},{},{} }])
   end
end
----------------------------------------------------------------------
print '==> verify statistics'

-- It's always good practice to verify that data is properly
-- normalized.

for i,channel in ipairs(channels) do
   trainMean = trainData.data[{ {},i }]:mean()
   trainStd = trainData.data[{ {},i }]:std()

   print('training data, '..channel..'-channel, mean: ' .. trainMean)
   print('training data, '..channel..'-channel, standard deviation: ' .. trainStd)
end

----------------------------------------------------------------------
print '==> visualizing data'

-- Visualization is quite easy, using itorch.image().

if visualize then
   if itorch then
   first256Samples_y = trainData.data[{ {1,256},1 }]
   first256Samples_u = trainData.data[{ {1,256},2 }]
   first256Samples_v = trainData.data[{ {1,256},3 }]
   itorch.image(first256Samples_y)
   itorch.image(first256Samples_u)
   itorch.image(first256Samples_v)
   else
      print("For visualization, run this script in an itorch notebook")
   end
end

torch.save(outputFilePath, trainData)

