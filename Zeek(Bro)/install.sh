#! /bin/bash

docker pull zeek/zeek:latest

# OR in my case for ubuntu 22.04

echo 'deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_22.04/ /' | sudo tee /etc/apt/sources.list.d/security:zeek.list
curl -fsSL https://download.opensuse.org/repositories/security:zeek/xUbuntu_22.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/security_zeek.gpg > /dev/null
sudo apt update
sudo apt install zeek-6.0
sudo apt install zeek-aux

ls /opt/zeek

mkdir ~/Desktop/zeek/analysis1
cd  ~/Desktop/zeek/analysis1
sudo /opt/zeek/bin/zeek -r some_pcap_file.pcap

zeek-cut conn.log | zeek-cur uid id.orig_h id.resp_h
greep "$SOME_UID" *.log


# Edit /opt/zeek/etc/node.cfg
# Choose proper interface ex:
# # [zeek]
# # type=standalone
# # host=localhost
# # interface=ens19

# Zeek policies can be found here:
ls /opt/zeek/share/zeek/policy/

sudo visudo
# Then add "/opt/zeek/bin" at the end of secure_path variable
sudo zeekctl deploy
sudo zeekctl status
sudo zeekctl stop
# Unfortunatelly Zeek cannot be launched as OS service through "systemctl"!