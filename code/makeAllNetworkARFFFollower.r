options(java.parameters = "-d64 -Xmx16000m")

library(RMySQL)

Sys.setenv(NOAWT=1)
library("RWeka")

sick_in_month <- function(user, month)
{
if(month == 8)
   return(user$sick_august)
if(month == 9)
   return(user$sick_september)
if(month == 10)
   return(user$sick_october)
if(month == 11)
   return(user$sick_november)
if(month == 12)
   return(user$sick_december)
if(month == 13)
   return(user$sick_january)
if(month == 14)
   return(user$sick_feburary)
if(month == 15)
   return(user$sick_march)
if(month == 16)
   return(user$sick_april)
if(month == 17)
   return(user$sick_may)
}

replace_bad_char <- function(text)
{
return(gsub("  "," ",gsub("\""," ", gsub("'"," ", gsub(","," ",gsub("%", " ",gsub("\n"," ",gsub("\t"," ", text))))))))
}


proc.time() -> startTime
mydb = dbConnect(MySQL(), user='root',password='root',dbname='uhs_stalker', host='127.0.0.1', port=8889)

sick_array = c()
text_array = c()
id_array = c()

users = fetch(dbSendQuery(mydb, 'select * from users where `ignore`=0'),n=-1)

for( user_iter in 1:length(users$sick_august))
{

user = users[user_iter,]

for( month_iter in 8:17)
{

text = fetch(dbSendQuery(mydb, paste("SELECT GROUP_CONCAT( TEXT SEPARATOR  ' ' ) AS c from tweets_network where tweets_network.user in (select object from network where subject = '",user$userID,"' and verb = \"follower\") AND month_index=",month_iter)))


if(length(text$c) > 0)
{
id_array = c(id_array, paste(user$userID,"_",month_iter, sep=""))
sick_array=c(sick_array, sick_in_month(user, month_iter))
text_array = c(text_array, replace_bad_char(text$c))
}

}

}


##write.arff(data.frame(sick_array, text_array),"followers.arff")
write.csv(data.frame(id_array,sick_array, text_array), "../data/private/followers.csv")
