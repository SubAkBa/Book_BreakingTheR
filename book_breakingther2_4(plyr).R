# package : plyr ----
## ddplyr(), dlply() ----
library(plyr)
DF <- read.csv("example_studentlist.csv", fileEncoding = "EUC-KR")
ddply(DF, "bloodtype")
dlply(DF, "bloodtype")
ddply(DF, "bloodtype", nrow)
ddply(DF, "bloodtype", c("nrow", "ncol"))
ddply(DF, "bloodtype", function(df) mean(df[, "height"]))
ddply(DF, "bloodtype", function(df) print(df))
ddply(DF, "bloodtype", summarise, heightMean = mean(height))
summarise(DF, heightMean = mean(height))

## Multiple Groups ----
ddply(DF, .(bloodtype), summarise, heightMean = mean(height)) 
          # .() : data.frame이 list로 구성되어 있기 때문.
ddply(DF, .(bloodtype, sex), summarise, heightMean = mean(height))

## summarise(), transform() ----
ddply(DF, .(bloodtype), summarise, heightMean = mean(height)) # .()기준으로 요약
ddply(DF, .(bloodtype), transform, heightMean = mean(height)) # 기존 데이터에 변수를 수정 or 추가
ddply(DF, .(bloodtype), summarise, heightMean = mean(height) * 2) # 산술도 가능

## Specifying Multiple Variables ----
ddply(DF, .(bloodtype), summarise, heightMean = mean(height), heightMax = max(height))

## Output Another Data Type ----
ddply(DF, .(bloodtype))
dlply(DF, .(bloodtype))
ddply(DF, .(bloodtype, sex), summarise, heightMean = mean(height), heightMax = max(height))
daply(DF, .(bloodtype, sex), summarise, heightMean = mean(height), heightMax = max(height))

## llply() ----
(l <- list(a = 1 : 10, b = letters[1 : 4]))
llply(l, length)
base::lapply(DF, length)
base::apply(DF, 2, length)
plyr::llply(DF, length) # 사용하는 이유? : 다른 데이터형으로 출력이 용이하다.
ldply(l, length)
ldply(l, length, .progress = "text")
llply(1 : 1000000, identity, .progress = "text") # .progress : 진행상황을 알 수 있다.

## aaply(), adply() ----
a <- 1 : 6
dim(a) <- c(2, 3)
aaply(a, 1, range)
aaply(a, 1, mean)
aaply(a, 2, range)
a <- 1 : 24
dim(a) <- c(2, 6, 2)
a
aaply(a, 1, range)
aaply(a, 2, range)
aaply(a, 3, range)


# package : dplyr ----
library(dplyr)
df <- read.csv("example_studentlist2.csv", fileEncoding = "EUC-KR")
(DF <- tbl_df(df)) # dplyr용 data.frame 만들기 way 1
class(DF)
data.frame(x = 1 : 5, y = letters[1 : 5])
data_frame(x = 1 : 5, y = letters[1 : 5])
class(data_frame(1 : 3)) # dplyr용 data.frame 만들기 way 2

## Using dplyr ----
## select() ----
select(DF, sex)
select(DF, sex, bloodtype, height)
select(DF, sex : grade) # seq방법으로 가져오기
select(DF, -sex) # 특정 column 제외
select(DF, Height = height) # 변수명 변경
rename(DF, Height = height) # 변수 선택이 아닌 변수명을 바꾸는 것이 목표일 경우

## Chain function : %>% ----
DF %>% select(sex, height, weight) %>% filter(height > 170)

## filter() ----
filter(DF, sex == "남자")
filter(DF, sex == "남자" & height > 170)
filter(DF, sex == "남자" | height > 170)
filter(DF, sex == "남자", height > 170) # &

## arrange() ----
DF %>% filter(height > 160) %>% arrange(height)
DF %>% filter(height > 160) %>% arrange(desc(height)) # 내림차순
DF %>% filter(sex == "남자") %>% arrange(bloodtype, height)

## mutate() ----
DF %>% mutate(BMI = weight / (height / 100)^2)

## summarise() ----
DF %>% filter(sex == "남자") %>% summarise(heightMean = mean(height), weigthMean = mean(weight))

## group_by() ----
DF %>% group_by(sex) %>% summarise(heightMean = mean(height))

## slice() : 행 선택 ----
DF %>% filter(sex == "남자") %>% arrange(height) %>% slice(1 : 5)

## 비슷한 결과를 만드는 다양한 방법 ----
aggregate(DF$height, list(DF$bloodtype), mean)
by(DF$height, DF$bloodtype, mean)
tapply(DF$height, DF$bloodtype, mean)
ddply(DF, "bloodtype", summarise, mean(height))
lapply(split(DF$height, DF$bloodtype), mean)
DF %>% group_by(bloodtype) %>% summarise(mean(height))