#!/bin/bash
# Printing the names of the columns as first row in file

EMAIL_ADDRESS="jfreitas.mat@gmail.com"

echo "Day; Time; CPU usage(%); Core 0; Core 1; Core 2; Core 3; Core 4; Core 5; Core 6; Core 7; Core 8; Core 9; Core 10; Core 11; Core 12; Core 13; Core 14; Core 15" > historico_temperatura.csv

i=0

while true
do

    my_array[0]="$(date +"%d-%m-%Y")"
    my_array[1]="$(date +"%H:%M:%S")"
    my_array[2]="$(top -n 1 -b | grep -i '%CPU(s):' | awk '{print $2}')"
    my_array[3]="$(sensors -A | head -n 10 |  grep 'Core 0:' | awk '{print $3}' | egrep -o '[0-9]*\.[0-9]*')"
    my_array[4]="$(sensors -A | head -n 10 | grep 'Core 1:' | awk '{print $3}' | egrep -o '[0-9]*\.[0-9]*')"
    my_array[5]="$(sensors -A | head -n 10 | grep 'Core 2:' | awk '{print $3}' | egrep -o '[0-9]*\.[0-9]*')"
    my_array[6]="$(sensors -A | head -n 10 | grep 'Core 3:' | awk '{print $3}' | egrep -o '[0-9]*\.[0-9]*')"
    my_array[7]="$(sensors -A | head -n 10 | grep 'Core 4:' | awk '{print $3}' | egrep -o '[0-9]*\.[0-9]*')"
    my_array[8]="$(sensors -A | head -n 10 | grep 'Core 5:' | awk '{print $3}' | egrep -o '[0-9]*\.[0-9]*')"
    my_array[9]="$(sensors -A | head -n 10 | grep 'Core 6:' | awk '{print $3}' | egrep -o '[0-9]*\.[0-9]*')"
    my_array[10]="$(sensors -A | head -n 10 | grep 'Core 7:' | awk '{print $3}' | egrep -o '[0-9]*\.[0-9]*')"
    my_array[11]="$(sensors -A | tail -n 22 |  grep 'Core 0:' | awk '{print $3}' | egrep -o '[0-9]*\.[0-9]*')"
    my_array[12]="$(sensors -A | tail -n 22 | grep 'Core 1:' | awk '{print $3}' | egrep -o '[0-9]*\.[0-9]*')"
    my_array[13]="$(sensors -A | tail -n 22 | grep 'Core 2:' | awk '{print $3}' | egrep -o '[0-9]*\.[0-9]*')"
    my_array[14]="$(sensors -A | tail -n 22 | grep 'Core 3:' | awk '{print $3}' | egrep -o '[0-9]*\.[0-9]*')"
    my_array[15]="$(sensors -A | tail -n 22 | grep 'Core 4:' | awk '{print $3}' | egrep -o '[0-9]*\.[0-9]*')"
    my_array[16]="$(sensors -A | tail -n 22 | grep 'Core 5:' | awk '{print $3}' | egrep -o '[0-9]*\.[0-9]*')"
    my_array[17]="$(sensors -A | tail -n 22 | grep 'Core 6:' | awk '{print $3}' | egrep -o '[0-9]*\.[0-9]*')"
    my_array[18]="$(sensors -A | tail -n 22 | grep 'Core 7:' | awk '{print $3}' | egrep -o '[0-9]*\.[0-9]*')"

    (IFS=\;; echo "${my_array[*]}") >> historico_temperatura.csv

    ((i++))
    
    if [[ "$i" -eq 10000 ]]; then
        gzip -k /home/jfreitas/scripts/historico_temperatura.csv
        
        /usr/bin/mail -A /home/jfreitas/scripts/historico_temperatura.csv.gz -s "Backup do historico da temperatura" "$EMAIL_ADDRESS"
        
        i=0
        
        rm /home/jfreitas/scripts/historico_temperatura.csv.gz
    fi

    sleep 5
done