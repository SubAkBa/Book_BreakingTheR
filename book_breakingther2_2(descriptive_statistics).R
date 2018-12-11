# 관심있는 어떤 집단의 특성을 
# 나타내는 대표적인 특성치 - 1. 중심화 경향치 - 평균, 중앙값, 최빈값
#                            2. 산포도 - 분산, 표준편차, 범위, 사분위수
## ∂ : sigma (모집단의 표준편차)
## ∑ : 'summation'
## Mu : 모평균(뮤) - 확률을 통해 신뢰수준과 함께 그 값의 범위를 추정(estimation)
## xbar : 표본평균
## 기술통계에서 말하는 값들은 모두 '표본'에 해당한다.
# 중심화 경향치
# 1) 평균(Mean) - sum(전체 데이터) / count(전체 데이터)
# 2) 이상치(Outlier) - 다른 데이터들 보다 극단적으로 크거나 작은 값(무조건 제거하면 안된다.)
# 3) 중앙값(Median) - count(전체 데이터) 홀수 - 가운데 값
#                                        짝수 - sum(가운데 2개의 값) / 2

# 산포도
# 1) 범위(Range) - 수치형 연속변수가 주어졌을 때 최소값과 최대값 사이
# 2) 사분위범위(Interquartile Range) - 25%, 50%, 75%, 100% 나눈 사분위수에서 25%와 75% 사이의 값들
#              (IQR)                   50%는 'Median'
# 3) 분산(Variance) - 평균에서 값들이 얼마나 떨어져 있는지 알려주는 값
# 4) 표준편차(Standard Deviation) - 각각의 값들이 평균적으로 흩어져있는 정도
#                                   편차(각 값들 - 평균)제곱의 합 why제곱? : 편차들의 합은 0
#                                   데이터들이 평균으로부터 떨어진 거리의 평균값
# 모집단 모분산 - ∂^2, 표준편차 - ∂
# 표본 표본분산 - S^2, 표준편차 - S

# 표준화 - 기준이 다른 데이터를 비교
# 1. 평균에서 각 값들까지의 거리, '편차'를 계산
# 2. 각각의 값을 표준편차로 나눠준다. -> 표준편차가 1이 된다.
# 3. 평균 : 0, 표준편차 : 1로 만드는 것을 '표준화'라고 한다.

# 공분산 - 두 확률변수  X와 Y가 있을 때, 
#           X의 증가 할 때 Y가 감소하는지 증가하는지 정도를 측정하는 방법
#           (공분산은 단위에 영향을 받는다.)
# 상관계수 - 공분산을 각 변수의 표준편차로 나눈 값(단위에 영향을 받지 않는다.)
# 모집단상관계수 - p(로우), 표본상관 - Y(감마)

# Function : mean() - 평균, median() - 중앙값, range() - 범위, quantile() - 사분위, ----
#            boxplot(), var() - 분산, sd() - 표준편차, scale() - 정규화
#            sd() / mean() - 변동계수, cor(x, y) - 상관계수, cov(x, y) - 공분산
library(data.table)
(DF <- fread("example_studentlist.csv", data.table = F))
detach(DF)
attach(DF)

# (1) mean() ----
mean(height, na.rm = T)

# (2) median() ----
median(height, na.rm = T)

# (3) range() ----
range(height, na.rm = T)

# (4) quantile() ----
quantile(height, na.rm = T)

# (5) IQR() ----
IQR(height, na.rm = T)
IQR(height, na.rm = T, type = 7)
IQR(height, na.rm = T, type = 5)
IQR(height, na.rm = T, type = 3)

# (6) summary() : 평균, 중앙값, Q1, Q3 한 번에 보기 ----
summary(height, na.rm = T)

# (7) boxplot() ----
boxplot(height)

# (8) cor() ----
cor(height, weight)
cor.test(height, weight)
cor(DF[, c(3, 7, 8)])

# (9) 여러 변수를 다루는 함수에서 결측치 다루기 ----
cor(height, weight, na.rm = T)
cor(height, weight, use = "complete.obs") # 결측치를 빼서 계산
DF2 <- DF
DF2[2, 7] <- NA
DF2[4, 8] <- NA
DF2
detach(DF)
attach(DF2)
cor(height, weight)
cor(height, weight, use = "complete.obs")
cor(height, weight, use = "pairwise.complete.obs") # observation 자체를 빼지 않고
                                                   # NA가 포함된 벡터에서만 빼고 계산
cor(height, weight, use = "everything") # na.rm = F
cor(height, weight, use = "all.obs") # 결측치가 있다면 계산 실행하지 않는다.

# (10) var(), cov() ----
detach(DF2)
attach(DF)
var(height, na.rm = T)
var(height, weight, na.rm = T)
cov(height, weight, use = "complete.obs")
var(DF[, c(3, 7, 8)], na.rm = T)
cov(DF[, c(3, 7, 8)], use = "complete.obs")

# (11) sd() ----
sd(height, na.rm = T)

# (12) scale() ----
height; scale(height)
(height - mean(height)) / sd(height)

# (13) 변동계수 : 표준편차 / 평균값이다. 표준편차는 평균값이 큰 데이터 쪽이 커지는 경향이 있다. 
#                 따라서 다른 평균값을 가진 데이터를 비교하는 경우, 
#                 표준편차를 기준으로 하면 적당하지 않은 경우가 있다. 
#                 변동계수는 표준편차를 평균값으로 나눔으로써 이 평균값의 차이를 조정하고 있다. 
#                 (3, 5, 12, 5, 8)라는 데이터 계열과 (15, 25, 60, 25, 40)라는 데이터 계열은 
#                 각각 3.14, 15.68이라는 표준편차를 가진다. 
#                 따라서 후자 쪽의 데이터가 편차가 큰 것 같이 보이지만 
#                 변동계수를 계산하면 양자는 0.475라는 같은 값을 갖는다.
sd(height) / mean(height)
sd(weight) / mean(weight) # height 보다 weight이 더 많이 분산되어 있다.
