library('e1071') # SVM library


rmse <- function(error) 
{
  sqrt(mean(error^2))
}

#lapply
# load data
x <- read.csv('/home/jordi/Escritorio/liberty/features-161-SVM.txt')
y <- read.csv('/home/jordi/Escritorio/liberty/labels.txt')
# data <- cbind(x,y)

# train SVM
timer <- proc.time()
#tuneResult <- tune(svm, x, y, kernel = 'radial', ranges = list(epsilon = seq(0,1,0.1), cost = 2^2))
model <- svm(x, y, kernel = 'linear', epsilon = 0.1, cost = 2^2)
proc.time() - timer

# calculate error
#predictedY <- predict(model, x)
#error <- y - predictedY
error <- model$residuals
predictionRMSE <- rmse(error) 

# predict test data
x_test = read.csv('/home/jordi/Escritorio/liberty/test-features-161-SVM.txt')
pred <- predict(model, x_test)

# save results
write.csv(pred, 'test-output.csv')

# export SVM object to file
write.svm(model, svm.file = "SVM-1.svm", scale.file = "SVM-1.scale")

