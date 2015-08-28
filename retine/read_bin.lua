#!/usr/bin/env th

require 'torch'

local dataSrcFile = '7.bin'
local file = torch.DiskFile(dataSrcFile, 'r')

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


train = {
   data = data_v,
   target = target_v
}


local outputFilePath = '7.th7'
torch.save(outputFilePath, train)

