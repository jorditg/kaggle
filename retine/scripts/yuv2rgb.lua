require 'torch'   -- torch
require 'image'   -- for color transforms
require 'nn'      -- provides a normalization operator

----------------------------------------------------------------------

local visualize = false

local file1 = arg[1]

----------------------------------------------------------------------
print ('==> loading dataset ' .. file1)
t1 = torch.load(file1)

t2 = {
   data = t1.data,
   labels = t1.labels
}

function t2:size() return self.data:size()[1] end

t1 = {}

----------------------------------------------------------------------
print '==> preprocessing data: colorspace YUV -> RGB'
print (t2:size() .. ' elements')
for i = 1,t2:size() do
   t2.data[i] = image.yuv2rgb(t2.data[i])
end

----------------------------------------------------------------------
print '==> visualizing data'

-- Visualization is quite easy, using itorch.image().

if visualize then
   if itorch then
   first256Samples_r = t2.data[{ {1,256},1 }]
   first256Samples_g = t2.data[{ {1,256},2 }]
   first256Samples_b = t2.data[{ {1,256},3 }]
   itorch.image(first256Samples_r)
   itorch.image(first256Samples_g)
   itorch.image(first256Samples_b)
   else
      print("For visualization, run this script in an itorch notebook")
   end
end

print("==> Saving file")

torch.save(file1, t2)

