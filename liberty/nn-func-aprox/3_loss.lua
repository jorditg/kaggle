require 'torch'   -- torch
require 'nn'      -- provides all sorts of loss functions


noutputs = 1

----------------------------------------------------------------------
print '==> define loss'

criterion = nn.MSECriterion()
criterion.sizeAverage = false


----------------------------------------------------------------------
print '==> here is the loss function:'
print(criterion)
