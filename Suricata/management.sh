#! /bin/bash

INTERFACE_NAME = ens19

# ################## I ################## 
# Suricata can be managed with demon managers
sudo systemctl enable suricata
sudo systemctl enable suricata.service
sudo systemctl status suricata
sudo systemctl start suricata
sudo systemctl stop suricata
sudo systemctl restart suricata

# Suricata configs
ls -la /etc/suricata

# ################## II ##################
# Fetch ET Open rules at /var/lib/suricata/rules/suricata.rules
sudo suricata-update
sudo suricata -T
sudo -i
less /var/lib/suricata/rules/suricata.rules
# To list sources
sudo suricata-update list-sources
# To create own rules
sudo nano /etc/suricata/rules/custom.rules
# And add section in suricata.yaml
# rule-files:
#   - custom.rules

# ################## III ##################
# Check Suricata logs
sudo tail /var/log/suricata/suricata.log
# To check statistics
sudo tail -f /var/log/suricata/stats.log

# ################## IV ##################
# To edit config file
sudo vi /etc/suricata/suricata.yaml
# After any changes
sudo systemctl restart suricata
# Or
sudo service suricata restart

# ################## V ##################
# Test Suricata configuration
sudo suricata -T -c /etc/suricata/suricata.yaml -v

# ################## VI ##################
# To run Suricata with tshark pcap file
cd /var/log/suricata/tshark
# "Suricata will, by default, place the interface it is enabled on in promiscuous mode."
# https://forum.netgate.com/topic/173514/suricata-interfaces/2
sudo ip link set $INTERFACE_NAME promisc on
# Live monitoring
sudo suricata -c /etc/suricata/suricata.yaml -i $INTERFACE_NAME
# PCAP offline if you've got previoslu captured traffic
# # Also you can catch traffic by yourself to later analize it with Suricata
sudo tshark -i $INTERFACE_NAME -w data.pcap
sudo suricata -c /etc/suricata/suricata.yaml -r data.pcap
# Or simply in the background as service
sudo systemctl start suricata
# Run initial test
sudo tail -f /var/log/suricata/fast.log
curl http://testmynids.org/uid/index.html

# ################## VII ##################
# Check alerts in JSOn format
sudo cat /var/log/suricata/tshark/eve.json | jq .



sudo suricata -r datasets/Thursday-WorkingHours.pcap -l logging/suricata/ -s /var/lib/suricata/ -c /etc/suricata/suricata.yaml

curl -X POST "http://localhost:3000/rest/user/login" \
     -H "Content-Type: application/json" \
     -d '{"email": "'\'' OR true--", "password": "test"}'