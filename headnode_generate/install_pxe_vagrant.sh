vagrant ssh pxe -c "
                    sudo yum install dhcp; \
                    sudo yum install tftp-server; \


                    cat disable=no > /etc/xinetd.d/tftp; \

                    service xinetd restart; \

                    yum install syslinux; \

                    cp /usr/lib/syslinux/pxelinux.0 /tftpboot; \
                    cp /usr/lib/syslinux/menu.c32 /tftpboot; \
                    cp /usr/lib/syslinux/memdisk /tftpboot; \
                    cp /usr/lib/syslinux/mboot.c32 /tftpboot; \
                    cp /usr/lib/syslinux/chain.c32 /tftpboot; \
                    
                    mkdir /tftpboot/pxelinux.cfg;
                    
                    wget http://mirror.web-ster.com/centos/7.0.1406/isos/x86_64/CentOS-7.0-1406-x86_64-Everything.iso
                    sudo mkdir /mnt/iso
                    sudo mount -t iso9660 -o loop CentOS-7.0-1406-x86_64-Everything.iso /mnt/iso

                    mkdir -p /tftpboot/images/centos/x86_64/6
                    cp /mnt/iso/images/pxeboot/* /tftpboot/images/centos/x86_64/6

                    cat > /etc/dhcp.conf <<EOF
allow booting;
allow bootp;
option option-128 code 128 = string;
option option-129 code 129 = text;
next-server MY_IP; 
filename "/pxelinux.0";
EOF

                    service dhcp restart 
                    "
