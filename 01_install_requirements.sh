#!/usr/bin/env bash
set -x

source common.sh

sudo setenforce permissive

sudo yum -y install curl vim-enhanced epel-release wget python-pip
sudo yum -y install https://dprince.fedorapeople.org/tmate-2.2.1-1.el7.centos.x86_64.rpm

sudo pip install lolcat

# for tripleo-repos install:
sudo yum -y install python-setuptools python-requests patch

cd
git clone https://git.openstack.org/openstack/tripleo-repos
cd tripleo-repos
sudo python setup.py install
cd
#sudo tripleo-repos current
#sudo tripleo-repos current-tripleo

# current-tripleo is broken for the all-in-one atm.
sudo tripleo-repos current-tripleo-dev

sudo yum install -y python2-tripleoclient

# TRIPLEO HEAT TEMPLATES
if [ ! -d $SCRIPTDIR/tripleo-heat-templates ]; then
  cd $SCRIPTDIR
  git clone git://git.openstack.org/openstack/tripleo-heat-templates
  cd tripleo-heat-templates
  cat ../octavia_hack.patch | patch -p1
fi

