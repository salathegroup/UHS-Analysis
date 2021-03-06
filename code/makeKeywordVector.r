library(RMySQL)

mydb = dbConnect(MySQL(), user='root',password='root',dbname='uhs_stalker', host='127.0.0.1', port=8889)


Sys.setenv(NOAWT=1)
library(Snowball)

l = c("mined","miners","mining","miner","mines")
SnowballStemmer(l)

library(tm)
library("RWeka")
library(RWekajars)


makeWordVector <- function(text){
    return(unique(SnowballStemmer(NGramTokenizer(tolower(text),Weka_control(min=1,max=1)))))
}

keywords = makeWordVector("flu influenza sick cough cold medicine fever")

text = fetch(dbSendQuery(mydb, "SELECT sick_month, concat(userID,\"_\",month_index) as idstr, GROUP_CONCAT( TEXT SEPARATOR  ' ' ) AS c FROM tweets INNER JOIN users ON users.userID = tweets.user GROUP BY tweets.user, month_index"),n=-1)

sick = text$sick_month

sick[which(is.na(sick))] = 0
contains = matrix(NA,length(sick),length(keywords))
id_str = matrix(NA,length(sick), 1)

for(x in 1:length(sick))
{
stemmed = makeWordVector(text[x,]$c)
for(y in 1:length(keywords))
{
contains[x,y] = keywords[y] %in% stemmed
}

id_str[x,1] = text[x,]$idstr

}

write.csv(data.frame(contains,sick==1), "../data/expert_keyword_vector.csv")


write.arff(data.frame(text$c, sick==1), "../data/all_keyword_vector.arff")

write.csv(data.frame(id_str, contains,sick==1), "../data/private/expert_keyword_vector.csv")


write.arff(data.frame(id_str, text$c, sick==1), "../data/private/all_keyword_vector.arff")
