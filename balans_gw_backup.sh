#!/bin/bash

IF1="enp4s0"
IF2="enp8s0f0"

IP1="134.249.157.142"
IP2="217.77.210.26"

GW1="134.249.157.254"
GW2="217.77.210.25"

#GW1_NET=""
#GW2_NET=""

OLDIF1=0
OLDIF2=0

while true
do




ping -c 3 -s 10 $GW1 -I $IF1 > /dev/null

if [ $? -ne 0 ]; then
  echo "Failed IF1!_$(date)" >> /home/yurii.vo/balancing_gw.log
  NEWIF1=0
else
  NEWIF1=1
  #echo "$NEWIF1"
fi


ping -c 3 -s 10 $GW2 -I $IF2 > /dev/null

if [ $? -ne 0 ]; then
  echo "Failed IF2!_$(date)" >> /home/yurii.vo/balancing_gw.log
  NEWIF2=0
else
  NEWIF2=1
 # echo "$NEWIF2"
fi


if (( ($NEWIF1!=$OLDIF1) || ($NEWIF2!=$OLDIF2) ))
 then

 echo "Changing routes_$(date)" >> /home/yurii.vo/balancing_gw.log


  if (( ($NEWIF1==1) && ($NEWIF2==1) ))
   then
      echo "Both channels UP!_$(date)" >> /home/yurii.vo/balancing_gw.log 
      /home/geek/#main_table
 
  elif (( ($NEWIF1==1) && ($NEWIF2==0) ))
    then

       echo "Down ISP2!_$(date)" >> /home/yurii.vo/balancing_gw.log && sleep 1 && /home/yurii.vo/#101.route
 
  elif (( ($NEWIF1==0) && ($NEWIF2==1) ))
    then

       echo "Down ISP1!_$(date)" >> /home/yurii.vo/balancing_gw.log && sleep 1 && /home/yurii.vo/#102.route

 fi

else

 echo "not changing_$(date)" >> /home/yurii.vo/balancing_gw.log
fi


OLDIF1=$NEWIF1
OLDIF2=$NEWIF2
#break
sleep 60
done
