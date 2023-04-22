#create table
data <- matrix(c(163, 14614, 122, 16931), ncol=2, byrow=TRUE)
colnames(data) <- c("Vime", "NotVime")
rownames(data) <- c("FiveStar","NotFiveStar")
data <- as.table(data)


data

chisq.test(data)
