#1. Wczytaj plik autaSmall.csv i wypisz pierwsze 5 wierszy:
?read.csv
getwd()
df1 <- read.csv("autaSmall.csv")
df1<-head(df1,5)
 
#2. Pobierz dane pogodowe z REST API

install.packages("jsonlite")
install.packages("httr")

library(jsonlite)
require(httr)

endpoint <- "https://api.openweathermap.org/data/2.5/weather?q=Warszawa&appid=xxx"
#xxx-apikey
response<-GET(endpoint)
content<- content(response,"text")
fromJSON(content) 
fromJSON(endpoint)

 weatherDF <- as.data.frame(fromJSON(endpoint))
 View(weatherDF)

 #3.Napisz funckję zapisującą porcjami danych plik csv do tabeli  w SQLite
 #Mały przykład - autaSmall.csv
 i<-1
 repeat{
   if(i>5){
     break
   }
   print(i)
   i<-i+1
 }
 
 
 install.packages("DBI")
 install.packages("RSQLite")
 library(DBI)
 library(RSQLite)
 
 
 readToBase<-function(filepath,con,tablename,size=100,sep=",",header=TRUE,delete=TRUE,encoding="UTF-8"){
   ap = !delete
   ov = delete
   
   fileCon<- file(description =filepath,open = "r" ,encoding=encoding )
   
   
   df<-read.table(fileCon,header=header,sep=sep,fill=TRUE
                  ,fileEncoding = encoding,nrows=size)
   if( nrow(df)==0 )
     return(0)
   myColNames<- names(df)
   dbWriteTable(con,tablename,df,append=ap,overwrite=ov)
   
   repeat{
     if(nrow(df)==0){
       close(fileCon)
       dbDisconnect(con)
       break;
     }
     df<-read.table(fileCon,col.names =myColNames ,sep=sep,fill=TRUE, 
                    fileEncoding = encoding,nrows=size)
     dbWriteTable(con,tablename,df1,append=TRUE,overwrite=FALSE)
     
   }
   
   
 }
 
 con<- dbConnect(SQLite(),"auta.sqlite")
 readToBase("autaSmall.csv",con,"auta2",1000)
 
 #4.Napisz funkcję znajdującą tydzień obserwacji z największą średnią ceną ofert korzystając z zapytania SQL.
 
 con<- dbConnect(SQLite(),"auta.sqlite")
 res<-dbSendQuery(con,"SELECT * FROM auta2")
  dataFrameZbazy<-dbFetch(res)
 dbClearResult(res)
  dbDisconnect(con)
  

#5Podobnie jak w poprzednim zadaniu napisz funkcję znajdującą tydzień obserwacji z największą średnią ceną ofert  tym razem wykorzystując REST api.
  #na teams swagger z opisem endpoint'ow
   
 
 
 
 
 
 
 