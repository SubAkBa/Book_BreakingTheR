# Example01 - 20만건 관찰치(Observation)가 넘는 데이터셋의 명목형 변수 '도수분포표' 만들기 ----
# package : hflights
# Step1. 데이터셋 패키지를 불러온다.
install.packages("hflights")

# Step2. 패키지를 불러온다.
library(hflights)

# Step3. 데이터를 살펴본다.
head(hflights, 10)

# Step4. 데이터셋 구조 살펴보기
str(hflights)

# Step5. 특정 변수 살펴보기
(CountOfDest <- table(hflights$Dest))

# Step6. 명목형 변수 개수 세기
length(CountOfDest) # length(vector or list 등 데이터 관련 객체) - 원소의 길이를 알려줘.

# Step7. 범위 살펴보기
range(CountOfDest) # range(벡터) - 가장 작은 값과 가장 큰 값을 알려줘.

# Step8. 최소값과 최대값의 이름 찾기
CountOfDest[CountOfDest == 1]; CountOfDest[CountOfDest == 9820]

# Step9. 6000횟수가 넘는 공항 찾기
(SelectedDest <- CountOfDest[CountOfDest > 6000])

# Step10. 6000횟수가 넘는 공항들의 전체 합 구하기
addmargins(SelectedDest, margin = 1)

# Step11. 막대그래프로도 그려보기
barplot(SelectedDest)


# Example02 - 대장암 환자 자료 분석 ----
# package : ggplot2, ggthemes
# Step1. 데이터를 불러온다.
DF <- read.csv("example_cancer.csv")

# Step2. 데이터 구조를 살펴본다.
str(DF)

# Step3. 연령대별로 도수값을 구한다.
(DegreeOfAge <- table(cut(DF$age, breaks = (1 : 11) * 10)))

# Step4. 열값의 이름을 바꾼다.
rownames(DegreeOfAge) <- c("10s", "20s", "30s", "40s", "50", "60s", "70s", "80s", "90s", "100s")
DegreeOfAge

# Step5. 시각화
library(ggplot2)
library(ggthemes)
ggplot(data = DF, aes(x = age)) + geom_freqpoly(binwidth = 10, size = 1.4, colour = "orange") +
  theme_wsj()


# Example03 - 전국 커피숍 폐업 / 영업 상황 살펴보기 ----
# package : data.table, ggplot2
# Step1. 필요한 패키지를 먼저 불러온다.
library(data.table)
library(ggplot2)

# Step2. read.csv()보다 빠른 fread()로 데이터를 불러온다.
DF <- fread("example_coffee.csv", stringsAsFactors = F, # fread : observation과 한글이 많아
            header = T, data.table = F)                 #         데이터가 큰 경우 read.csv()
                                                        #         보다 몇 십 배 빠르다.

# Step3. 데이터의 구조를 살펴본다.
str(DF)

# Step4. 불필요한 변수 몇 개를 삭제한다.
DF <- subset(DF, select = c(-adress, -adressBystreet, -dateOfclosure, 
                            -startdateOfcessation, -duedateOfcessation, -dateOfreOpen, -zip))
str(DF)

# Step5. 최초 커피숍 찾기
range(DF$yearOfStart, na.rm = T)
subset(DF, subset = (yearOfStart == 1964))
DFFilter <- subset(DF, subset = (stateOfbusiness == "운영중"))
range(DFFilter$yearOfStart, na.rm = T)
subset(DFFilter, subset = (yearOfStart == 1967))

# Step6. 해마다 오픈한 커피숍 개수를 찾기
table(DF$yearOfStart)

# Step7. 막대그래프로 그린다.
qplot(yearOfStart, data = DF, geom = "bar")

# Step8. 영업상태 및 연도에 따른 분할표를 만든다.
(Freq <- table(DF$stateOfbusiness, DF$yearOfStart))

# Step9. 1997년도 이상 데이터만 저장한다.
which(colnames(Freq) == "1997") # which(논리값이 있는 객체) - True값이 어딘지 알려줘.
which.max(colnames(Freq))
Freq <- Freq[, c(30 : 47)]

# Step10. 비율도 살펴 볼 수 있다.
(PFreq <- prop.table(Freq, margin = 2))

# Step11. 새로운 데이터프레임으로 자료를 모은다.
(NewDF <- data.frame(colnames(Freq), Freq[1, ], Freq[2, ], PFreq[1, ], PFreq[2, ]))
rownames(NewDF) <- NULL
colnames(NewDF) <- c("Time", "Open", "Close", "POpen", "PClose")
NewDF
ggplot(NewDF, aes(x = factor(Time), y = Close, group = 1)) +
  geom_line(colour = "steelblue1", size = 1) +
  geom_point(colour = "steelblue", size = 3) +
  geom_line(aes(y = Open), colour = "tomato2", size = 1) +
  geom_point(aes(y = Open), colour = "red", size = 6) + theme_bw()


# Example04 - 전국 커피숍 규모 파악하기 ----
# package : data.table
# Step1. 빠르게 불러오기 위해 data.table패키지를 로드한다.
library(data.table)

# Step2. 데이터를 불러온다.
DF <- fread("example_coffee.csv", header = T, stringsAsFactors = F, data.table = F)

# Step3. 사업장 규모 변수만 별도 객체에 저장한다.
Size <- DF$sizeOfsite

# Step4. 자료의 특성을 파악한다.
summary(Size)

# Step5. plot으로 그려본다.
plot(Size)

# Step6. Outlier를 삭제한다.
Size[Size > 10000] <- NA
summary(Size)

# Step7. 0값과 NA를 삭제한다.
Size[Size == 0] <- NA
Size <- Size[complete.cases(Size)]
summary(Size)

# Step8. 20단위로 계급을 만든다.
(DegreeOfSize <- table(cut(Size, breaks = (0 : 72) * 20)))

# Step9. 그래프를 그린다.
library(ggplot2)
library(ggthemes)
ggplot(data = DF, aes(x = sizeOfsite)) +
  geom_freqpoly(binwidth = 10, size = 1.2, colour = "orange") +
  scale_x_continuous(limits = c(0, 300), breaks = seq(0, 300, 20)) +
  theme_wsj()


# Example05 - 전국 인구조사 자료 정리하기(전처리 연습) ----
# package : stringr, ggplot2, ggthemes
# Step1. 데이터를 불러와서 살펴본다.
DF <- read.csv("example_population.csv", stringsAsFactors = F) # stringAsFactors = F 이유?
str(DF)                                                        # 인구수에 "," 있기때문에 factor
head(DF, 5)                                                    # 로 인식된다.

# Step2. 문자열을 정리하기 위해 외부 패키지를 설치한다.
library(stringr)

# Step3. '('를 기준으로 나눠서 앞 문자열만 사용합니다.
temp <- str_split_fixed(DF[, 1], "\\(", 2) # str_split_fixed(문자열, 분리할 기준 문자, 분리할 개수)
head(temp, 10)                             # strsplit()도 있지만 리스트로 반환

# Step4. 공백을 기준으로 '시(City)'와 '구'를 나눈다.
NewCity <- str_split_fixed(temp[, 1], " ", 2)
head(NewCity, 10)

# Step5. 변수 이름을 바꿔준다.
colnames(NewCity) <- c("Provinces", "City")

# Step6. 작업한 변수들을 합친다.
DF <- data.frame(NewCity, DF[, c(2 : 7)])
head(DF, 3)

# Step7. City 값 중 빈 곳을 NA로 바꾼다.
DF[DF == " "] <- NA
head(DF, 10)

# Step8. NA가 있는 행을 삭제한다.
DF <- DF[complete.cases(DF), ]
head(DF, 10)

# Step9. 문자열 변수를 수치형 변수로 변경
for(i in 3 : 8){
  DF[, i] <- sapply(DF[, i], function(x) gsub(",", "", x))
  DF[, i] <- as.numeric(DF[, i])
}
str(DF)

# Step10. 경기도만 불러온다.
(ProPopul <- tapply(DF$Population, DF$Provinces, sum)) # tapply(적용할 변수, 그룹지을 변수,
                                                       #        적용할 함수)

# Step11. Factor변수 정리하고 다시 보기
DF[, 1] <- factor(DF[, 1])
(ProPopul <- tapply(DF$Population, DF$Provinces, sum))

# Step12. ggplot2로 그래프를 그린다.
(Graph <- ggplot(DF, aes(x = Provinces, y = Population, fill = Provinces)) +
    geom_bar(stat = "identity") + theme_wsj())

# Step13. csv로 저장하기
write.csv(DF, "example_population_f.csv")
