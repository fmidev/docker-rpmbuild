#!/bin/sh
set -e

[[ -z $RPM_BUILD_NCPUS ]] && RPM_BUILD_NCPUS=2

if ! whoami &> /dev/null; then
  if [ -w /etc/passwd ]; then
    echo "${USER_NAME:-default}:x:$(id -u):0:${USER_NAME:-default} user:${HOME}:/sbin/nologin" >> /etc/passwd
  fi
fi

# Test if proxy is needed
wget -q -t 1 --spider www.google.com
if [ $? -ne 0 ]; then
    echo Using proxy http://wwwproxy.fmi.fi:8080
    export http_proxy=http://wwwproxy.fmi.fi:8080
    export https_proxy=http://wwwproxy.fmi.fi:8080
    sudo sh -c 'echo proxy=http://wwwproxy.fmi.fi:8080 >> /etc/yum.conf'
fi

free -h
ls -la $HOME/rpmbuild/RPMS/
mkdir -p $HOME/rpmbuild/RPMS/x86_64
createrepo $HOME/rpmbuild/RPMS/x86_64
sudo yum repolist
sudo yum --disablerepo="*" --enablerepo="local" list available

cd $HOME/rpmbuild/SOURCES/
# If argument is folder, use that, else clone from github
if [[ "$1" == http?://* ]]; then
  git clone $1
  REPO=$(ls -1)
else
  REPO=$1
  rsync -vr /src/$REPO .
fi

tar zcvf $REPO.tar.gz --exclude-vcs $REPO
sudo yum-builddep -y $REPO/*.spec
rpmbuild -ba --define "_smp_mflags -j$RPM_BUILD_NCPUS" $REPO/*.spec
createrepo $HOME/rpmbuild/RPMS/x86_64
