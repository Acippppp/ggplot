install.packages("Sim.DiffProc") #package for stochastic simulation
library(Sim.DiffProc)
library(ggplot2)
library(tsibble)
library(tibble)
library(tidyverse)
###Simulating square root process using E-M method
# N= size of process
# M= number of simulation
# x0= initial value
# t0= initial time
# T= final time
# drift = drift coefficient
# diffusion= diffusion coefficient
f<- expression(1)
g<- expression(2*sqrt(abs(x)))

path<- snssde1d(N=1000,M=100,x0=1,t0=0,T=3,drift = f,diffusion = g,method = "euler") #change value of M if want to increase no. of simulation
plot(path,main="Simulation of Square root Process",col=c(2:10),ylim=c(0,10))
lines(time(path),apply(path$X,1,mean),col=1,lwd=5) #mean line
ggplot(path, aes(x-Time ,y=path$X,color = series)) +geom_line()
autoplot((mean(path$X<5)))
class(path$X)

##simulate with 10,000 trails
trials <- 10000
simlist <- numeric(trials)
n<- 1000
for(k in 1:trials){
  
  x<- 1 #initial value
  T<- 3 #final time
  for(i in 1:n){
    sigma<-2*sqrt(abs(x))
    x<- x+T/n + sigma*sqrt(T/n)*rnorm(1)
      
  }
  simlist[k]<- x
}
mean(simlist) #estimated E[x3]
var(simlist) #estimated Var[x3]
mean(simlist<5)#estimated P[X3<5]

P_X3 <- pnorm(-1+sqrt(5),0,sqrt(3))-pnorm(-1-sqrt(5),0,sqrt(3)) #Exact Value 










