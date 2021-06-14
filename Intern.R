library(dplyr)
library(ggplot2)
library(tsibble)
library(readxl)
library(forecast)
library(rugarch)
library(urca)
library(CADFtest)
library(tseries)
library(rugarch)
library(fGarch)
library(dplyr)
library(ggplot2)
library(tidyquant)
library(tidyverse)

###############KLCI###############################################
setwd("C:/Users/Hp/Documents/Intern/Data/KLCI")
KLCI<-read.csv('KLCI.csv')

KLCI<-KLCI%>%select(Date,Close)%>%mutate(Date=as.Date(Date,"%m/%d/%Y"),Close=as.numeric(sub(",","",Close)))
KLCI<-KLCI%>%muta
stCov<-as.Date("2019-12-02","%Y-%m-%d")
MCO<-as.Date("2020-03-18","%Y-%m-%d")
Politic<-as.Date("2020-02-26","%Y-%m-%d")
UP<-as.Date("2020-04-29","%Y-%m-%d")
PRU<-as.Date("2020-09-23","%Y-%m-%d")
Covid<-as.Date("2020-12-22","%Y-%m-%d")
KLCI%>%ggplot(aes(x=Date,y=Close))+geom_line(color="Blue",size=1)+geom_vline(xintercept=c(stCov,Politic,MCO,UP,PRU,Covid),color="black",linetype ="dashed")+
  labs(title = "KLCI Index From 2 December 2019 until 1 March 2021",x="Time",y="Index")+theme_bw()+
  annotate("text", x = MCO ,y=1600 , label = "MCO 18 Mar 20")

KLCI%>%filter(Date==as.Date("2020-03-18","%Y-%m-%d"))

change<-(1567.14-1602.57)/1567.14*100
summary(KLCI)
which(grepl("2021-01-04",KLCI$Date))
which(grepl("2021-03-01",KLCI$Date))

##### Before Covid #####
KLCIBCOV<-read.csv("KLCI before covid.csv")
KLCIBCOV<-KLCIBCOV%>%select(Date,Close)%>%mutate(Date=as.Date(Date,"%m/%d/%Y"),Close=as.numeric(sub(",","",Close)))
KLCIBCOV%>%ggplot(aes(x=Date,y=Close))+geom_line(color="Blue",size=1)+
  labs(title = "KLCI Index From 2 Jan 2019 until 29 Nov 2019",x="Time",y="Index")+theme_bw()
summary(KLCIBCOV)

KLCI2019<-((KLCIBCOV[226,2]-KLCIBCOV[1,2])/(KLCIBCOV[1,2])*100)
KLCI2020<-((KLCI[268,2]-KLCI[22,2])/(KLCI[22,2])*100)
KLCI2021<-((KLCI[306,2]-KLCI[269,2])/(KLCI[269,2])*100)

change<-data.frame("Year"=c("2019","2020","2021"),"Change"=c(KLCI2019,KLCI2020,KLCI2021))
change%>%ggplot(aes(x=Year,y=Change))+geom_bar(stat="identity")+scale_fill_manual(values ="Blue")

Bef<-as.Date("2019-07-01","%Y-%m-%d")
Dur<-as.Date("2020-08-01","%Y-%m-%d")
newKLCI<-rbind(KLCIBCOV,KLCI)  
newKLCI%>%ggplot(aes(x=Date,y=Close))+geom_line(color="Blue",size=1)+
  labs(title = "KLCI Index From 2 Jan 2019 until 1 Mar 2021",x="Time",y="Index")+theme_bw()+
  geom_vline(xintercept=c(stCov,MCO),color="black",linetype ="dashed")+
  annotate("text", x = c(Bef,stCov,MCO,Dur) ,y=c(1400,1500,1600,1400) , label = c("Before Pandemic","First case","MCO","During Pandemic"))
  


################################
#     Communication Sector     #
###############################
setwd("C:/Users/Hp/Documents/Intern/Data/Communication/Before")
all_files = list.files(path=getwd(),pattern = "*.csv")
ComBef<- lapply(all_files,function(x){
  read.csv(file = x,header = T)
})
names(ComBef)<-c("Axiata","Digi","Telekom")

for (i in 1:length(ComBef)) {
  ComBef[[i]]<-ComBef[[i]]%>%select(c(1,2,7))
  colnames(ComBef[[i]])<-c("Date","Price","Change")
  ComBef[[i]]<-ComBef[[i]]%>%mutate(Date=as.Date(Date,"%b %d, %Y"))
}
summary(ComBef[[1]])


getwd()
setwd("C:/Users/Hp/Documents/Intern/Data/Communication/During")


all_files = list.files(path=getwd(),pattern = "*.csv")
Communication<- lapply(all_files,function(x){
  read.csv(file = x,header = T)
})

names(Communication)<-c("Axiata","Digi","Telekom")
Communication[[1]]<-Communication[[1]]%>%mutate(Date=as.Date(Date,"%d-%b-%y"))
Communication[[2]]<-Communication[[2]]%>%mutate(Date=as.Date(Date,"%d-%b-%y"))
Communication[[3]]<-Communication[[3]]%>%mutate(ï..Date=as.Date(ï..Date,"%b %d, %Y"))


for (i in 1:length(Communication)) {
  Communication[[i]]<-Communication[[i]]%>%select(c(1,2,7))
  colnames(Communication[[i]])<-c("Date","Price","Change")
  
  
}

for(i in 1:3){
  Communication[[i]]<-rbind(ComBef[[i]],Communication[[i]])
}



ggplot(bind_rows(Communication, .id="Company"), aes(Date, Price,color=Company)) +
  geom_line()+scale_color_manual(values = c("blue","green","red"))+
  theme_bw()+ggtitle("Stock Price in Communication Sector")+
  geom_vline(xintercept = c(stCov,MCO),color="black",linetype="dashed")+
  annotate("text", x =c(Bef,stCov,MCO,Dur),y=6.1 , label = c("Before Pandemic","First Case","MCO","During Pandemic"))+
  geom_jitter(alpha = 0, width = 0.01, height = 0.01)+
  guides(colour = guide_legend(override.aes = list(alpha = 1)))





################################
#     Transportation Sector    #
###############################
#####Airline#####

getwd()
setwd("C:/Users/Hp/Documents/Intern/Data/Transport/Airline/Before")
all_files = list.files(path=getwd(),pattern = "*.csv")
AirBef<- lapply(all_files,function(x){
  read.csv(file = x,header = T)
})

names(AirBef)<-c("AirAsia","Malaysia Airport")
for (i in 1:length(AirBef)) {
  AirBef[[i]]<-AirBef[[i]]%>%select(c(1,2,7))
  colnames(AirBef[[i]])<-c("Date","Price","Change")
  AirBef[[i]]<-AirBef[[i]]%>%mutate(Date=as.Date(Date,"%b %d, %Y"))
}
summary(AirBef[[1]])

setwd("C:/Users/Hp/Documents/Intern/Data/Transport/Airline/During")
all_files = list.files(path=getwd(),pattern = "*.csv")
Airline<- lapply(all_files,function(x){
  read.csv(file = x,header = T)
})

names(Airline)<-c("AirAsia","Malaysia Airport")
Airline[[1]]<-Airline[[1]]%>%mutate(ï..Date=as.Date(ï..Date,"%b %d, %Y"))
Airline[[2]]<-Airline[[2]]%>%mutate(Date=as.Date(Date,"%d-%b-%y"))
for (i in 1:length(Airline)) {
  Airline[[i]]<-Airline[[i]]%>%select(c(1,2,7))
  colnames(Airline[[i]])<-c("Date","Price","Change")

}
summary(AirBef[[1]])

for(i in 1:2){
  Airline[[i]]<-rbind(AirBef[[i]],Airline[[i]])
}
ggplot(bind_rows(Airline, .id="Company"), aes(Date, Price,color=Company)) +
  geom_line()+scale_color_manual(values = c("blue","red"))+
  theme_tq()+ggtitle("Stock Price in Transportation Sector for Airline")+
  geom_vline(xintercept = c(stCov,MCO),color="black",linetype="dashed")+
  annotate("text", x =c(Bef,stCov,MCO,Dur),y=c(5,5,3,3) , label = c("Before Pandemic","First Case","MCO","During Pandemic"))+
  geom_jitter(alpha = 0, width = 0.01, height = 0.01)+
  guides(colour = guide_legend(override.aes = list(alpha = 1)))

#######logistic#######
getwd()
setwd("C:/Users/Hp/Documents/Intern/Data/Transport/Logistic/Before")
all_files = list.files(path=getwd(),pattern = "*.csv")
LogBef<- lapply(all_files,function(x){
  read.csv(file = x,header = T)
})

names(LogBef)<-c("GDEX","Pos Malaysia")
for (i in 1:length(LogBef)) {
  LogBef[[i]]<-LogBef[[i]]%>%select(c(1,2,7))
  colnames(LogBef[[i]])<-c("Date","Price","Change")
  LogBef[[i]]<-LogBef[[i]]%>%mutate(Date=as.Date(Date,"%b %d, %Y"))
}
summary(LogBef[[1]])

setwd("C:/Users/Hp/Documents/Intern/Data/Transport/Logistic/During")
all_files = list.files(path=getwd(),pattern = "*.csv")
Log<- lapply(all_files,function(x){
  read.csv(file = x,header = T)
})

names(Log)<-c("GDEX","Pos Malaysia")
for (i in 1:length(Log)) {
  Log[[i]]<-Log[[i]]%>%select(c(1,2,7))
  colnames(Log[[i]])<-c("Date","Price","Change")
  Log[[i]]<-Log[[i]]%>%mutate(Date=as.Date(Date,"%d-%b-%y"))
}
summary(Log[[1]])

for(i in 1:2){
  Log[[i]]<-rbind(LogBef[[i]],Log[[i]])
}

ggplot(bind_rows(Log, .id="Company"), aes(Date, Price,color=Company)) +
  geom_line()+scale_color_manual(values = c("Blue","Black"))+
  theme_tq()+ggtitle("Stock Price in Transportation Sector for Logistic")+
  geom_vline(xintercept = c(stCov,MCO),color="red",linetype="dashed")+
  annotate("text", x =c(Bef,stCov,MCO,Dur),y=c(1,1,2,1.7) , label = c("Before Pandemic","First Case","MCO","During Pandemic"))+
  geom_jitter(alpha = 0, width = 0.01, height = 0.01)+
  guides(colour = guide_legend(override.aes = list(alpha = 1)))

######Shipment####
library(tidyverse)
library(ggplot2)
library(pathchwork)
getwd()
setwd("C:/Users/Hp/Documents/Intern")
GDEX<-read.csv("GDEXM.csv")
names(GDEX)<-c("Date","Price","Shipment")
ggplot(GDEX,aes(x=Shipment,y=Price))+geom_point()
GDEX<-GDEX%>%mutate(Date=as.Date(Date,"%d/%m/%Y"))
Price<-GDEX$Price
ggplot(GDEX,aes(x=Date))+geom_line(aes(y=Shipment))+
  geom_line(aes(y=Price))+
  scale_y_continuous(name="Shipment",sec.axis = sec_axis(Price,name="Price"))
cor(GDEX$Shipment,GDEX$Price,method = "pearson")
cor.test(GDEX$Shipment,GDEX$Price,method = "pearson")
x
Shipment<-Shipment%>%mutate(Date=as.Date(Date,"%b-%y"))
library(zoo)
x<-("Apr-19")
hari<-as.Date(x,"%d %b-%y")







################################
#     HeathCare         #
###############################
getwd()
setwd("C:/Users/Hp/Documents/Intern/Data/Health/Before")
all_files = list.files(path=getwd(),pattern = "*.csv")
HealthBef<- lapply(all_files,function(x){
  read.csv(file = x,header = T)
})

names(HealthBef)<-c("Hartalega","KPJ","PharmaNiaga","TopGlove")
for (i in 1:length(HealthBef)) {
  HealthBef[[i]]<-HealthBef[[i]]%>%select(c(1,2,7))
  colnames(HealthBef[[i]])<-c("Date","Price","Change")
  HealthBef[[i]]<-HealthBef[[i]]%>%mutate(Date=as.Date(Date,"%b %d, %Y"))
}
summary(HealthBef[[1]])

getwd()
setwd("C:/Users/Hp/Documents/Intern/Data/Health/During")
all_files = list.files(path=getwd(),pattern = "*.csv")
Health<- lapply(all_files,function(x){
  read.csv(file = x,header = T)
})

names(Health)<-c("Hartalega","KPJ","PharmaNiaga","TopGlove")
for (i in 1:length(Health)) {
  Health[[i]]<-Health[[i]]%>%select(c(1,2,7))
  colnames(Health[[i]])<-c("Date","Price","Change")
  Health[[i]]<-Health[[i]]%>%mutate(Date=as.Date(Date,"%d-%b-%y"))
}
summary(Health[[1]])

for(i in 1:4){
  Health[[i]]<-rbind(HealthBef[[i]],Health[[i]])
}


ggplot(bind_rows(Health, .id="Company"), aes(Date, Price,color=Company)) +
  geom_line()+scale_color_manual(values = c("blue","green","red","orange"))+
  theme_tq()+ggtitle("Stock Price in Health Sector")+
  geom_vline(xintercept = c(stCov,MCO),color="black",linetype="dashed")+
  annotate("text", x =c(Bef,stCov,MCO,Dur),y=21 , label = c("Before Pandemic","First Case","MCO","During Pandemic"))+
  geom_jitter(alpha = 0, width = 0.01, height = 0.01)+
  guides(colour = guide_legend(override.aes = list(alpha = 1)))

ggplot(bind_rows(Health, .id="Company"), aes(Date, Price,color=Company)) +
  geom_line()+scale_color_manual(values = c(1:length(Health)))+
  theme_tq()+ggtitle("Stock Price in Health Sector")+
  geom_vline(xintercept = as.Date("2020-03-18","%Y-%m-%d"),color="black",linetype="dashed")+
  annotate("text", x =as.Date("2020-03-18","%Y-%m-%d"),y=15 , label = "MCO,18 Mar 20")+
  geom_jitter(alpha = 0.1, width = 0.01, height = 0.01)+
  guides(colour = guide_legend(override.aes = list(alpha = 1)))
