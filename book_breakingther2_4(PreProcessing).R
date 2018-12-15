# R의 Data type 이해하기 ----
(a <- 1 : 12) # 숫자로된 vector

(m <- matrix(a, 4, 3))
dim(a) <- c(2, 6) # vector 객체에 속성을 변경하여 matrix
a
attributes(a)
length(a) # 전체 길이 : 12
str(a)

# 차원 축소를 막는 방법 ----
a[, 1] # vector
a[, 1, drop = F] # matrix
"["(a, 1 : 2, drop = F)

# array데이터형 살펴보기 ----
a <- 1 : 24
dim(a) <- c(2, 6, 2)
a
dim(a) <- c(2, 3, 4)
a
dim(a) <- c(2, 3, 2, 2)
a

# list에 관해서 ----
a <- 1 : 5
b <- 20 : 24
df <- data.frame(a, b)
typeof(df)
mode(df)
class(df) # data.frame은 list
lapply(df, max)
df$l <- list(letters[1 : 2], letters[1 : 3], letters[1 : 4], letters[1 : 5], letters[1 : 6])
df

# Data Processing Fucntions ----
## lapply(), sapply() ----
a <- 1 : 12
b <- 40 : 55
(l <- list(a, b))
median(l[[1]])
median(l[[2]])
for(i in 1 : 2){
  print(median(l[[i]]))
}
lapply(l, median) # return : list
sapply(l, median) # return : vector
sapply(l, median, simplify = F) # return : 입력한 데이터와 같은 형식
sex <- c("남자", "여자", "남자", "여자", "여자", "여자", "남자")
l <- list(c("남자"), c("여자"))
lapply(l, function(x) which(x == sex))

## apply() ----
x <- 1 : 12
dim(x) <- c(2, 6)
x
apply(x, 1, mean) # 1 : row, 2 : column
apply(x, 2, max)
apply(x, c(1, 2), length)

x[1, 3] <- NA
apply(x, 1, mean, na.rm = T)
apply(x, 1, mean, na.rm = T, trim = 0.5)

x <- 1 : 24
dim(x) <- c(2, 6, 2)
x
apply(x, 1, max)
apply(x, 2, max)
apply(x, 3, max) # x는 3차원이기 때문에 margin에 3을 넣을 수 있다.
test <- function(x) (x^2) - 100
apply(x, 3, test)

# Divide and process Data ----
DF <- read.csv("example_studentlist.csv", fileEncoding = "EUC-KR")
lapply(DF[, 7 : 8], mean)

blo_O <- subset(DF, subset = (bloodtype == "O"))
blo_A <- subset(DF, subset = (bloodtype == "A"))
blo_B <- subset(DF, subset = (bloodtype == "B"))
blo_AB <- subset(DF, subset = (bloodtype == "AB"))
mean(blo_O$height)
mean(blo_A$height)
mean(blo_B$height)
mean(blo_ABO$height)
aggregate(height ~ bloodtype, DF, mean) # data.frame -> data.frame
tapply(DF$height, DF$bloodtype, mean) # vector -> vector
by(DF$height, DF$bloodtype, mean) # data.frame -> list
lapply(split(DF$height, DF$bloodtype), mean) # list -> list

tapply(DF[, 7], list(DF$bloodtype, DF$sex, DF$grade), mean)
aggregate(height ~ bloodtype + sex + grade, DF, mean)

## aggregate() ----
aggregate(x = DF$height, by = list(DF$bloodtype), FUN = mean) # by : 기준(list), x : 적용대상
aggregate(height ~ bloodtype + sex, DF, mean)
aggregate(cbind(height, weight) ~ bloodtype, DF, mean)
aggregate(height ~ bloodtype, DF, mean, na.rm = T)

## tapply() ----
mode(DF$height); mode(DF$bloodtype) # 모두 vector
(t <- tapply(DF$height, DF$bloodtype, mean))
mode(t); class(t)
tapply(DF["height"], DF["bloodtype"], mean) # Error : why?) data.frame
class(DF["height"]) # data.frame
tapply(DF$height, list(DF$bloodtype, DF$sex, DF$grade), mean)

## by() ----
by(DF$height, DF$bloodtype, mean)
mode(DF["height"])
by(DF$height, DF$bloodtype, summary)
mode(DF[, 7])
by(DF[, 7], DF[, 6], summary)
by(DF[, c("height", "weight")], DF[, 6], mean) # Error : 데이터를 처리할 여러 개의 값을 인정하지 않는다.
                                               # mean(DF[, c("height", "weight")]) -> 처리될 수 없다.
by(DF[, c("height", "weight")], DF[, 6], summary) # summary는 data.frame에 그대로 적용 가능하다.
by(DF, DF["sex"], summary)
by(DF, DF["sex"], function(x) lm(weight ~ height, data = x))
