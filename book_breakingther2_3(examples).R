# Example01 - 섬세한 그래프를 그려 데이터 분석하기 ----
# package : ggplot2, ggthemes
# Step1. 데이터를 확인한다.
str(diamonds)

# Step2. 필요한 패키지를 불러온다.
library(ggplot2)
library(ggthemes)

# Step3. 그래프를 그린다.
ggplot(diamonds, aes(x = x, y = price)) + geom_point()
ggplot(diamonds, aes(x = x, y = price, colour = clarity)) + geom_point()
                                       # 어떤 clarity는 여러 값에 분포되어 있어 price에 영향을
                                       # 미치지 않지만 어떤 clarity는 특정 price에 몰려있다.
                                       # price가 낮은 다이아몬드에 쓰이는 clarity와 price가
                                       # 높은 다이아몬드에 쓰이는 clarity가 있을 것이다.

# Step4. 테마를 적용한다.
ggplot(diamonds, aes(x = x, y = price, colour = clarity)) + geom_point() + theme_solarized_2()

# Step5. Alpha값을 조절한다.
ggplot(diamonds, aes(x = x, y = price, colour = clarity)) + geom_point(alpha = 0.03) + 
  theme_solarized_2() # price가 8000까지 몰려있고 그 이상부터 개수가 
                      # 급격히 떨어지는 것을 확인할수 있다.

# Step6. legend만 alpha값이 1이 되도록 한다.
ggplot(diamonds, aes(x = x, y = price, colour = clarity)) + geom_point(alpha = 0.03) +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) + theme_solarized_2()
                  # guide함수를 이용해 범례를 재정의

# Step7. X축과 Y축의 범위를 줄인다.
ggplot(diamonds, aes(x = x, y = price, colour = clarity)) + geom_point(alpha = 0.03) +
  geom_hline(yintercept = mean(diamonds$price), color = "turquoise3", alpha = .8) +
  guides(colour = guide_legend(override.aes = list(alpha = 1))) + xlim(3, 9) +
  theme_solarized_2()


# Example02 - 시계열데이터 라인 그래프로 나타내기 ----
# package : ggplot2, ggthemes
# Step1. 데이터를 불러온다.
(TS <- read.csv("example_ts.csv"))

# Step2. 필요한 패키지를 불러온다.
library(ggplot2)
library(ggthemes)

# Step3. 그래프를 그려본다.
ggplot(TS, aes(x = Date, y = Sales)) + geom_line() # 모든 값이 표시되지 않는다.
                                                   # 1. 연속된 날짜 값으로 바꿔주기
                                                   # 2. 모든 값을 요인 값으로 바꿔주기

# Step4. factor()함수로 요인화 한다.
ggplot(TS, aes(x = factor(Date), y = Sales, group = 1)) + geom_line() # group은 1가지

# Step5. 점을 추가한다.
ggplot(TS, aes(x = factor(Date), y = Sales, group = 1)) + geom_line() + geom_point()

# Step6. 테마 적용
ggplot(TS, aes(x = factor(Date), y = Sales, group = 1)) + geom_line() + geom_point() + 
  theme_light()

# Step7. 디자인 개선
ggplot(TS, aes(x = factor(Date), y = Sales, group = 1)) + geom_line(colour = "orange1", size = 1) +
  geom_point(colour = "orange2", size = 4) + theme_light()

# Step8. X축과 Y축의 이름을 바꾼다.
ggplot(TS, aes(x = factor(Date), y = Sales, group = 1)) + geom_line(colour = "orange1", size = 1) +
  geom_point(colour = "orangered2", size = 4) + xlab("년도") + ylab("매출") +
  ggtitle("A기업 월별 매출") + theme_light()


# Example03 - dplyr패키지를 이용해 원하는 데이터 쉽게 선택해 그래프로 나타내기 ----
# package : dplyr, ggplot2, ggthemes
# Step1. 필요한 패키지를 불러온다.
library(dplyr)
library(ggplot2)
library(ggthemes)

# Step2. 데이터를 불러온다.
DF <- read.csv("example_population_f.csv")
DF <- DF[, -1] # 첫 번째 열은 ID숫자이기 때문에 삭제
(DF <- tbl_df(DF)) # dplyr에서 data.frame을 다룰 수 있도록 변환
                   # tbl_df(데이터 프레임 객체) - dplyr객체 속성을 추가하라.

# Step3. 충청도만 따로 객체에 담는다.
DF2 <- filter(DF, Provinces == "충청북도" | Provinces == "충청남도")
                  # filter(data.frame 객체, 변수명(조건) 변수값) - 조건에 맞는 행을 반환하라.

# Step4. 그래프 그리기
(Graph <- ggplot(DF2, aes(x = City, y = Population, fill = Provinces)) + 
    geom_bar(stat = "identity") + theme_wsj())

# Step5. 오름차순으로 정렬하기.
(GraphReorder <- ggplot(DF2, aes(x = reorder(City, Population),
                                 y = Population, fill = Provinces)) + 
    geom_bar(stat = "identity") + theme_wsj()) 
                             # reorder(정렬할 객체(factor), 정렬할 기준(numeric)) - 정렬하라.

# Step6. 남자비율이 높고 1인가구가 많은 도시를 필터링
DF3 <- filter(DF, SexRatio > 1, PersInHou < 2)

# Step7. 그래프로 그린다.
(Graph <- ggplot(DF3, aes(x = City, y = SexRatio, fill = Provinces)) +
    geom_bar(stat = "identity") + theme_wsj())


# Example04 - dplyr패키지를 이용해 필요한 데이터를 만들고 그래프로 나타내기 ----
# package : dplyr, ggplot2, ggthemes
# Step1. 필요한 패키지를 불러온다.
library(dplyr)
library(ggplot2)
library(ggthemes)

# Step2. 데이터 불러오기
DF <- read.csv("example_population_f.csv")
DF <- DF[, -1]

# Step3. 남녀비율을 문자로 나타내는 변수를 추가한다.
DF <- mutate(DF, SexF = ifelse(SexRatio < 1, "여자비율높음", 
                               ifelse(SexRatio > 1, "남자비율높음", "남여비율같음")))
                 # mutate(data.frame 객체, 추가할 변수명 = 추가할 내용)
                 # - 조건에 맞는 새로운 변수를 추가하라.

# Step4. 새로운 변수를 순서형 변수로 바꾼다.
DF$SexF <- factor(DF$SexF)
DF$SexF <- ordered(DF$SexF, c("여자비율높음", "남여비율같음", "남자비율높음"))

# Step5. 경기도 데이터만 DF2에 따로 저장한다.
DF2 <- filter(DF, Provinces == "경기도")

# Step6. 그래프 그리기.
(Graph <- ggplot(DF2, aes(x = City, y = (SexRatio - 1), fill = SexF)) + 
    geom_bar(stat = "identity", position = "identity")) + theme_wsj()
                                # position = "identity"를 넣어야 음수인 경우 에러 메시지 방지
                                # 경기도는 남자비율이 지나치게 높다.

# Step7. 서울 데이머나 DF3에 따로 저장한다.
DF4 <- filter(DF, Provinces == "서울특별시")

# Step8. 그래프 그리기.
(Graph2 <- ggplot(DF4, aes(x = City, y = (SexRatio - 1), fill = SexF)) + 
    geom_bar(stat = "identity", position = "identity") + theme_wsj()) 
                                # 서울은 여자비율이 더 높다.