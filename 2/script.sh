#!/bin/bash
# Run with sudo is necessary!

if [[ $1 -eq 1 ]]; then
    echo "Trying to unmount if mounted..."

    umount /dev/sda3

    echo "Removing third partition /dev/sda3..."

    echo d > del_param
    echo 3 >> del_param
    echo p >> del_param
    echo w >> del_param

    fdisk /dev/sda < del_param
    lsblk
    exit
fi

if [[ $1 -eq 2 ]]; then
    # 1
    echo "doing 1..."

    echo n > 1_param
    echo p >> 1_param
    echo 3 >> 1_param
    echo >> 1_param
    echo +300M >> 1_param
    echo w >> 1_param

    fdisk /dev/sda < 1_param
    read

    # 2
    echo "doing 2..."

    #blkid /dev/sda3 -o value -s UUID > /root/sda3_UUID
    #echo "\"blkid /dev/sda3 -o value\" result is:"
    blkid /dev/sda3 -o value > /root/sda3_UUID
    #echo
    echo "Written to file:"
    cat /root/sda3_UUID
    read

    # 3
    echo "doing 3..."

    mkfs.ext4 -b 4096 /dev/sda3
    read

    # 4
    echo "doing 4..."

    dumpe2fs -h /dev/sda3 > params_state
    cat params_state
    read

    # 5
    echo "doing 5..."

    tune2fs -c 2 -i 2m /dev/sda3
    read

    # 6
    echo "doing 6..."

    mkdir /mnt/newdisk
    mount /dev/sda3 /mnt/newdisk
    read

    # 7
    echo "doing 7..."

    ln -s /mnt/newdisk /root/newdisk
    ls -l /root
    read

    # 8
    echo "doing 8..."

    mkdir /mnt/newdisk/donaldo
    ls -l /mnt/newdisk
    read

    # 9
    echo "doing 9..."

    echo "/dev/sda3 /mnt/newdisk ext4 noexec,noatime 0 0" >> /etc/fstab
    # reboot
    exit
fi

echo "#!/bin/bash" > /mnt/newdisk/script
echo "echo \"Hello, World!\"" >> /mnt/newdisk/script
chmod ugo+x /mnt/newdisk/script
ls -l /mnt/newdisk
/mnt/newdusk/script
read

# 10
echo "doing 10..."

umount /dev/sda3

echo d > 10_param
echo 3 >> 10_param

echo n >> 10_param
echo p >> 10_param
echo 3 >> 10_param
echo >> 10_param
echo +350M >> 10_param
echo w >> 10_param

fdisk /dev/sda < 10_param

e2fsck -f /dev/sda3
resize2fs /dev/sda3

# 11
echo "doing 11..."

e2fsck -n /dev/sda3

# 12
echo "doing 12..."

echo n > 12_param
echo >> 12_param
echo >> 12_param
echo +12M >> 12_param
echo w >> 12_param

fdisk /dev/sda < 12_param

mkfs.ext4 /dev/sda4
tune2fs -J location=/dev/sda4 /dev/sda3

# 13
echo "doing 13..."

echo n > 13_param
echo >> 13_param
echo >> 13_param
echo +100M >> 13_param
echo $(cat 13_param) >> 13_param
echo w >> 13_param

fdisk /dev/sda < 13_param

# 14
echo "doing 14..."

vgcreate LVM /dev/sda5 /dev/sda6
lvcreate -l 100%FREE -n LVM LVM

mkdir /mnt/supernewdisk
mkfs.ext4 /dev/LVM/LVM
mount /dev/LVM/LVM /mnt/supernewdisk

# 15
echo "doing 15..."

mkdir /mnt/share
mount.cifs //192.168.1.1/shared /mnt/share -o username=donaldo,password=mamba123

# 16
echo "doing 16..."

echo "//192.168.1.1/shared /mnt/share cifs user=donaldo,password=mamba123 0 0" >> /etc/fstab

