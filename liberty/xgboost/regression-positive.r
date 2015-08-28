library(penalized)

train <- read.csv("train-results.csv")
test <- read.csv("test-results.csv")

train_Id <- train$Id
test_Id <- test$Id

y <- train$Hazard

# predictor variables from training
train_x <- subset(train, select = -c(Id, Hazard))

# predictor variables from test
test_x <- subset(test, select = -c(Id))

mod2 <- penalized(y, ~ H1 + H2 + H3 + H4 + H5, ~1, 
                  lambda1=0, lambda2=0, positive = c(T, T, T, T, T), data=train_x)
coef(mod2)

outfile <- 'submit.csv'
ypred <- predict(mod2, test)
outdata <- list("Id" = test_Id, "Hazard" = ypred)
write.csv(outdata, file = outfile, quote=FALSE, row.names=FALSE)

