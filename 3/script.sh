#!/bin/bash
# Running with sudo is neccessary!

#1
echo "doing 1..."

for user in $(compgen -u); do
    echo user $user has id $(id -u $user)
done > work3.log

#2
echo "doing 2..."

chage -l root | head -n1 | cut -d : -f 2 >> work3.log

#3
echo "doing 3..."

awk -F : 'ORS="," {print $1}' /etc/group >> work3.log

#4
echo "doing 4..."

echo Be careful > /etc/skel/readme.txt

#5
echo "doing 5..."

useradd u1 -p $(openssl passwd -crypt 12345678)
read
#6
echo "doing 6..."

groupadd g1

#7
echo "doing 7..."

usermod -G g1 u1

#8
echo "doing 8..."

id u1 | cut -d ' ' -f 1,3 >> work3.log

#9
echo "doing 9..."

usermod -G g1 user

#10
echo "doing 10..."

grep "^g1:" /etc/group | cut -d : -f 4 >> work3.log
read
#11
echo "doing 11..."

usermod --shell /usr/bin/mc u1

#12
echo "doing 12..."

useradd u2 -p $(openssl passwd -crypt 87654321)

#13
echo "doing 13..."

mkdir /home/test13
cp work3.log /home/test13/work3-1.log
cp work3.log /home/test13/work3-2.log

#14
echo "doing 14..."

chown -R u1:u2 /home/test13
chmod 640 -R /home/test13
chmod 550 /home/test13

#15
echo "doing 15..."

mkdir /home/test14
chown u1:u1 -R /home/test14
# t -- restricted deletion (sticky)
chmod o+wrt,u-t /home/test14
read
#16
echo "doing 16..."

cp /usr/bin/nano /home/test14
chown u1:u1 /home/test14/nano
chmod u+s /home/test14/nano

#17
echo "doing 17..."

mkdir /home/test15
touch /home/test15/secret_file
chmod 333 /home/test15

# whereis nano
# nano: /usr/bin/nano /usr/share/nano /usr/share/man/man1/nano.1.gz /usr/share/info/nano.info.gz
