#!/bin/bash

IF1="eth0"
IF2="eth1"

IP1="10.0.2.15"
IP2="172.18.0.4"

GW1="10.0.2.2"
GW2="172.18.0.5"

GW1_NET="10.0.2.0/24"
GW2_NET="172.18.0.0/24"

OLDIF1=0
OLDIF2=0

while true
do




ping -c 3 -s 10 $GW1 -I $IF1 > /dev/null

if [ $? -ne 0 ]; then
  echo "Failed IF1!_$(date)" >> /home/geek/balancing_gw.log
  NEWIF1=0
else
  NEWIF1=1
  #echo "$NEWIF1"
fi


ping -c 3 -s 10 $GW2 -I $IF2 > /dev/null

if [ $? -ne 0 ]; then
  echo "Failed IF2!_$(date)" >> /home/geek/balancing_gw.log
  NEWIF2=0
else
  NEWIF2=1
 # echo "$NEWIF2"
fi


if (( ($NEWIF1!=$OLDIF1) || ($NEWIF2!=$OLDIF2) ))
 then

 echo "Changing routes_$(date)" >> /home/geek/balancing_gw.log


  if (( ($NEWIF1==1) && ($NEWIF2==1) ))
   then
      echo "Both channels UP!_$(date)" >> /home/geek/balancing_gw.log 
      /home/geek/main_table
 
  elif (( ($NEWIF1==1) && ($NEWIF2==0) ))
    then

       echo "Down ISP2!_$(date)" >> /home/geek/balancing_gw.log && sleep 1 && /home/geek/101.route
 
  elif (( ($NEWIF1==0) && ($NEWIF2==1) ))
    then

       echo "Down ISP1!_$(date)" >> /home/geek/balancing_gw.log && sleep 1 && /home/geek/102.route

 fi

else

 echo "not changing_$(date)" >> /home/geek/balancing_gw.log
 #/home/geek/main_table
fi


OLDIF1=$NEWIF1
OLDIF2=$NEWIF2
#break
sleep 20
done
