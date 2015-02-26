ACCESS_KEY=
SECRET_KEY=

#Note that the instance type is only used during creation of the AMI so can be a t1.micro - you set the actual values
#when launching an instance based off that AMI
packer build -only amazon-ebs -var "aws_access_key=${ACCESS_KEY}" -var "aws_secret_key=${SECRET_KEY}" trusty-panoptes.json
