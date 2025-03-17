#! /bin/bash

sudo apt-get update
sudo apt-get install snort -y
ls -la  /etc/snort 
vim  /etc/snort/snort.conf

sudo snort -T -c /etc/snort/snort.conf

snort -c /etc/snort/snort.conf -q -r file.pcap -A console
