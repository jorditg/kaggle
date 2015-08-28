#!/usr/bin/env th

require 'torch'

local dataSrcFile = 'test-submit.bin'
local file = torch.DiskFile(dataSrcFile, 'r')

local height = 100
local width = 100
local channels = 3
local label_size = 1
local control_size = 1
local buf_size = channels * height * width + label_size + control_size
print('Buffer size: ', buf_size)

-- get the number of bytes of the file
file:seekEnd()
local size = file:position()
local rows = size / buf_size
print('Rows to process: ', rows)

-- return to the begining
file:seek(1)

local data_v = torch.ByteTensor(rows, channels, height, width)
local i = 1
while i <= rows do
  buffer = file:readByte(buf_size)
  print("Processing row: ", i, " Target: ", buffer[buf_size - 1])
  for c = 1,channels do
     for j = 1, height do
	for k = 1, width do
	   data_v[i][c][j][k] = buffer[(c - 1) * (height * width) + (k - 1) * width + j]
	end
     end
  end
  control_byte = buffer[buf_size]
  if control_byte ~= 255 then
     print('Error reading binary file. Incorrect control byte')
     os.exit()
  end
  i = i + 1
end

-- Serialize tensors

train = {
   data = data_v,
   target = target_v
}

local outputFilePath = 'test-submit.th7'
torch.save(outputFilePath, train)

