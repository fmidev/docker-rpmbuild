# Usage

docker pull fmidev/rpmbuild:el7
mkdir RPMS
docker run --rm -v $HOME/RPMS/:/home/rpmbuild/rpmbuild/RPMS/ fmidev/rpmbuild:el7 githubaddress 

