require 'torch'   -- torch
require 'image'   -- for image transforms
require 'nn'      -- provides all sorts of trainable modules/layers

----------------------------------------------------------------------
print '==> define parameters'

noutputs = 1
ninputs = 95

----------------------------------------------------------------------
print '==> construct model'


model = nn.Sequential()
model:add(nn.View(95))
model:add(nn.Linear(95,100))
model:add(nn.ReLU())
model:add(nn.Dropout(0.5))
model:add(nn.Linear(100,100))
model:add(nn.ReLU())
model:add(nn.Dropout(0.5))
model:add(nn.Linear(100,100))
model:add(nn.ReLU())
model:add(nn.Dropout(0.5))
model:add(nn.Linear(100,100))
model:add(nn.ReLU())
model:add(nn.Dropout(0.5))
model:add(nn.Linear(100,100))
model:add(nn.ReLU())
model:add(nn.Dropout(0.5))
model:add(nn.Linear(100,1))
model:add(nn.ReLU())

----------------------------------------------------------------------
print '==> here is the model:'
print(model)

----------------------------------------------------------------------

-- 0.351335
--model = nn.Sequential()
--model:add(nn.View(95))
--model:add(nn.Linear(95,512))
--model:add(nn.ReLU())
--model:add(nn.Dropout(0.5))
--model:add(nn.Linear(512,512))
--model:add(nn.ReLU())
--model:add(nn.Dropout(0.5))
--model:add(nn.Linear(512,1))
--model:add(nn.ReLU())
