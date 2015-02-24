Install Packer
---
Follow [Packer's installation page](http://www.packer.io/intro/getting-started/setup.html)

Creating a Packer box
---
Create a host-only network interface for VirtualBox (unless ```ifconfig -a``` already lists ```vboxnet0```)
```
VBoxManage hostonlyif create >/dev/null 2>&1
```

Now assign an IP to this interface with a subnet that doesn't conflict with your home ones (avoid ```192.168.0.x```), for example ```192.168.23.x```
```
vboxmanage hostonlyif ipconfig vboxnet0 --ip 192.168.56.1 --netmask 255.255.255.0
```

Edit file ```packer/trusty-panoptes.json``` to choose an IP that can be bridged to one of your host Network Interfaces:
```
{
  "type": "shell",
  "execute_command": "echo 'vagrant' | sudo -S sh '{{ .Path }}'",
  "inline": ["/tmp/static-ip.sh 192.168.23.223 192.168.23.1 255.255.255.0"]
}
```

To generate the box:
```
cd packer
packer build -only virtualbox-iso trusty-panoptes.json
```
This will create a ```packer/output-virtualbox-iso``` folder containing ```<box-name>.ovf``` and ```<box-name>.vdmk```, ready to be imported into VirtualBox.

The user/password to login is vagrant/vagrant
You can also create a Vagrant box by adding a Packer post-processor

Uploading AMI to AWS
---
```
cd packer
packer build -only amazon-ebs -var 'aws_access_key=YOUR ACCESS KEY' -var 'aws_secret_key=YOUR SECRET KEY' trusty-panoptes.json
```

Running Packer VM on Vagrant
---
If you want to create a VM with Packer and then run it with Packer, you can use  [this Vagrantfile]

Simply run ```vagrant up``` from the ```packer``` folder.
