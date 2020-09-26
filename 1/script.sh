#!/bin/sh

if [[ $1 -eq 1 ]]; then
    echo "Removing /home/user/test.."
    rm -r test &> /dev/null
    exit
fi

h=/home/user

#1
echo "doing 1.."

mkdir -p $h/test

#2
echo "doing 2.."

ls -AR > $h/test/list

#3
echo "doing 3.."

find /etc -type d | wc -l >> $h/test/list
find /etc -type f -name ".*" | wc -l >> $h/test/list

#4
echo "doing 4.."

mkdir -p $h/test/links

#5
echo "doing 5.."

ln $h/test/list $h/test/links/list_hlink

#6
echo "doing 6.."

ln -s $h/test/list $h/test/links/list_slink

#7
echo "doing 7.."

stat -c %h $h/test/links/list_hlink $h/test/list $h/test/links/list_slink

#8
echo "doing 8.."

wc -l < $h/test/list >> list_hlink

#9
echo "doing 9.."

if cmp $h/test/links/list_hlink $h/test/links/list_slink &> /dev/null
then
    echo "YES"
fi

#10
echo "doing 10.."

mv $h/test/list $h/test/list1

#11
echo "doing 11.."

if cmp $h/test/links/list_hlink $h/test/links/list_slink &> /dev/null
then
    echo "YES"
fi


#12 wtf list_link -> list
#links!!
echo "doing 12.."

ln $h/test/links $h/list1

#13
echo "doing 13.."

find /etc -type f -name "*.conf" > $h/list_conf

#14
echo "doing 14.."

find /etc -type d -name "*.d" > $h/list_d

#15
echo "doing 15.."

cat $h/list_conf $h/list_d > $h/list_conf_d

#16
echo "doing 16.."

mkdir -p $h/test/.sub

#17
echo "doing 17.."

cp $h/list_conf_d $h/test/.sub

#18
echo "doing 18.."

cp --backup=simple $h/list_conf_d $h/test/.sub

#19
echo "doing 19.."

#find ../
find $h/test

#20
echo "doing 20.."

man man > $h/man.txt

#21
echo "doing 21.."

split -b 1024 -d --additional-suffix=.txt $h/man.txt man.
#find . -type f -name "man.*.txt"

#22
echo "doing 22.."

mkdir -p $h/man.dir

#23
echo "doing 23.."

#for (( num = ($(man man | wc -c) >> 10); num > -1; --num)); do
#    mv man.$num.txt man.dir
#done
mv $h/man.[0-9][0-9].txt $h/man.dir

#24
echo "doing 24.."

cat $h/man.dir/man.[0-9][0-9].txt > $h/man.dir/man.txt

#25
echo "doing 25.."

if cmp $h/man.txt $h/man.dir/man.txt &> /dev/null
then
    echo "YES"
fi

#26
echo "doing 26.."

#get_random_string() {
#    len=$(( $RANDOM % 10 + 1 ))
#    str=""
#    for (( i = 0; i < len; ++i )); do
#        ;
#    done
#}

rand_str=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
sed -i '1 i\$rand_str' $h/man.txt
sed -i -e '$a$rand_str' $h/man.txt

#27
echo "doing 27.."

diff -u $h/man.txt $h/man.dir/man.txt > $h/man.diff

#28
echo "doing 28.."

mv $h/man.diff $h/man.dir

#29
echo "doing 29.."

patch < $h/man.dir/man.diff

#30
echo "doing 30.."

if cmp $h/man.txt $h/man.dir/man.txt &> /dev/null
then
    echo "YES"
fi
