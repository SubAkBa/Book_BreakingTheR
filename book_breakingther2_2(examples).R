# Example01 - 전국 연령별 평균 월급 조사 ----
# package : ggplot2, ggthemes
# Step1. 데이터를 불러온다.
DF <- read.csv("example_salary.csv", stringsAsFactors = T, na = "-") # '-'표시된 모든 데이터는 NA
head(DF, 5)

# Step2. 변수명 변경(한글 -> 영문)
colnames(DF)
colnames(DF) <- c("age", "salary", "specialSalary", "workingTime", "numberOfWorker",
                  "career", "sex")
str(DF)

# Step3. 검색목록에 data.frame을 올린다.
detach(DF)
attach(DF)

# Step4. 평균 구하기
(Mean <- mean(salary, na.rm = T))

# Step5. 중앙값 구하기
(Mid <- median(salary, na.rm = T))

# Step6. 범위 구하기
(Range <- range(salary, na.rm = T))
w <- which(DF$salary == 4064286)
DF[w, ]

# Step7. 사분위 구하기
(Qnt <- quantile(salary, na.rm = T))

# Step8. 모두 모아 리스트에 담는다.
(Salary <- list(평균월급 = Mean, 중앙값월급 = Mid, 월급범위 = Range, 월급사분위 = Qnt))


# Example02 - 그룹별 평균구하기 ----
# package : ggplot2. ggthemes
# Step1. 데이터를 불러온다.
DF <- read.csv("example_salary.csv", stringsAsFactors = F, na  = "-")

# Step2. 변수명을 바꾼다.
colnames(DF)
colnames(DF) <- c("age", "salary", "specialSalary", "workingTime", "numberOfWorker",
                  "career", "sex")

# Step3. 성별로 평균월급을 구한다.
(temp <- tapply(DF$salary, DF$sex, mean, na.rm = T)) # 1인자를 2인자를 기준으로 3인자함수로 처리

# Step4. 그래프로 그려본다.
library(reshape2)
library(ggplot2)
melt <- melt(temp)
ggplot(melt, aes(x = Var1, y = value, fill = Var1)) + geom_bar(stat = "identity")

# Step5. 표준편차를 구한다.
tapply(DF$salary, DF$sex, sd, na.rm = T)
tapply(DF$salary, DF$sex, range, na.rm = T)

# Step6. 경력별 평균월급을 구한다.
(temp <- tapply(DF$salary, DF$career, mean, na.rm = T))

# Step7. 그래프를 그린다.
melt <- melt(temp)
ggplot(melt, aes(x = Var1, y = value, group = 1))+
  geom_line(colour = "skyblue2", size = 2) + coord_polar() +
  ylim(0, max(melt$value))

# Step8. 표준편차를 구한다.
tapply(DF$salary, DF$career, sd, na.rm = T)

# Step9. 경력별 범위를 구한다.
tapply(DF$salary, DF$career, range, na.rm = T)

# Step10. 가장 적은 월급 진단을 찾는다.
a1 <- DF[which(DF$salary == 1172399), ]
a2 <- DF[which(DF$salary == 1685204), ]
a3 <- DF[which(DF$salary == 1117605), ]
a4 <- DF[which(DF$salary == 1245540), ]
a5 <- DF[which(DF$salary == 1548036), ]
(list <- list(a1, a2, a3, a4, a5))


# Example03 - 아웃라이어 찾기와 제거하기 ----
# package : ggplot2, ggthemes
# Step1. 데이터를 불러온다.
DF <- read.csv("example_cancer.csv", stringsAsFactors = F, na = "기록없음")
str(DF)
detach(DF)
attach(DF)

# Step2. 나이의 평균을 구한다.
mean(age)

# Step3. age변수의 특징을 알아본다.
summary(age)

# Step4. 그래프로 아웃라이어를 찾는다.
boxplot(age, range = 1.5)
grid()

# Step5. 먼저 IQR의 길이를 알아낸다.
distIQR <- IQR(age, na.rm = T)

# Step6. IQR의 위치를 구한다.
(posIQR <- quantile(age, probs = c(0.25, 0.75), na.rm = T)) # probs = c(0.1, 0.9)

# Step7. IQR위치에서 1.5배 더한 위치를 구한다.
DownWhisker <- posIQR[[1]] - distIQR * 1.5
UpWhisker <- posIQR[[2]] + distIQR * 1.5
DownWhisker; UpWhisker

# Step8. 아웃라이어만 따로 저장한다.
(Outlier <- subset(DF, subset = (DF$age < DownWhisker | DF$age > UpWhisker)))


# Example04 - 평균값 표준화하여 그래프를 그려 한눈에 보기 ----
# package : ggplot2, ggthemes
# Step1. 데이터를 불러온다.
DF <- read.csv("example_salary.csv", stringsAsFactors = F, na = "-")
head(DF, 5)

# Step2. 변수명을 바꾼다.
colnames(DF) <- c("age", "salary", "specialSalary", "workingTime", "numberOfWorker",
                  "career", "sex")

# Step3. 정규화 시킨다.
Scale <- scale(DF$salary)
head(Scale, 10)

# Step4. DF객체에 추가합니다.
DF <- cbind(DF, scale = Scale)
str(DF)

# Step5. 그래프로 나타내기.
g1 <- ggplot(DF, aes(x = scale, y = age))
g2 <- geom_segment(aes(yend = age), xend = 0)
(g3 <- g1 + g2 + geom_point(size = 7, aes(colour = sex, shape = career)) +
    theme_minimal())