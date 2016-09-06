#!/bin/sh

# Enable forwarding
sudo sysctl -w net.ipv4.ip_forward=1


sudo ip netns add pipe
sudo ip link set enp0s9 netns pipe
sudo ip link set enp0s8 netns pipe
sudo ip netns exec pipe ip addr add 172.24.4.5/24 dev enp0s8
sudo ip netns exec pipe ip addr add 172.24.6.5/24 dev enp0s9
sudo ip netns exec pipe ip link set enp0s8 up
sudo ip netns exec pipe ip link set enp0s9 up

#sudo ip netns exec pipe iptables -P FORWARD DROP
#sudo ip netns exec pipe iptables -A FORWARD -i enp0s8 -o enp0s9 -j ACCEPT
#sudo ip netns exec pipe iptables -A FORWARD -o enp0s8 -i enp0s9 -j ACCEPT
sudo ip netns exec pipe iptables -F FORWARD
sudo ip netns exec pipe iptables -P FORWARD DROP
sudo ip netns exec pipe iptables -A FORWARD -s 0.0.0.0/0.0.0.0 -d 0.0.0.0/0.0.0.0 -m state --state INVALID -j DROP
sudo ip netns exec pipe iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow traffic from comcloud to pubcloud
sudo ip netns exec pipe iptables -A FORWARD -o enp0s8 -i enp0s9 -j ACCEPT

#sudo ip netns exec pipe iptables -A INPUT -p tcp -s 0/0 -d 0/0 --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
#sudo ip netns exec pipe iptables -A INPUT -p tcp -s 0/0 -d 0/0 --sport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
