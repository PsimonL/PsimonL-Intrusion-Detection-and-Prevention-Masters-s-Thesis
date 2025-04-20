#! /bin/bash

sudo apt-get update
sudo apt-get install snort -y
ls -la  /etc/snort 
vim  /etc/snort/snort.conf

sudo snort -T -c /etc/snort/snort.conf

sudo snort -c /etc/snort/snort.conf -q -r ~/Desktop/datasets/Thursday-WorkingHours.pcap -A full -K ASCII -l ~/Desktop/logging/snort