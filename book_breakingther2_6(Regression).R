# 회귀 분석(Regression)
# 1. 단순 선형 회귀분석(Simple linear Regression)
# - 회귀분석을 왜 할까?
# - 상관계수 : 변수간의 관계(relationship)를 -1 ~ 1 이라는 표준화된 수치로 기술(description) 할 수 있게 한다.
# - 회귀분석 : 특정 변수의 변화에 따라 다른 변수들이 변동하는 즉, 
#              인과관계(casualty)를 설명(explanation)해주기 때문이다.
# ex) 월 소득은 100만원인 사람의 월 지출은 50만원이다.
#     월 소득은 200만원인 사람의 월 지출은 100만원이다.
#     월 소득은 300만원인 사람의 월 지출은 150만원이다.
#     월 소득은 400만원인 사람의 월 지출은 200만원이다.
#     -> 월 소득이 500만원인 사람의 월 지출은 250만원일 것이라고 추측할 수 있다. (y = 0.5x)
#        y = 0.5x : 회귀모형 (x축은 독립변수, y축은 종속변수)
# 잔차(Residuals) : 관측치와 예측치의 오차

# Examples
# 1) 기본 회귀모형 실습
# Step1. 데이터 준비하기
DF <- data.frame(Work_hour = 1 : 7, Total_pay = seq(10000, 70000, by = 10000))
                 # WorkHour : X좌표, TotalPay : Y좌표

# Step2. 좌표에 데이터 그리기
plot(Total_pay ~ Work_hour, data = DF, pch = 20, col = "red")
grid()

# Step3. 절편과 기울기 구하기
(LR <- lm(Total_pay ~ Work_hour, data = DF))

# Step4. Lm속성 살펴보기
mode(LR)
names(LR)

# Step5. 절편과 기울기 라인을 그린다.
grid()
abline(LR, col = "blue", lwd = 2)


# 2) 안타와 홈런 변수를 활용한 회귀분석 예제
# Step1. 데이터를 불러온다.
DF <- read.csv("example_kbo2015.csv")
str(DF) # H : 안타, HR : 홈런

# Step2. '안타'와 '홈런' 변수를 확인한다.
DF$H; DF$HR

# Step3. 두 변수간의 상관계수를 구한다.
cor(DF$H, DF$HR)

# Stpe4. 두 변수간의 산점도를 그린다.
plot(HR ~ H, data = DF, pch = 20, col = "grey", cex = 1.5)

# Step5. 회귀모형을 그린다.
(Lm <- lm(HR ~ H, data = DF))
abline(Lm, lwd = 2, col = "red")



# 2. 선형 회귀 모형 검정하기
# (1) 결정계수
# - 두 변수의 관찰치는 선형이 아닐 수 있지만 회귀모형은 선형으로만 인과관계를 나타낸다.
#   그렇다면 변수간 인과관계를 선형회귀모형이 어느정도 잘 나타내는지를 검토해야 한다.
#   -> 결정계수를 이용하여 모형적합도 검토한다. R^2은 클수록 회귀모형이 모집단의 데이터에 적합했다고 말한다.
# - 결정계수를 구하는 방법 : 1) 상관계수를 제곱 ex) 상관계수 = 0.7 -> R^2 = 0.49
#                            2) SSR / SST -> ∑(Yi - Ybar)^2 = ∑(Yhat - Ybar)^2 + ∑(Yi - Yhat)^2
# - Ybar : 평균, Yhat : 예측치               SST(Sum of Square Total) = SSR(Sum of Square Regression) + SSE(Sum of Square Error)
#   r^2 = SSR / SST = 1 - SSE / SST
# ※ 다중선형회귀분석과 같이 회귀계수의 숫자가 커지면서 자연스럽게 결정계수가 높아지는 현상이 있다.
#    이를 개선한 것이 '수정된 결정계수'이다.
options(scipen = 999) # Scientific notation이 나오지 않도록 한다.
summary(Lm)

# (2) 선형 회귀모형 가설검정
# - 단순회귀분석인 경우
# Step1. 가설설정 
# H0 : β = 0, H1 : β ≠ 0 -> 표본평균 Xbar의 평균이 μ과 같아서 Xbar가 μ의 불편추정량이었던 것처럼
#                           표본회귀식 b의 평균은 모집단회귀계수 β와 같으며 표본회귀계수 b는 β의 불편추정량이다.
#                           따라서 b의 분포를 이용하여 β가 0인지 아닌지를 검정할 수 있다.

# Step2. 유의수준 -> α = 0.05, 1 - α = 0.95

# Step3. 임계치와 기각역 -> 표본회귀계수 b의 분산과 표준오차를 활용하여 β 검정해야 하므로 t-test 임계치를 설정한다.
#                           α = 0.05, 자유도 = n - 2, 임계치 = t α/(2, n-2), 기각역 = t < 임계치 or t > 임계치

# Step4. 검정통계량 -> b의 표준오차 = Sb = √((SSE / (n - 2)) / ∑(X - Xbar)^2)
#                      t값 산정시 b가 β에서 멀어진 정도가 b표준오차의 몇배인가를 계산하는데
#                      그 기준인 β는 당연히 0이 입력되어야 한다. b가 0에서 멀어질수록 의미있다고 할 수 있다.

# Step5. 귀무가설 채택과 기각여부 판단
# - 계산된 t값이 임계치 밖 기각역으로 간다면 β = 0이라는 귀무가설은 기각되며
#   표본회귀식의 회귀계수가 인과관계로 의미있다고 할 수 있다. β에 대한 신뢰구간을 추정한다면,
#   b - 임계치 * Sb <= β <= b + 임계치 * Sb  95% 신뢰수준으로 모집단 회귀계수의 값을 추정해 볼 수 있다.


# - 다중회귀분석인 경우 : b값이 여러 개이므로 독립변수 개수만큼 β의 유의성검정이 실시되며,
#                         R분석에서 P값 Pr(>|t|) 값으로 표현되며 0.05 이하의 회귀계수들이
#                         신뢰수준 95%로 유의하다고 할 수 있다.
# - 독립변수가 여러 개인 다중회귀분석에서 회귀계수 β가 β1, β2, β3, ... 로 여러개이다.
#   0이 아닌 회귀계수가 적어도 하나이상 있어야 회귀모형이 의미 있다고 할 수 있다.
#   회귀모형의 유의성 검정을 위해 분산분석(ANOVA)를 사용하는데 독립변수에 의해 설명된 분산과
#   설명되지 않은 분산의 비율을 이용하여 가설을 검정한다. 두 분산의 비율에 관한 분포는 F분포를 이용한다.
# Step1. 가설설정
# H0 : β1 = β2 = β3 ... = 0, H1 : β1 ≠ 0 or β2 ≠ 0 ...

# Step2. 유의수준 -> α = 0.05, 1 - α = 0.95

# Step3. 임계치와 기각역 -> 회귀분석에서 독립변수의 수 k에 따라 SSE와 SSR의 자유도는
#                           n - k - 1, k에 해당한다. 두 분산의 자유도를 고려하여 F분포상의 기각역을 산출한다.
#                           α = 0.05, SSE 자유도 = n - k - 1, SSR 자유도 = k
#                           임계치 : F (k, n - k - 1), 기각역 : Fc > 임계치

# Step4. 검정통계량 -> Fc = MSR / MSE = (SSR / k) / (SSE / (n - k - 1))
#                      F가 임계치에서 우측으로 멀리 있다면 회귀모형 전체의 SSR값이 SSE에 비해 크고
#                      회귀계수로써 의미있다고 할 수 있다.

# Step5. 귀무가설 채택과 기각여부 판단 -> 계산된 F값이 임계치 밖 기각역으로 간다면 β1 = β2 = β3 ... = 0
#                                         이라는 귀무가설은 기각되며 표본회귀모형의 인과관계가 의미있다고 할 수 있다.
options(scipen = 999)
Lm <- lm(mpg ~ hp, data = mtcars)
summary(Lm) # 회귀모형의 유의성검정은 F-statistic 부분에서 확인한다. k = 1, n = 32이므로
            # SSE 자유도 30, SSR 자유도 1로 임계치 F (k, n - k - 1) = F (1, 32 - 1 - 1) = 4.17에 비해
            # 검정통계량 F-statistic : 45.46은 우측으로 치우쳐 기각역에 속하므로 
            # 회귀모형이 95% 신뢰수준에서 유의하다고 할 수 있다.
confint(Lm)


# - 잔차(residuals)를 사용한 그래프로 선형회귀모형의 가정(assumptions) 검토
#   : 표본회귀식의 적합성, 회귀계수의 유의성, 회귀모형의 유의성 외에 표본회귀식의 잔차 ei가
#     모집단회귀식의 오차 ei에 대한 기본 가정을 충족하는지 판단할 필요가 있다.
# 1) 등분산성 가정
# - 예측치 Yhati을 가로축에, 잔차 ei = Yi - Yhati를 세로축에 놓고 그리면 예측치별로 잔차가 산포되어 나타난다.
#   표본회귀식의 X외에 예측치 Yhati와 관계 있는 어떤 요소가 잔차에 남아 있다면 예측치의 변화에 따라
#   잔차가 커지거나 작아지게 된다. 그 결과 잔차의 등분산성이 충족되지 않다고 볼 수 있다.
#   'Residuals vs Fitted' 그래프 중앙에 나타난 붉은 선이 잔차의 추세를 나타내는데
#   '이 선의 기울기가 0에 가까워지면 등분산성 가정이 성립한다고 볼 수 있다.'
# 2) 정규성 가정
# - 표본회귀모형의 X가 정규분포를 따르는지 살펴보고 싶다면 정규분포 정의에 따라 Z = (X - μ) / ∂ ~ N(0, 1)
#   '독립변수의 회귀계수 외에 잔차의 분포 역시 선형을 띄어야 정규성이 성립한다'고 할 수 있다.
#   보통 수평축을 0을 중심으로 여러 등급으로 나누고 등급(quantile)에 해당하는 
#   표준화된 잔차(standardized residuals)를 세로로 표현하여 정규성을 확인한다.
#   Normal Q-Q 그래프로 나타내며 대각선을 벗어난 점이 많을 수록 정규성이 없다고 판단한다.
# 3) 독립성 가정
# - 모집단회귀식의 오차 Ei들이 서로 독립적이라는 가정을 검토한다.
#   표본을 구할 때, 독립변수 외에 어떤 패턴이 유입되면 Ei들이 서로 독립적이지 못하고
#   자기상관(auto-correlation)이 발생한다.
#   ex) 특정 시간이라는 패턴이 유입되면 시간이 반복될 때마다 (그래프 X축에 시간) 잔차들이 패턴을 가지게 된다.
#       Residuals vs Fitted 그래프의 빨간선이 물결처럼 출렁이는 것처럼 
#       이 출렁임이 독립성 가정을 만족시키지 못할 수 있다.
# 4) 선형타당성 가정
# - 등분산성 가정과 마찬가지로 예측치 yhati를 가로축에, 잔차 ei = Yi - Yhati를 세로축에 놓고 그리면
#   예측치별로 잔차가 산포되어 나타난다. 등분산성에서 언급한대로 잔차가 0을 중심으로 고르게 흩어져있고
#   무작위하게 상하로 흩어져있으면 선형모형으로 타당하다. 하지만 Yhati가 증가함에 따라
#   잔차가 작아지다가 다시 커지는 경우 선형모형보다 2차함수 모형이 타당할 수 있다.
# 5) Residuals vs Leverage plot : 영향점, 이상점 판별을 도와주는 그래프
# - Cook's distance는 통상적으로 1값이 넘어가면 그 관찰치(Observation)를 영향점(Influence points)으로 판별한다.
#   이상점이 있으면 등고선 안쪽에 동그라미가 위치하게 된다. 특히, 1등고선 안쪽에 있다면 확실한 이상점이다.



# 선형 회귀 모형 검정하기 Examples
# 1) 잔차(Residuals) 그래프를 그려 검정하기
# Step1. 데이터를 불러온다.
DF <- read.csv("example_residuals_checking.csv")
head(DF, 3) # x1, y1 / x2, y2 한쌍씩 분석해서 서로 비교

# Step2. 첫 번째 회귀계수를 구한다.
(Lm_res1 <- lm(y1 ~ x1, data = DF))

# Step3. 두 번째 데이터 회귀계수를 구한다.
(Lm_res2 <- lm(y2 ~ x2, data = DF))

# Step4. 두 그래프를 그린다.
par(mfrow = c(2, 1))
plot(y1 ~ x1, DF, pch = 20, cex = 1.5, ylim = c(0, 30), main = "Data1")
plot(y2 ~ x2, DF, pch = 20, cex = 1.5, ylim = c(0, 30), main = "Data2")
                            #  회귀모형은 같다고 나오지만 많이 차이가 난다. -> 회귀모형을 만든 후 꼭 검정

# Step5. 회귀모형을 그린다.
par(mfrow = c(2, 1))
plot(y1 ~ x1, DF, pch = 20, cex = 1.5, ylim = c(0, 30), main = "Data1")
abline(Lm_res1, col = "blue", lwd = 2)

plot(y2 ~ x2, DF, pch = 20, cex = 1.5, ylim = c(0, 30), main = "Data2")
abline(Lm_res2, col = "blue", lwd = 2)

# Step6. 결정계수와 F통계량을 확인한다.
options(scipen = 999)
summary(Lm_res1)
summary(Lm_res2)

# Step7. 잔차(Residuals) 관련 그래프를 그린다.
par(mfrow = c(2, 2))
plot(Lm_res1)
plot(Lm_res2)


# 2) 2015 KBO 야구 데이터 분석하기
# Step1. 데이터를 불러온다.
DF <- read.csv("example_kbo2015_player.csv", stringsAsFactors = F, na = "-")
str(DF) # 2B : 2루타, 3B : 3루타, AB : 타수, AO : 뜬공, AVG : 타율, BB : 볼넷, GW RBI : 결승타
        # CS : 도루실패, E : 실책, G : 경기, GDP : 병살타, GO : 땅볼, GPA : (1.8 * 출루율 + 장타율) / 4
        # H : 안타, HBP : 사구, HR : 홈런, IBB : 고의4구, ISOP : 순수장타율, MH : 멀티히트
        # OBP : 출루율, OPS : 출루율 + 장타율, PA : 타석, PH-BA : 대타 타율, R : 득점, RBI : 타점
        # RISP : 득점권타율, SAC : 희생번트, SB : 도루, SF : 희생플라이, SLG : 장타율, SO : 삼진
        # TB : 루타, XBH : 장타, XR : 추정득점

# Step2. 홈런과 다른 변수간의 상관계수를 살펴본다.
(cors <- cor(DF$HR, DF[, 5 : length(DF)], use = "pairwise.complete.obs"))
                                          # pearson의 알고리즘으로 결측치를 취급

# Step3. Sorting해 상관관계를 다시 본다.
(cors <- cors[, order(cors)])

# Step4. 회귀모형을 구한다.
(Lm <- lm(HR ~ AO, data = DF))

# Step5. F통계량과 결정계수를 살펴본다.
summary(Lm)

# Step6. 잔차(Residuals)관련 그래프를 그린다.
par(mfrow = c(2, 2))
plot(Lm)



# 3. 다중선형회귀분석(Multiple Linear Regression) - 독립변수가 여러 개인 경우
# - 다중선형회귀분석부터는 그래프를 통한 해석보다는 수치를 통한 해석이 더 유용하다.
#   yi = b0 + b1xi + b2xi + b3xi + b4xi + ... + Ei


# 다중선형회귀분석 Examples
# 1) mtcars 데이터셋 다중선형회귀분석
# Step1. 데이터를 불러온다.
DF <- mtcars
str(DF)

# Step2. 독립변수를 추가한다.
(Lm <- lm(hp ~ cyl + wt, data = DF))

# Step3. 검정한다.
summary(Lm)


# 2) 지구 최고온도에 영향을 미치는 독립변수로 다중회귀분석하기
# Step1. 데이터를 확인한다.
head(airquality) # 뉴욕의 1973년 5 ~ 9월까지의 대기상태에 대한 정보들을 담은 데이터셋
plot(airquality) # Temp : 최고온도, Solar.R : 태양방사선량, Wind(평균풍속)

# Step2. 다중회귀분석 실시하기
(Lm <- lm(Temp ~ Ozone + Solar.R + Wind, data = airquality))

# Step3. 회귀모형을 검정한다.
summary(Lm)



# 4. 추정치 구하기 - Examples
# 1) 야구 데이터로 추정하기
# Step1. 데이터를 불러온다.
DF <- read.csv("example_kbo2015.csv")

# Step2. 구조를 살펴본다.
head(DF)

# Step3. 회귀모형을 구한다.
(Lm <- lm(HR ~ TB, data = DF))

# Step4. 회귀모형을 검정한다.
summary(Lm)

# Step5. 회귀모형에 값을 넣어 추정치를 구한다.
(b <- predict(Lm))

# Step6. 두 값을 비교해 본다.
DF$HR[1]; b[1]

# Step7. 데이터프레임(data.frame)에 넣어 비교한다.
(Com <- data.frame(team = DF$team, HR = DF$HR, fittedHR = b))

# Step8. 새로운 데이터를 만든다.
NewTeam <- data.frame(TB = 1600)

# Step9. 예측값을 구한다.
predict(Lm, newdata = NewTeam) # 1600개의 루타 -> 121개의 홈런


# 2) mtcars 데이터로 추정치 구하기
# Step1. 데이터를 불러온다.
DF <- mtcars

# Step2. 구조를 살펴본다.
head(DF)

# Step3. 회귀모형을 구한다.
(Lm <- lm(mpg ~ wt, data = DF))

# Step4. 회귀모형을 검정한다.
summary(Lm)

# Step5. 회귀모형에 값을 넣어 추정치를 구한다.
(b <- predict(Lm))

# Step6. 두 값을 비교해 본다.
DF$mpg[1]; b[1]

# Step7. 데이터프레임(data.frame)에 넣어 비교한다.
(Com <- data.frame(mpg = DF$mpg, fittedMPG = b))

# Step8. 새로운 데이터를 만든다.
NewCar <- data.frame(wt = 6)

# Step9. 예측값을 구한다.
predict(Lm, newdata = NewCar) # 6톤 차체무게 -> 5.21 연비

# Step10. 새로운 값들을 대입한다.
NewCar2 <- data.frame(wt = 0.4)
predict(Lm, newdata = NewCar2) # 400kg -> 35.14 연비


# 3) 예측값 신뢰구간으로 나타내기
# - 추정하는 값을 'x가 2일 때 30이다'라고 말하는 것보다 'x가 2일 때 28 ~ 32이다'라고 말하는 것이 좋다.
# Step1. 데이터를 불러온다.
library(ggplot2)
DF <- diamonds

# Step2. 데이터 구조를 살펴본다.
str(DF)

# Step3. 표본을 만든다.
Sample <- diamonds[sample(nrow(DF), 100), ]

# Step4. 그래프를 그린다.
g1 <- ggplot(Sample, aes(x = carat, y = price, colour = color)) + geom_point()
                                               # 회귀모형은 그룹별로 여러 개 표시된다.
g2 <- ggplot(Sample, aes(x = carat, y = price)) + geom_point(aes(colour = color))
                                                                 # 회귀모형은 하나만 표시된다.
      # why?) ggplot()함수에 넣으면 colour인자가 뒤에 있는 함수들에 전달된다.
      #       but, geom_point()함수에 사용된 인자값은 뒤에 있는 함수들에게 전달되지 않는다.

# Step5. color별 회귀모형
g1 + geom_smooth(method = "lm")
g2 + geom_smooth(method = "lm")

# Step6. 정확한 값으로 예측구간 나타내기
Lm <- lm(price ~ carat, data = Sample)
predict(Lm, interval = "confidence", level = 0.95)



# 5) 다중선형회귀분석에서 변수선택법
# - 잔차(Residuals)가 적은 모델이 회귀모형으로서 더 적합한 모델이다.
#   ① 전진선택법 : 변수가 한 개일때 가장 좋은 모형을 선택하고 선택된 변수가 포함된 두 개 변수인 경우에서
#                   다시 변수를 선택 해 다른 모델을 선정.
#   ② 후진제거법 : 전진선택법과 정반대로 진행


# 다중선형회귀분석에서 변수선택법 Examples
# 1) 최상부분집합선택법 - step()함수를 이용
# Step1. 데이터로 기존 내장 데이터셋이 mtcars를 사용한다.
DF <- mtcars

# Step2. 회귀모형을 구한다.
(Lm <- lm(mpg ~ ., data = DF))

# Step3. step()함수를 사용한다. - AIC통계량을 이용해 변수를 선택한다.
Slm <- step(Lm, direction = "both")

# Step4. 최종 회귀모형을 확인한다.
Slm # 종속변수 : mpg(연비) / 독립변수 : wt(차체무게), qsec(드래그 레이스 타임), am(미션종류)


# 2) 최상부분집합선택법 - leaps패키지를 이용
# Step1. R을 이용해 mtcars()에 어떤 변수들이 있는지 알아본다.
DF <- mtcars

# Step2. 변수선택 함수를 제공해주는 'leaps'패키지를 설치한다.
install.packages("leaps")
library(leaps)

# Step3. 'regsubsets()'함수를 이용해 변수선택 하기
Slm <- regsubsets(mpg ~ ., data = DF, nvmax = 10, method = "exhaustive")
       # regsubsets(formula, data, 독립변수개수, 변수선택법 선택) - BIC를 이용한 통계량을 계산해 주는 함수
summary(Slm)

# Step4. 변수선택 기준 BIC를 이용해 최적의 모델 선택하기
(BestBic <- summary(Slm)$bic)

# Step5. 통계량이 가장 적은 변수 찾기
Min_val <- which.min(BestBic)
plot(BestBic, type = "b")
points(Min_val, BestBic[Min_val], cex = 2, col = "red", pch = 20)

# Step6. 최적의 모델 구현하기
coef(Slm, 3) # coef(모델, 독립변수의 개수)
             # mpg = 9.617781 - 3.916504(wt) + 1.225886(qsec) + 2.935837(am)


# 3) 전진선택법(Forward Stepwise Selection method)으로 선택하기
# Step1. 라이브러리
library(leaps)

# Step2. 'regsubsets()'함수를 이용해 변수선택 하기
Slm <- regsubsets(mpg ~ ., data = mtcars, nvmax = 10, method = "forward")
summary(Slm)

# Step3. 변수선택 기준 BIC를 이용해 최적의 모델 선택하기
ForwardBic <- summary(Slm)$bic
Min_val <- which.min(ForwardBic)
plot(ForwardBic, type = "b")
points(Min_val, ForwardBic[Min_val], cex = 2, col = "red", pch = 20)

# Step4. 최적의 모델 구현하기
coef(Slm, 2) # mpg = 39.686261 - 1.507795(cyl) - 3.190972(wt)


# 4) 후진선택법(Backward elimination method)을 이용해 따라해보기
# Step1. 라이브러리
library(leaps)

# Step2. 'regsubsets()'함수를 이용해 변수 선택 하기
Slm <- regsubsets(mpg ~ ., data = mtcars, nvmax = 10, method = "backward")
summary(Slm)

# Step3. 변수선택 기준 BIC를 이용해 최적의 모델 선택하기
BackwardBic <- summary(Slm)$bic
Min_val <- which.min(BackwardBic)
plot(BackwardBic, type = "b")
points(Min_val, BackwardBic[Min_val], cex = 2, col = "red", pch = 20)

# Step4. 최적의 모델 구현하기
coef(Slm, 3) # mpg = 9.17781 - 3.916504(wt) + 1.225886(qsec) + 2.935837(am)
