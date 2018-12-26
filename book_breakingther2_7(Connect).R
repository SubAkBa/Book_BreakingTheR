# 1. Java연동
# 1) R과 Java연동하고 "Hello World"출력하기
# Step8. 패키지를 로딩
library(rJava)

# Step9. rjava초기화 및 path설정
.jinit(classpath = "Hello.jar")
.jclassPath()

# Step10. 사용할 class로 객체 생성
(h <- .jnew("main"))

# Step11. method 실행
h$sayready("Ready")


# 2) 트위터와 연동 후 검색결과로 형태소 분석 후 wordcloud 나타내기
# - url : http://shineware.tistory.com/entry/KOMORAN-ver-24
# Step9. 라이브러리
install.packages("twitteR")
install.packages("wordcloud")
install.packages("RColorBrewer")
install.packages("base64enc")
library(twitteR)
library(wordcloud)
library(RColorBrewer)
library(base64enc)
library(rJava)

# Step10. Twitter 연동
api_key <- ""
api_secret <- ""

access_token <- ""
access_token_secret <- ""

# Step11. key를 통해 트위터 App과 연결
setup_twitter_oauth(api_key, api_secret, access_token, access_token_secret)
rm(list = ls())

# Step12. rjava 초기화
.jinit() # rJava를 사용하기 위해 초기화하는 함수
.jaddClassPath("Twitter.jar")
.jclassPath()

# Step13. 형태소 분석 클래스 객체화
tw <- .jnew("twittermain")

# Step14. 검색어를 정하고 트위터에서 결과를 얻는다.
key <- "취업"
key <- enc2utf8(key)
result <- searchTwitter(key, n = 1000) # searchTwitter(키워드, 가져올 개수)
result[1 : 5]
str(result[1]) # 내용만 가져오는 것이 아닌 다양한 정보들을 가져온다. ex) 생성 날짜, 리트윗여부, ...

# Step15. locale값을 바꾼다.
Sys.setlocale(locale = "C")

# Step16. 데이터 프레임으로 형 변환
DF <- twListToDF(result)
str(DF)
head(DF)

# Step17. 한글만 가져온다.
m <- gregexpr("([가-힣]+ +[가-힣]+)+", DF$text) # 한글문자가 1개 이상 반복되고 띄어쓰기 이후
                                                # 다시 여러 한글문자
txt <- regmatches(DF$text, m) # grep 문법에 따라 텍스트로 가져온다.
txt2 <- lapply(txt, paste, collapse = " ")
txt3 <- unlist(txt2) # 리스트를 풀고 벡터로

# Step18. 불필요한 객체를 삭제
rm(list = c("txt", "txt2", "result", "DF", "m"))

# Step19. txt3벡터를 가지고 Java의 문자열 배열로 바꿔준다.
arr <- .jarray(txt3) # R의 벡터를 java의 array에 저장하는 가장 빠른 방법

# Step20. 형태소 분석
Result <- tw$analyze(arr) # $.jnew()로 정의하고 $로 메서드를 호출할 수 있다.
head(Result, 10)

# Step21. 단어와 Tag로 나누기
word <- unlist(strsplit(Result, "\\/")) # 벡터이지만 strsplit적용 가능하다. /기준으로 단어와 tag를 나눈다.
head(word, 6)

# Step22. 홀수 벡터와 짝수 벡터를 만든다.
odd <- seq(from = 1, by = 2, length = length(word) / 2) # word가 벡터로 나열되어 있다.
                                                        # 홀수에는 word가 있고 짝수에는 tag가 있다.
                                                        # 그래서 짝수와 홀수를 별도 저장하기 위해
                                                        # 홀수, 짝수 수열을 만든다.
even <- seq(from = 2, by = 2, length = length(word) / 2)
w <- word[odd]
t <- word[even]

# Step23. 데이터프레임으로 만든다.
word <- data.frame(word = w, tag = t, stringsAsFactors = F)

# Step24. 명사만 뽑는다.
word <- word[grepl("^N+", word$tag), ] # N으로 시작하는 모든 명사를 넣는다.
word <- subset(word, subset = (tag != "NNB")) # NNB는 의존명사로서 "것"과 같은 명사를 의미한다.

# Step25. 검색한 키워드는 제외
fin <- subset(word, subset = !(word == key)) # 국정과 교과서는 너무 많아 제외한다.
f <- nchar(fin$word) == 1
fin2 <- subset(fin, subset = !f)

# Step26. 워드클라우드를 그린다.
pal <- brewer.pal(3, "Set1")
wordcount <- table(fin2[[1]])
wordcloud(names(wordcount), freq = wordcount, scale = c(5, 1), rot.per = 0.25, min.freq = 2,
          random.order = F, random.color = T, colors = pal)