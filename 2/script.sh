#!/bin/bash
# Run with sudo is necessary!

sda=$(udevadm info /dev/sda --query=symlink --root | tr " " "\n" | grep "^/dev/disk/by-id/ata")
sda3="${sda}-part3"
sda4="${sda}-part4"
sda5="${sda}-part5"
sda6="${sda}-part6"

if [[ $1 -eq 1 ]]; then
    echo "Trying to unmount if mounted..."

    umount $sda3

    echo "Removing third partition /dev/sda3..."

    fdisk $sda << del_param
    d
    3
    p
    w
del_param

    lsblk
    exit
fi

if [[ $1 -eq 2 ]]; then
    # 1

    fdisk $sda << 1_param
    n
    p
    3
    ''
    +300M
    w
1_param

    # 2

    blkid $sda3 -o value > /root/sda3_UUID

    # 3

    mkfs.ext4 -b 4096 $sda3

    # 4

    dumpe2fs -h $sda3

    # 5

    tune2fs -c 2 -i 2m $sda3

    # 6

    mkdir /mnt/newdisk
    mount $sda3 /mnt/newdisk

    # 7

    ln -s /mnt/newdisk /root/newdisk
    ls -l /root

    # 8

    mkdir /mnt/newdisk/donaldo
    ls -l /mnt/newdisk

    # 9

    if cat /etc/fstab | grep "^$sda3"
    then
        echo "Already there"
    else
        echo "$sda3 /mnt/newdisk ext4 noexec,noatime 0 0" >> /etc/fstab
    fi
    # reboot
    exit
fi

echo "#!/bin/bash" > /mnt/newdisk/script
echo "echo \"Hello, World!\"" >> /mnt/newdisk/script
chmod ugo+x /mnt/newdisk/script
ls -l /mnt/newdisk
/mnt/newdusk/script

# 10
echo "doing 10..."

umount $sda3

fdisk $sda << 10_param
d
3
n
p
3
''
+350M
w
10_param

e2fsck -f $sda3
resize2fs $sda3

# 11

e2fsck -n $sda3

# 12

fdisk $sda << 12_param
n
''
''
+12M
w
12_param

mkfs.ext4 $sda4
tune2fs -J location=/dev/sda4 $sda3

# 13

fdisk $sda << 13_param
n
''
''
+100M
n
''
''
+100M
w
13_param

# 14

vgcreate LVM $sda5 $sda6
lvcreate -l 100%FREE -n LVM LVM

mkdir /mnt/supernewdisk
mkfs.ext4 /dev/LVM/LVM
mount /dev/LVM/LVM /mnt/supernewdisk

# 15

mkdir /mnt/share
mount.cifs //192.168.1.1/shared /mnt/share -o username=donaldo,password=mamba123

# 16

if cat /etc/fstab | grep "^//192.168.1.1/shared"
then
    echo "Already there"
else
    echo "//192.168.1.1/shared /mnt/share cifs user=donaldo,password=mamba123 0 0" >> /etc/fstab
fi
