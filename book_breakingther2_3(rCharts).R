# rCharts : JavaScript로 된 Graphic library를 R에서 사용할 수 있도록 도와주는 package ----
## 설치하기
library(devtools)
install_github("ramnathv/rCharts") # 한글 지원이 되지 않는다.
install_github("saurfang/rCharts", ref = "utf8-writelines")

## package::rChart 사용하기
## 1. rCharts패키지의 기본 함수로 그래프 그리기(D3의 유명한 library를 내장한 fuction)
## 2. 외부 JS library를 수동으로 불러와 원하는 그래프를 그리기(조금 어렵지만 다양한 그래프)
install.packages("Rcpp", dependencies = T)
library(rCharts)
hair_eye_male <- subset(as.data.frame(HairEyeColor), Sex == "Male")
(n1 <- nPlot(Freq ~ Hair, group = "Eye", data = hair_eye_male, type = "multiBarChart"))

## nPlot() 자세히 살펴보기 ----
DF <- read.csv("example_studentlist2.csv")
(n1 <- nPlot(height ~ weight, group = "sex", data = DF, type = "scatterChart"))
                              # data와 formula를 제외하고는 모두 문자열로 넣어야 한다.
                              # type - sctterChart             : 산포도
                              #        pieChart                : 파이차트
                              #        lineChart               : 라인차트
                              #        multiBarChart           : 멀티막대차트
                              #        multiBarHorizontalChart : 멀티막대그래프(가로모드)
                              #        stackedAreaChart        : 누적영역차트
                              #        multiChart              : 여러차트를 한 번에 그리기
## pieChart ----
(n2 <- nPlot(~bloodtype, data = DF, type = "pieChart"))
n2$chart(donut = T)
n2

## multiBarChart ----
## -> 데이터를 전처리해야 한다.
library(dplyr)
DF2 <- DF %>% group_by(bloodtype, sex) %>% summarise(Freq = n())
(n4 <- nPlot(Freq ~ bloodtype, data = DF2, group = "sex", type = "multiBarChart"))
(n5 <- nPlot(Freq ~ bloodtype, data = DF2, group = "sex", type = "multiBarHorizontalChart"))

## lineChart ----
TS <- read.csv("example_ts2.csv")
TS$time <- as.Date(TS$time)
TS2 <- subset(TS, subset = (year == 2014))
(n5 <- nPlot(sales ~ time, data = TS2, type = "lineChart"))
n5$xAxis(
  tickFormat = "#!function(d){return d3.time.format('%Y-%m-%d')(new Date(d*1000*3600*24));}!#",
  rotateLabels = -90)
n5

## stackedAreaChart ----
TS3 <- read.csv("example_ts3.csv") # 4가지 제품에 따른 매출액 데이터
TS3$time <- as.Date(TS3$time)
(n6 <- nPlot(sales ~ time, data = TS3, group = "product", type = "stackedAreaChart"))
n6$xAxis(
  tickFormat = "#!function(d){return d3.time.format('%Y-%m-%d')(new Date(d*1000*3600*24));}!#", 
  rotateLabels = -90)
n6

## lineWithFocusChart ----
(n7 <- nPlot(sales ~ time, group = "product", data = TS3, type = "lineWithFocusChart"))
