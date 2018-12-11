# Data type ----
# Variable - 1. 질적 - 1) 명목형 : 관찰대상을 어떤 집단이나 범주로 구분하는 값(숫자, 문자로 표현)
#                                  숫자의 산술적 의미가 없다. ex) 성별, 혈액형
#                      2) 순서형 : 범주의 구분 이상으로 순서를 정할 수 있다. ex) 성적
#            2. 양적 - 1) 이산형 : 값 사이에 간격이 있다. ex) 1명, 2명, 3명
#                      2) 연속형 : 어떤 구간 안에 어떠한 값이라도 연속하여 취할 수 있는 데이터
#                                  ex) 175cm ~ 181cm


# Vector - R의 최소 데이터 단위 ----
# 1. character : 문자열 2. factor : 순서, 명목형 3. integer : 이산형 4. numeric : 연속형
# 01. example - 여러 종류 벡터 만들기 ----
(a1 <- c(5, 3, 6, 3, 1))
is(a1)
a1 <- c(1L, 2L, 3L) # L을 붙이면 number가 아니라 'integer'
a1 <- as.integer(a1)
is(a1) # integer와 numeric 구분 why?) 연산 속도 차이
(b <- c(1.23, 6.63452, 4.34234))
is(b)
(a2 <- c("짬뽕", "짜장면", "짬뽕", "짬뽕", "짜장면"))
(a3 <- c(7, 3, 7, 5, 2, "짜장면"))
is(a3) # vector는 여러 타입이 섞이지 않는다.
(a2 <- as.factor(a2))
is(a2) # factor는 계산을 목적으로 숫자로 바꿔서 사용하기도 한다.
(a2 <- factor(a2, ordered = T))
(a5 <- factor(c("남", "여", "여", "남"), levels = c("남", "여", "소녀")))


# Data.frame ----
# 02. example - 여러 개 벡터를 만들어 데이터프레임 만들기 ----
(a1 <- c(5, 3, 6, 3, 1))
(a2 <- c("짬뽕", "짜장면", "짬뽕", "짬뽕", "짜장면"))
(a3 <- c(3.62, 5.45, 2.54, 3.67, 7.23))
(DF <- data.frame(a1, a2, a3)) # 데이터프레임을 만들경우 벡터 길이(원소 개수)가 같아야 한다.
(DF <- data.frame(count = a1, food = a2, meanCount = a3))

# 03. example - 외부 데이터 가져오기와 변수 선택하기 ----
(DF <- read.csv("example_studentlist.csv")) # read.csv("filename.cv", header = T)
is.vector(DF$height)
str(DF)
DF$height
mean(DF$height)
(Height <- DF$height)
DF[[7]]; DF[7]
class(DF[[7]]); class(DF[7]) # [[]] 한 단계 더 들어가 값 자체를 가져온다.

# 04. example - 여러 개 변수 선택하기 ----
DF <- read.csv("example_studentlist.csv")
DF[c(6, 7)]
DF[c("bloodtype", "height")]
DF[, 7]; DF[2, ]; DF[2, 1]
DF[, "height"]; DF[, c(6, 7)]
class(DF[, c(6, 7)]); class(DF[, 7]) # 1개 : vector, 2개 이상 : data.frame

# 05. example - 쉽게 변수 선택하기 ----
DF <- read.csv("example_studentlist.csv")
attach(DF); search()
height
height[1] <- NA
DF # height는 DF와 상관없는 별도의 객체 -> 값이 변하지 않는다.
ls(DF)
detach(DF); search()
DF2 <- DF
attach(DF2, pos = 6); search()

# 06. example - 조건으로 변수 선택하기 ----
DF <- read.csv("example_studentlist.csv")
subset(DF, subset = (height > 170))
subset(DF, select = c(name, height), subset = (height > 180))
subset(DF, select = -height)
subset(DF, select = c(-height, -weight))

# 07. example - 변수명 바꾸기 ----
DF <- read.csv("example_studentlist.csv")
colnames(DF)
colnames(DF)[6] <- "blood"; DF
OldList <- colnames(DF)
NewList <- c("na", "se", "ag", "gr", "ab", "bl", "he", "we")
colnames(DF) <- NewList; DF

# 08. example - 새로운 변수 옆에 붙이기 ----
DF <- read.csv("example_studentlist.csv")
(BMI <- DF$weight / DF$height^2)
(DF <- cbind(DF, BMI))

# 09. example - 더 복잡한 새로운 변수 붙이기 ----
DF <- read.csv("example_studentlist.csv")
(Omit <- read.csv("omit.csv"))
(DF <- merge(DF, Omit, by = "name"))

# 10. example - 행으로 추가하기 ----
DF <- read.csv("example_studentlist.csv")
(AddCol <- data.frame(name = "이미리", sex = "여자", age = "24", grade = "4",
                     absence = "무", bloodtype = "A", height = 175.2, weight = 51))
(DF <- rbind(DF, AddCol))

# 11. example - 모든 종류의 데이터 객체를 리스트 객체에 담기 ----
DF <- read.csv("example_studentlist.csv")
a <- c(1 : 20)
s <- c("파스타", "짬뽕", "순두부 찌개", "요거트 아이스크림", "커피")
L <- c(T, F, F, T, T, T)
(List <- list(DF, a, s, L, mean))
(List <- list(DataFrame = DF, Number = a, Character = s, Logic = L))
List[1] <- NULL
List["Number"]
List[1]; class(List[1])
List[[1]]; class(List[[1]])
List[c(2, 3)]
List[c("Number", "Character")]
List$Number; class(List$Number); List$Character; class(List$Character)
names(List)[2] <- "Num"; List[2]
names(List) <- c("Num", "Cha", "Log"); List

# 12. example - 리스트 모든 항목에 동일한 함수 적용하기 ----
DF <- read.csv("example_studentlist.csv")
(HeightBySex <- split(DF$height, DF$sex)) # split(데이터, 나눌 명목형 변수 기준)
mean(HeightBySex[[1]]); mean(HeightBySex[[2]])
sapply(HeightBySex, mean)
sapply(HeightBySex, sd)
sapply(HeightBySex, range)

# 13. example - 명목형 변수로 '도수분포표' 만들기 ----
(DF <- read.csv("example_studentlist.csv"))
(Freq <- table(DF$bloodtype))
(RelativeFreq <- prop.table(Freq))
(Table <- rbind(Freq, RelativeFreq))
(Table <- addmargins(Table, margin = 2)) # addmargins(테이블 객체, margin = 합구하는방식)
                                         #            margin - 생략 : 행과 열의 합
                                         #                        1 : 열의 합
                                         #                        2 : 행의 합

# 14. example - R에서 연속형 분수를 '도수분포표'로 만들기 ----
DF <- read.csv("example_studentlist.csv")
(FactorOfHeight <- cut(DF$height, breaks = 4)) # cut(나눌 변수, breaks = 나누고 싶은 구간의 개수,
                                               #     labels = 나눈 구간의 이름)
(FreqOfHeight <- table(FactorOfHeight))
(FreqOfHeight <- rbind(FreqOfHeight, prop.table(FreqOfHeight)))
rownames(FreqOfHeight)[2] <- "RelativeFreq"
FreqOfHeight
(CumuFreq <- cumsum(FreqOfHeight[2, ]))
rownames(FreqOfHeight) <- c("도수", "상대도수", "누적도수")
FreqOfHeight
(FreqOfHeight <- addmargins(FreqOfHeight, margin = 2))

# 15. example - 분할표 만들기 ----
DF <- read.csv("example_studentlist.csv")
(CT <- table(DF$sex, DF$bloodtype))
addmargins(CT)
(PropCT <- prop.table(CT))
addmargins(PropCT)
(PropCT <- prop.table(CT, margin = 1)) # prop.table - 생략 : 행과 열 비율 모두 계산
                                       #                 1 : 행으로 비율 계산
                                       #                 2 : 열로 비율 계산
addmargins(PropCT, margin = 2)

# 더 알아보기 - 결측치 다루는 여러가지 방법 ----
(a <- c(1, 2, 3, 4, NA, 6, 7, 8, 9, 10))
complete.cases(a)
(a <- a[complete.cases(a)])
(a <- c(1, 2, 3, 4, NA, 6, 7, 8, 9, 10))
(a <- na.omit(a))

# 더 알아보기 - Rmarkdown으로 쉽게 코딩하기 ----
# 1. RStudio 실행 File -> New File -> Rmarkdown
# 2. Format : HTML 선택
# 3. Code -> insert Chunk or 단축키 Ctrl + Alt + I
# 4. Code 입력
# 5. 커서를 Chunk 내 어디든 가져다 놓고 Ctrl + Alt + C
# 6. Ctrl + Alt + I를 눌러 Chunk를 추가하고 코드 작성 (커서가 위치한 Chunk만 실행)
# 7. Ctrl + Alt + R을 눌러 Rmarkdown 전체 실행
# 8. Rmarkdown문서 저장 후 (확장자 : .Rmd) Ctrl + Shift + K