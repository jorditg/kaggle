require 'torch'   -- torch
require 'image'   -- for image transforms
require 'nn'      -- provides all sorts of trainable modules/layers

----------------------------------------------------------------------
print '==> construct model'

model_type = 'convnet-color'

if model_type == 'saved' then
   saved = './kaggle-net/model-0.37-vote7.net'
   model = torch.load(saved)
elseif model_type == 'convnet-color' then
   -- input size 3x100x100
   model = nn.Sequential()
   model:add(nn.SpatialConvolutionMM(3, 64, 7, 7, 1, 1))
--64x94x94
   model:add(nn.ReLU())
   model:add(nn.SpatialMaxPooling(4,4,4,4))
-- 64x23x23
   model:add(nn.SpatialConvolution(64, 48, 5, 5, 1, 1))
   -- 48x19x19 
   model:add(nn.ReLU())
   model:add(nn.SpatialMaxPooling(3,3,3,3))
   -- 48x6x6
   model:add(nn.View(1728))
   model:add(nn.Dropout(0.5))
   model:add(nn.Linear(1728, 1024))
   model:add(nn.ReLU())
   model:add(nn.Linear(1024, 2))  
   model:add(nn.LogSoftMax())
elseif model_type == 'convnet-color2' then
elseif model_type == 'convnet-kaggle-0.30-mod' then
   -- input size 3x100x100
   model = nn.Sequential()

   model:add(nn.SpatialConvolutionMM(3, 64, 7, 7, 1, 1))
   -- size 64x94x94
   model:add(nn.ReLU())
   model:add(nn.SpatialMaxPooling(8,8,4,4))
   -- size 64x23x23
   model:add(nn.SpatialConvolution(64, 32, 5, 5, 1, 1))
   -- size after max pooling 32x19x19
   model:add(nn.ReLU())
   model:add(nn.SpatialMaxPooling(3,3,3,3))
   -- size after max pooling 32x6x6

   -- size after spatial convolution 
   model:add(nn.View(32*6*6))
   model:add(nn.Dropout(0.5))
   model:add(nn.Linear(32*6*6, 800))
   model:add(nn.ReLU())
   model:add(nn.Dropout(0.5))
   model:add(nn.Linear(800, 400))
   model:add(nn.ReLU())
   model:add(nn.Linear(400, 5))
   model:add(nn.LogSoftMax())
elseif model_type == 'mlp' then

end

----------------------------------------------------------------------
print '==> here is the model:'
print(model)

----------------------------------------------------------------------
-- Visualization is quite easy, using itorch.image().

if visualize then
   if itorch then
      print '==> visualizing ConvNet filters'
      print('Layer 1 filters:')
      itorch.image(model:get(1).weight)
      print('Layer 2 filters:')
      itorch.image(model:get(5).weight)
   else
      print '==> To visualize filters, start the script in itorch notebook'
   end
end

