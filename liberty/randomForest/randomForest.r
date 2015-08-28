# load packages

library(caret)
library(randomForest)
library(readr)

# load raw data
train = read.csv('../data/train.csv')
test = read.csv('../data/test.csv')

# Create the response variable
y = train$Hazard

# Create the predictor data set and encode categorical variables using caret library.
mtrain = train[,-c(1,2)]
mtest = test[,-c(1)]
dummies <- dummyVars(~ ., data = mtrain)
mtrain = predict(dummies, newdata = mtrain)
mtest = predict(dummies, newdata = mtest)

cat("Training model - RF\n")
set.seed(832)

rf <- randomForest(mtrain, y, ntree=300, importance=TRUE, sampsize=10000, do.trace=TRUE, forest=TRUE)

predict_rf <- predict(rf, mtrain)
submit <- data.frame(Id=train$Id)
submit$Hazard <- predict_rf
write.csv(submit, "train-rf.csv")

predict_rf <- predict(rf, mtest)
submit <- data.frame(Id=test$Id)
submit$Hazard <- predict_rf
write.csv(submit, "test-rf.csv")


