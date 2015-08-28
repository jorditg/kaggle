require 'torch'   -- torch
require 'image'   -- for image transforms
require 'nn'      -- provides all sorts of trainable modules/layers

----------------------------------------------------------------------
print '==> define parameters'

-- 69-class problem
noutputs = 5

-- input dimensions
ninputs = 220
----------------------------------------------------------------------
print '==> construct model'

-- Simple 2-layer neural network, with tanh hidden units
model = nn.Sequential()
--model:add(nn.Dropout(0.2))
model:add(nn.View(220))
model:add(nn.Linear(220, 512))
model:add(nn.Dropout(0.5))
model:add(nn.ReLU())
model:add(nn.Linear(512, 512))
model:add(nn.Dropout(0.5))
model:add(nn.ReLU())
model:add(nn.Linear(512, 512))
model:add(nn.Dropout(0.5))
model:add(nn.ReLU())
model:add(nn.Linear(512, 5))

----------------------------------------------------------------------
print '==> here is the model:'
print(model)

