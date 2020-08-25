#/bin/bash
COMMAND="$(sudo cyberghostvpn --country-code)"
STATUS="$(sudo cyberghostvpn --status)"
if [ "$STATUS" == "VPN connections found." ]
then
	printf "VPN connection found. Stop connection (y/n): "
	read -r quit
	if [ "$quit" == "n" ]
	then
		exit
	elif [ "$quit" == "y" ]
	then
		sudo cyberghostvpn --stop
		clear
	fi
fi

nr=""
country=""
countrycode=""
list=()

my_array=($(echo $COMMAND | tr "|" "\n"))
for element in "${my_array[@]}"
do
	if [ "$element" -eq "$element" ] 2> /dev/null
	then
		list+=($nr $countrycode "$country")
		nr=$element
		countrycode=""
		country=""
	elif [ $(expr length $element) == 2 ]
	then
		if [ "$element" == "of" ]
		then
			country=$country" "$element
		else
			countrycode=$element
		fi
	elif [ $(expr length $element) \> 2 ]
	then
		country=$country" "$element
	fi
done
sudo cyberghostvpn --country-code
printf "Select Country [No.]: " 
read -r id
id=$((id-1))
index=$((id*3+2))
code=${list[$index]}
index=$((id*3+3))
name=${list[$index]}
namel=$(expr length "$name")
clear
printf "+-"
counter=1
while [ $counter -le $namel ]
do
	printf "-"
	((counter++))
done
printf "+\n"
echo "|$name |"
printf "+-"
counter=1
while [ $counter -le $namel ]
do
	printf "-"
	((counter++))
done
printf "+\n"
printf "[0] Normal\n[1] Streaming\n[2] Torrenting\nChoose mode: "
read -r mode



if [ "$mode" == 1 ]
then
	COMMAND="$(sudo cyberghostvpn --country-code $code --streaming)"

elif [ "$mode" == 2 ]
then
	sudo cyberghostvpn --country-code $code --torrent --connect
	exit
else
	sudo cyberghostvpn --country-code $code --connect
	exit
fi

clear

nr=""
service=""
streamingList=()
last=""

my_array=($(echo $COMMAND | tr "|" "\n"))
for element in "${my_array[@]}"
do
	if [ "$element" -eq "$element" ] 2> /dev/null
	then
		streamingList+=($nr "$service")
		nr=$element
		service=""
	elif [ $(expr length $element) \> 2 ]
	then
		if [ "$element" == "$code" ]
		then
			:
		else
			if [ "$element" == "Netflix" ]
			then
				if ! [ "$code" == "GB" ]
				then
					element="Netflix "$code
				fi
			fi
			service=$service" "$element
		fi
	fi
	last=$element
done
sudo cyberghostvpn --country-code $code --streaming
printf "Choose Service [No.]: "
read -r choosedService
id=$((choosedService*2))
sudo cyberghostvpn --country-code $code --streaming"${streamingList[$id]}" --connect









