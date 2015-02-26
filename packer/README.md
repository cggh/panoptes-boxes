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

Import the created ovf
```
VBoxManage import output-virtualbox-iso/trusty-panoptes.ovf
```

You can start the vm with:
```
VBoxHeadless --startvm "trusty-panoptes"
```

And stop with:
```
VBoxManage controlvm "trusty-panoptes" poweroff
```

Once you have the box up and running (IP address as set in your packer/trusty-panoptes.json file)

http://192.168.56.23/admin.html

Troubleshooting

You can look at VMs available using the following commands
```
VBoxManage -nologo list vms
```

If you see something like this:
==> virtualbox-iso: Unregistering and deleting virtual machine...
==> virtualbox-iso: Error deleting virtual machine: VBoxManage error: VBoxManage: error: Could not find a registered machine named 'trusty-panoptes'
==> virtualbox-iso: VBoxManage: error: Details: code VBOX_E_OBJECT_NOT_FOUND (0x80bb0001), component VirtualBox, interface IVirtualBox, callee nsISupports
==> virtualbox-iso: VBoxManage: error: Context: "FindMachine(Bstr(VMName).raw(), machine.asOutParam())" at line 154 of file VBoxManageMisc.cpp

Then try:
```
VBoxManage registervm ~/VirtualBox\ VMs/trusty-panoptes/trusty-panoptes.vbox
```

Uploading AMI to AWS
---
```
cd packer
packer build -only amazon-ebs -var 'aws_access_key=YOUR ACCESS KEY' -var 'aws_secret_key=YOUR SECRET KEY' trusty-panoptes.json
```

Running Packer VM on Vagrant
---
You can create a Vagrant box by adding a Packer post-processor at the end of the json file
Note that if you do this then do don't get the ovf to import into VirtualBox
```
  "post-processors": [{
                       "type": "vagrant",
                       "only": ["virtualbox-iso"]
                     }]
```
Once set up then you can start the box, using the supplied Vagrantfile, with
```
vagrant box add my-vb-box ./packer_virtualbox-iso_virtualbox.box
vagrant init my-vb-box
vi Vagrantfile.template 
cp Vagrantfile.template Vagrantfile
```

```
vagrant up
```
Connect using
```
vagrant ssh
```
(Networking not worked out yet)
