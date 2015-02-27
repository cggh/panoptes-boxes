First you will need to install Chef from https://downloads.chef.io/chef-dk

Then download Packer from https://www.packer.io/downloads.html - /usr/local/bin is a good place to put the extracted files

If you want to use it Vagrant from http://www.vagrantup.com/downloads.html (not via apt-get install)

Run common/create-vendor-cookbooks.sh - this downloads the necessary Chef cookbooks - including chef-panoptes

See the README.md in the packer directory for what to do next in detail.

Quick start
```
cd common
./create-vendor-cookbooks.sh
```

The easiest way to get to a VirtualBox running panoptes is:
```
cd vagrant
vagrant up
```
This starts from a vanilla Ubuntu box and installs panoptes using Chef so while it's easy it's not that quick the first time you run it.
If you need to reconfigure the box with new Chef scripts then you can do so by running:
```
vagrant provision
```

To create a customized box

Copy and/or edit packer/trusty-panoptes.json to match your requirements
A list of available properties to set in the json file can be found in common/vendor-cookbooks/panoptes/attributes/default.rb

Create your image - how to do this, and what to do next, depends on whether you want to run under EC2, VirtualBox, Vagrant or Docker

To create an instance running under EC2

Edit packer/create-ami.sh to fill in your AWS credentials
Once the AMI has been created you can then launch an instance from it

Things to do once the instance has been launched

Create users (only ubuntu by default)
```
apt-get install etckeeper
```

```
dpkg-reconfigure -plow unattended-upgrade
```

You will need to configure mount points and make sure that the directories created by the chef scripts are on the right volume
Setup the extra storage
```
fdisk /dev/xvdb
```
Create a new primary partition, write and exit (n,p,w)
```
mkfs.ext4 /dev/xvdb1
```
Edit /etc/fstab

If you want to change the mysql tmpdir you will need to do this by hand as the mysql receipe doesn't support this yet - see issue #281 - don't forget the apparmor configuration (which is why it can't easily be done in the panoptes receipe)


This link provides a useful description of how Packer and Vagrant can work together http://pretengineer.com/post/packer-vagrant-infra/
