# Example01 - 10년치 편의점 판매 데이터 분석하기 ----
# package : data.table, dplyr, ggplot2, stringr
# Step1. 필요한 패키지와 데이터를 불러온다.
library(data.table) # 데이터를 빠르게 불러오기 위해.
library(dplyr) # 특정 데이터를 추출하기 위해.
library(stringr) # 2017-01-01 12:33:34 과 같은 것을 년, 월, 일, 시간으로 나누기 위해.
library(ggplot2) # 구한 데이터를 그래프로 그리기 위해.

# Step2. 데이터를 불러온다.
DF <- fread("example_conveniencestore.csv", encoding = "UTF-8", data.table = F)

# Step3. 데이터 전처리하기
DF$Date1 <- str_split_fixed(DF$Date, " ", 2)[, 1]
DF$year <- str_split_fixed(DF$Date1, "-", 3)[, 1]
DF$month <- str_split_fixed(DF$Date1, "-", 3)[, 2]
DF$day <- str_split_fixed(DF$Date1, "-", 3)[, 3]
DF$time <- str_split_fixed(DF$Date, " ", 2)[, 2]
DF$hour <- str_split_fixed(DF$Time, ":", 3)[, 1]

# Step4. factor로 만든다.
DF$year <- as.factor(DF$year)
DF$month <- as.factor(DF$month)
DF$day <- as.factor(DF$day)

# Step5. 원하는 데이터만 추출한다.
S <- tbl_df(DF)
S2 <- DF %>% filter(month == 12, sellproduct == "가스큐백 1.6리터(P)")

# Step6. 도수를 구한다.
amount <- table(S2$day, S2$hour, S2$year)
amount2 <- apply(amount, 3, table)
amount3 <- lapply(amount2, prop.table)

# Step7. 확률변수의 max값을 구한다.
a <- lapply(amount2, rownames)
a2 <- lapply(a, as.numeric)
m <- max(sapply(a2, max))

# Step8. 자료 정리를 위해 dataframe 변수를 만든다.
nDF <- data.frame(amount = 0 : m)
pDF <- data.frame(amount = 0 : m)

# Step9. 비율을 구한다.
for(i in 1 : length(amount3)){
  temp <- data.frame(amount2[[i]])
  temp2 <- data.frame(amount3[[i]])
  colnames(temp) <- c("amount", 2005 + i)
  colnames(temp2) <- c("amount", 2005 + i)
  nDF <- merge(nDF, temp, by.x = "amount", all.x = T)
  pDF <- merge(pDF, temp2, by.x = "amount", all.x = T)
}

# Step10. 그래프로 그린다.
ggplot(nDF, aes(x = amount, y = nDF[, 2])) + geom_bar(stat = "identify", fill = "orange")

# Step11. 평균을 구한다.
pDF[is.na(pDF)] <- 0 # NA를 0으로 변경
Probability <- apply(pDF[2 : 11], 1, mean) # 상대도수의 평균을 구해 확률을 구한다.
pDF <- cbind(pDF, Probability) # 끝에 값을 추가한다.

# Step12. 기대값을 구한다.
Each_EV <- pDF[, 1] * pDF[, 12] # 확률변수 값과 이에 해당하는 확률을 곱하여
                                # 해당 판매량의 기대값을 모두 구한다.
pDF <- cbind(pDF, Each_EV)
plot(pDF[, 12], type = "h", lwd = 10, lend = 2, main = "시간당 판매량분포(확률)")

# Step13. 시간당 판매량 기대값 산출
pDF[is.na(pDF)] <- 0 # NA는 0으로 변경
(EV <- apply(pDF[c(13)], 2, sum))
(Benefit <- EV * 24 * 6000 * 0.07) # 기대값에 하루 24시간, 단가 6000원, 마진율 7%를 고려하면
                                   # 이 지점은 하루에 182,000원 정도의 수입을 '가스큐팩 1.6'으로부터 얻는다.

# Step14. 마진율을 조정해본다.
Sales_up <- pDF[, 1] * (1 + 0.25) # 판매량 25% 증가
pDF <- cbind(pDF, Sales_up)

EV_up <- pDF[, 14] * pDF[, 12]
pDF <- cbind(pDF, EV_up)

(Neo_EV <- apply(pDF[c(15)], 2, sum)) # 판매량이 18.07191에서 22.58989로 증가한다.

(Neo_Benefit <- Neo_EV * 24 * 6000 * 0.06) # 판매량 22.58989에 24시간 단가 6000원 마진율 6%를 적용하면,
                                           # '가스큐팩 1.6'으로 인한 하루 매장은 195176원으로 나타났다.

# Step15. 95% 신뢰구간을 확률분포로 나타내면 다음과 같다.
qnorm(c(0.025, 0.975), mean = mean(amount), sd = sd(amoun), lower.tail = T)
curve(dnorm(x, mean = mean(amount), sd = sd(amount)), 0, 40, xlab = "시간별 맥주판매량(X)",
      ylab = "P(X)", main = "시간대별 맥주판매량 확률분포")
quantity <- seq(9.3, 26.7, 0.1)
lines(quantity, dnorm(quantity), type = "h", col = "grey")
                # 9.3병부터 26.7병까지가 95% 신뢰구간으로 본 매장의 어느 시간대건 한 시간을 고르면 
                # 100번중에 95번은 이 범위에 속한다는 의미이다.

# 매장의 맥주재고관리를 위해 점주가 고려해야할 적정재고는 어느정도인가?
# Step16. 다른 확률 값도 구해본다.
1 - pnorm(c(20, 25, 30), mean = mean(amount), sd = sd(amount), lower.tail = T)
                         # 20병 이상이 팔릴 확률 = 33%, 25병이상 = 5%, 30병 이상 = 0.3%
                         # 점주입장에서 적정한 재고구간은 확률이 낮은 25병이하가 좋겠다라는 판단을 할 수 있다.


# Example02 - 묶음 행사 상품 판매 데이터 분석하기 ----
# package : data.table, dplyr, ggplot2
# - 8개의 이벤트 상품들이 있다. 이 중 6개를 골라 세트로 구입할 수 있다. 단, 중복해서 고를 수 있다.
#   이럴 때 6개 세트에서 마진이 좋은 상품도 있고 나쁜 상품도 있다. 그 기준을 0.13으로 할 때,
#   마진이 0.13 이상인 상품의 개수를 확률변수로 하면 X = {0, 1, 2, 3, 4, 5, 6}이 된다.
# Step1. 이벤트 상품 목록을 만든다.
eventlist <- c("구카카콜 250미리리터(캔)", "세계콘 170미리리터", "딸기속우유 310미리리터(팩)",
               "조르지아오리지널 240미리리터(캔)", "육개장사발탕면 86g(컵)", "카페라떼와일드 200미리리터(컵)",
               "핫개컨디션파워 100미리리터(병)", "비타528 100미리리터(병)")

# Step2. 세트 판매 데이터를 불러온다.
event <- read.csv("example_eventsale.csv", header = F)
event <- as.list(event) # 리스트 요소 한 개당 세트로 판매된 상품목록으로 되어 있어야 핸들링 하기 쉽다.
event <- lapply(event, as.character)
head(event, 2)

# Step3. 데이터를 불러온다.
library(data.table)
DF <- fread("example_conveniencestore.csv", encoding = "UTF-8", data.table = F)

# Step4. 1000개의 데이터만 임의로 샘플링한다.
S <- DF[sample(nrow(DF), 1000), ]

# Step5. 상품별로 요약한다.
library(dplyr)
(S2 <- S %>% filter(sellproduct == eventlist[1] | sellproduct == eventlist[2]
                    | sellproduct == eventlist[3] | sellproduct == eventlist[4]
                    | sellproduct == eventlist[5] | sellproduct == eventlist[6]
                    | sellproduct == eventlist[7] | sellproduct == eventlist[8]) %>% 
    group_by(sellproduct) %>% summarise(margin = min(margin)) %>% 
    mutate(marginTF = ifelse(margin > 0.13, 1, 0))) # 책 내용
(S3 <- S %>% filter(sellproduct %in% eventlist[1 : 8]) %>% group_by(sellproduct) %>% 
    summarise(margin = min(margin)) %>% mutate(marginTF = ifelse(margin > 0.13, 1, 0)))
                                                          # 내가 줄인 코드

# Step6. 경우의 수 만들기
library(gtools)
com <- combinations(length(eventlist), 6, eventlist, repeats.allowed = T)
                    # combination : 조합, repeats.allowed = T : 중복을 허용하는 '중복조합'
nrow(com)

# Step7. 판매데이터와 사건을 비교한다.
c <- NULL
for(j in 1 : length(event)){
  for(i in 1 : nrow(com)){
    if(all(event[[j]] %in% com[i, ])){
      c <- c(c, i)
      break
    }
  }
}
head(c, 10) # 이벤트 판매데이터(example_eventsale.csv)와 경우의 수를 만든 데이터와 비교해서
            # 이벤트 판매데이터가 어떤 조합에 해당하는지 위치값을 구하는 것이다.

# Step8. 모든 사건을 marginTF값으로 바꾼다.
com2 <- com
for(i in 1 : length(eventlist)){
  com2[com == eventlist[[i]]] <- S2[S2$sellproduct == eventlist[i], ]$marginTF
} # 원하는 확률변수는 사건마다 마진이 있는 상품의 개수를 얻는 것이다.
com3 <- apply(com2, 2, as.integer)

# Step9. 1의 개수를 센다.
rv <- rowSums(com3)

# Step10. 확률변수마다 도수를 구한다.
(rv <- table(rv[c]))
addmargins(rv)

# Step11. 그래프를 그린다.
library(ggplot2)
library(ggthemes)
(rv_df <- as.data.frame(rv))
ggplot(rv_df, aes(x = factor(Var1), y = Freq, fill = Var1)) + geom_bar(stat = "identity")

# Step12. 비율을 구한다.
(prop <- prop.table(rv))


# Example03 - 게임데이터 기하분포로 분석하기 ----
# package : data.table, dplyr, ggplot2
# Step1. 데이터를 불러온다.
library(data.table)
DF <- fread("example_gamedata.csv", data.table = F)
head(DF, 1)

# Step2. 376966이용자의 데이터만 살펴본다.
library(dplyr)
DF2 <- tbl_df(DF)
options(dplyr.print_max = 1e9)
DF2 %>% filter(memberID == 376966)

# Step3. 376966 이용자의 모든 스테이지 값을 살펴본다.
DF2 %>% filter(memberID == 376966) %>% group_by(stage, success) %>% select(success) %>% 
  summarise(count = n())

# Step4. 모든 사람들의 실패 / 성공 횟수를 구한다.
(SF <- DF2 %>% group_by(stage, success) %>% select(success) %>% summarise(count = n()))

# Step5. 그래프를 그린다.
library(ggplot2)
library(ggthemes)
ggplot(SF, aes(x = factor(stage), y = count, colour = success, group = success)) +
  geom_line(size = 0.7) + geom_point(size = 4) + ggtitle("A사의 B게임 스테이지별 성공여부 그래프") +
  theme_wsj()

# Step6. 성공한 횟수만 따로 저장한다.
(SF2 <- SF %>% filter(success == T))

# Step7. 스테이지별 전체 횟수를 구한다.
(SFT <- DF2 %>% group_by(stage) %>% summarise(total = n()))

# Step8. 성공 횟수와 전체 횟수를 합친다.
SF3 <- cbind(SF2, total = SFT$total)

# Step9. 성공 비율을 나타낸다.
(SF4 <- SF3 %>% mutate(p = count / total)) # 이 데이터는 베르누이 시행의 조건을 만족한다.
                                           # 1. 결과가 성공 / 실패로 나타나고,
                                           # 2. 스테이지마다 늘 같은 밸런스를 사용하기 때문에
                                           #    성공할 확률은 같고,
                                           # 3. 멀리 떨어진 사람친구가 게임을 성공했다고 해서
                                           #    자신한테 영향을 미치지 않는다.
                                           # - 이항분포, 기하분포를 이용해 확률분포를 그릴 수 있다.
                                           # ex) 기하분포를 이용하여 "n번째에 게임을 성공할 확률은 ?",
                                           # "이번 스테이지는 5번만에 90%의 사람들이 게임을 클리어 하면 좋겠다."

# Step10. stage_03일때 기하분포를 그린다.
x <- 1 : 15
y <- dgeom(x, 0.327)
plot(x, y, type = "h")

# Step11. 기하분포 값을 자세히 본다.
round(y, 3) # 첫 번째 스테이지를 성공할 확률 = 0.22, 두 번째 성공할 확률 = 0.148

# Step12. 누적 기하분포 확률값을 구한다.
pgeom(5, 0.327) # 5번까지 실패하고 스테이지를 성공할 확률 = 0.9
pgeom(4, 0.327) # 4번까지 실패하고 성공할 확률 = 0.86
                # 확률변수가 0부터 시작하므로 'n번 실패하고 성공할 확률'의 의미
                # 6번을 실패하고 게임을 성공할 확률을 0.9만드려고 한다. p값은 얼마가 되어야 하나?

# Step13. 0.9가 될때까지의 p값을 구하는 함수만들기
findp <- function(n, p){
  for(i in 1 : 99){
    a <- pgeom(n, 0.01 * i)
    if(a > p){
      print(paste0("n값이 ", n, "일 때"))
      print(paste0("p값 ", 0.01 * i, "을 사용하면"))
      print(paste0("확률 ", a, "이 나온다."))
      break
    }
  }
}

# Step14. 6번만에 90%가 성공하는 p값을 구한다.
findp(6, 0.9) # 현재 p가 0.327이었는데 이것을 0.29로 낮추면 90%의 사람들이 6번 실패하고
              # 스테이지를 성공한다고 기하분포가 말해준다.