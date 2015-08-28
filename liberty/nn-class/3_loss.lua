----------------------------------------------------------------------
-- This script demonstrates how to define a couple of different
-- loss functions:
--   + negative-log likelihood, using log-normalized output units (SoftMax)
--   + mean-square error
--   + margin loss (SVM-like)
--
-- Clement Farabet
----------------------------------------------------------------------

require 'torch'   -- torch
require 'nn'      -- provides all sorts of loss functions

----------------------------------------------------------------------

-- 69-class problem
noutputs = 5

----------------------------------------------------------------------
print '==> define loss'


-- This loss requires the outputs of the trainable model to
-- be properly normalized log-probabilities, which can be
-- achieved using a softmax function

model:add(nn.LogSoftMax())

-- The loss works like the MultiMarginCriterion: it takes
-- a vector of classes, and the index of the grountruth class
-- as arguments.

criterion = nn.ClassNLLCriterion()


----------------------------------------------------------------------
print '==> here is the loss function:'
print(criterion)
