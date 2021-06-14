dir<- "C:/Users/Hp/Documents/Baby"
all_files = list.files()
datalist<-lapply(all_files,function(x){
  read.table(file=x,header = F,sep = ",")
})


babydata<-file.path("C:/Users/Hp/Documents/Baby")
setwd(babydata)
all_files = list.files(path=babydata,pattern = "*.txt")
babylist<- lapply(all_files,function(x){
  read.table(file = x,header = F,sep=",")
})


library(dplyr)
all_years<-list()
newbabydata<-list()
for(i in 1:140){
  babylist[[i]]<-babylist[[i]]%>%mutate(Proportion=V3/sum(V3),Year=rep(1880+i-1,nrow(babylist[[i]])))
  
  
  names(babylist[[i]])<-c("Name","Sex","Occurence","Proportion","Year")
  
}
babydf<-do.call("rbind",babylist)

baby<-function(name,sex,data){
  z<-data%>%filter(Name==name,Sex==sex)%>%
    select(Year,Proportion)
  plot(z,type='l',xlab="Year",ylab="Proportion",main=paste("Proportion of babies named",name,"by year"))
  print(z[,2])
}

proportion=baby(name = "Emma",sex = "F",data=babydf)

babydf%>%filter(Name=="Emma")

emma.proportions =
    c(0.00994, 0.01056,  0.0104, 0.01091, 0.01063, 0.01133, 0.01083, 
      0.0107, 0.01031, 0.00998, 0.00989, 0.01006, 0.00935, 0.00913, 
      0.00867, 0.00841, 0.00803, 0.00778, 0.00731, 0.00721, 0.00687, 
      0.00686,  0.0065, 0.00605, 0.00573, 0.00542, 0.00519, 0.00506, 
      0.00482, 0.00457, 0.00441, 0.00406,  0.0034, 0.00306,  0.0028, 
      0.00275,  0.0027, 0.00255, 0.00245, 0.00241, 0.00231, 0.00217, 
      0.00219, 0.00216, 0.00206, 0.00202, 0.00195, 0.00187, 0.00178, 
      0.00173,  0.0016, 0.00157, 0.00158, 0.00158, 0.00142, 0.00134, 
      0.00136, 0.00129, 0.00121, 0.00122, 0.00113, 0.00104, 0.00095, 
      0.00086, 0.00083, 0.00077, 0.00065, 0.00059, 0.00061, 0.00057, 
      0.00054, 0.00047, 0.00045, 0.00041, 0.00038, 0.00036, 0.00033, 
      0.00029, 0.00026, 0.00025, 0.00024, 0.00021,   2e-04, 0.00018, 
      2e-04, 0.00018, 0.00018, 0.00017, 0.00015, 0.00015, 0.00015, 
      0.00014, 0.00014, 0.00014, 0.00016, 0.00016, 0.00014, 0.00015, 
      0.00014, 0.00015, 0.00015, 0.00015, 0.00016, 0.00016, 0.00019, 
      0.00026, 0.00035, 0.00044, 0.00048,   5e-04, 0.00061, 0.00067, 
      0.00084, 0.00109, 0.00128, 0.00138, 0.00168, 0.00214, 0.00284, 
      0.00318, 0.00332, 0.00356, 0.00443, 0.00597, 0.00566, 0.00529, 
      0.00484,  0.0046, 0.00479, 0.00469,  0.0047, 0.00515, 0.00573, 
      0.00575, 0.00566, 0.00554, 0.00533, 0.00556, 0.00536,0.00496)
  
stopifnot(isTRUE(all.equal(proportion, emma.proportions, tolerance = .001)))



