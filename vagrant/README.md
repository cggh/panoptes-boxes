The Vagrantfile is set up to create a VirtualBox based on a json configuration file.
This json file can later be used by Packer to create an Amazon AMI

The default json file is dev.json - this creates a configured image that will run MySQL and Apache.
Panoptes options can be configured in this json file

The ip address of this box is also set in the json file (see also ../packer/README.md)

The current directory is shared with the Vagrant VM and the panoptes application is run from ./panoptes

To start the VM
```
vagrant up
```
To connect to the VM
```
vagrant ssh
```

The git directories are checked out using https - to change to ssh:
```
git remote set-url origin git@github.com:cggh/panoptes.git
```
As symbolic links use absolute paths you probably also want to (although it's not necessary)
```
sudo ln -s ${PWD} /vagrant
```
Vagrant Notes
config.vm.synced_folder has global permissions set - otherwise only the vagrant user can modify it - this is due to limitations with VirtualBox
