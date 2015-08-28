library(Rtsne)
library(data.table)
library(Matrix)

set.seed(3442)

train <- read.csv('../data/train.csv')
test <- read.csv('../data/test.csv')

tr_features <- train[, -c(1,2)]
te_features <- test[, -c(1)]

all_features <- rbind(tr_features, te_features)

all_features <- model.matrix(~., data = all_features)

tsne <- Rtsne(all_features, check_duplicates = FALSE, pca = TRUE, perplexity = 30, theta = 0.5, dims = 3)

write.csv(tsne$Y[1:nrow(train),], "t-sne-train.csv")
write.csv(tsne$Y[(nrow(train)+1):nrow(all_features),], "t-sne-test.csv")

