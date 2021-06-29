#!/bin/bash
# Running with sudo is neccessary!

# 1
yum -y group install "Development Tools"

# 2
mkdir -p batset
yum -y install boost boost-thread boost-devel ncurses-devel
tar -zxvf /mnt/share/batset-0.43.tgz -C batset/
make

patch Makefile < inserting_bastet
make install

# 3
rpm -qa > task3.log

# 4
yum deplist gcc > task4_1.log
rpm -q --whatrequires libgcc > task4_2.log

# 5
mkdir -p localrepo
cp /mnt/share/checkinstall-1.6.2-3.el6.1.x86_64.rpm localrepo

yum -y install createrepo yum-utils
createrepo .
echo -e "[localrepo]\nname=localrepo\nbaseurl=file:/$(pwd)/localrepo/\nenabled=1\ngpgcheck=0" > /etc/yum.repos.d/localrepo.repo

# 6
yum repolist enabled > task6.log

# 7
for f in /etc/yum.repos.d*; do
	mv "$f" "$(echo "$f" | sed s/repo/old/)";
done

yum list available
yum -y install localrepo/checkinstall-1.6.2-3.el6.1.x86_64.rpm

# 8
cp /mnt/share/fortunes-ru_1.52-2_all.deb .
yum -y install epel-release alien 

alien --to-rpm fortunes-ru_1.52-_all.deb
rpm fortunes-ru_1.52-3_all.noarch.rpm

# 9
yumdownloader --source nano
rpm -ihv nano-2.9.8-1.el8.src.rpm

patch /root/rpmbuild/SPECS/nano.spec < inserting_nano
rpmbuild --bb /root/rpmbuild/SPECS/nano.spec
yum remove -y nano
yum install -y /root/rpmbuild/RPMS/x86_64/nano-2.9.8-1.el8.src.rpm