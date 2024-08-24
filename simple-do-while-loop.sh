
# simple do-while loop which gets the server name from the user

while [ "$INPUT" != "y" ]
do

read -p "what is your server name : " SERVER_NAME

read -p "Does your server name $SERVER_NAME correct ?" INPUT

done


