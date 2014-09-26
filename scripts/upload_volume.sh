#! /bin/bash
#to run script: pass image name as argument

size=$(stat -Lc%s $1)
virsh vol-create-as default centos $size --format raw
virsh vol-upload --pool default centos $1
