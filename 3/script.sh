#!/bin/bash
# Running with sudo is neccessary!

#1
echo "doing 1..."

for user in $(compgen -u); do
    echo user $user has id $(id -u $user)
done > works3.log

#2
echo "doing 2..."

chage -l root | head -n1 | cut -d : -f 2 >> works3.log

#3
echo "doing 3..."

awk -F : 'ORS="," {print $1}' /etc/group >> works3.log

#4
echo "doing 4..."

echo Be careful > /etc/skel/readme.txt

#5
echo "doing 5..."

useradd u1 $(openssl passwd 12345678)

#6
echo "doing 6..."

#7
echo "doing 7..."

#8
echo "doing 8..."

#9
echo "doing 9..."

#10
echo "doing 10..."

#11
echo "doing 11..."

#12
echo "doing 12..."

#13
echo "doing 13..."

#14
echo "doing 14..."

#15
echo "doing 15..."

#16
echo "doing 16..."

#17
echo "doing 17..."

