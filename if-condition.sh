

echo "input your os as ubuntu or centos only"
read os

#simple if condition
if [ $os = "ubuntu" ]; then
	echo "assign ubuntu VM for Tharmika Ravichandran"
fi	


# if else conditions

if [ $os = "centos" ]; then
	echo "assign centos VM for Tharmika Ravichandran"
else
	echo "assign default VM"
fi


# if elseif condition

if [ $os = "ubuntu" ]; then
	echo "good luck"
elif [ $os = "centos" ]; then
	echo "awsome work"
else 
	echo "well done go ahead"
fi


