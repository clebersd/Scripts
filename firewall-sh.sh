#!/bin/bash

# Em construcao

PORTA_WAN="eth0"
PORTA_LAN="eth1"

ADM="192.168.1.109"

REDE_LOCAL="192.168.10.0/24"
REDE_WAN="192.168.1.0/24"

PA="1024:65535"

# Limpar tabelas

iptables -F
iptables -t nat -F
iptables -t mangle -F

# Mudar politica Padr�o

iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Habilitar o Loopback

iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# Logar as atividades do firewall

iptables -A INPUT -s 0/0 -j LOG --log-prefix "INPUT"
iptables -A OUTPUT -d 0/0 -j LOG --log-prefix "OUTPUT"
iptables -A FORWARD -s 0/0 -j LOG --log-prefix "FORWARD"
iptables -t nat -A POSTROUTING -j LOG --log-prefix "NAT"
iptables -A INPUT -i $PORTA_WAN -m state --state NEW -j LOG --log-prefix "CONXECOES EXTERNAS"
iptables -A INPUT -i $PORTA_WAN -m state --state INVALID -j LOG --log-prefix "INVALID-EXTERNO"


# Habilitar o Roteamento, Block tcp flood e icmp broadcast

echo "1" > /proc/sys/net/ipv4/ip_forward
echo "1" >/proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
echo "1" >/proc/sys/net/ipv4/tcp_syncookies

# Acesso SSH ao Firewall

iptables -A INPUT -p tcp --dport 22 -i $PORTA_WAN -s $ADM -j ACCEPT
iptables -A OUTPUT -p tcp  --sport 22 -o $PORTA_WAN -d $ADM -j ACCEPT


# Aplica��o de NAT

iptables -t nat -A POSTROUTING  -o $PORTA_WAN -j MASQUERADE

# Regras

iptables -A INPUT -p tcp --tcp-flags fin urg -i $PORTA_WAN -s 0/0 -d $REDE_LOCAL -j DROP
iptables -A INPUT -p tcp --tcp-flags syn ack -i $PORTA_WAN  -m  limit --limit 1/s -j ACCEPT
iptables -A FORWARD -i $PORTA_WAN -m state --state INVALID -j DROP
iptables -A OUTPUT -p udp --sport $PA -s $REDE_LOCAL --dport 53 -d 8.8.8.8,8.8.4.4 -j ACCEPT
iptables -A INPUT -p udp --sport 53 -s 8.8.8.8,8.8.4.4 --dport $PA -d $REDE_LOCAL -j ACCEPT

iptables -A OUTPUT -p tcp --sport $PA -s $REDE_LOCAL --dport 80 -d 0/0 -j ACCEPT
iptables -A INPUT  -p tcp --sport 80 -s 0/0 --dport $PA -d $REDE_LOCAL -j ACCEPT

# FORWARD
iptables -A FORWARD -p tcp --tcp-flags fin urg -s 0/0 -d $REDE_LOCAL -j DROP
iptables -A FORWARD -p tcp --tcp-flags syn ack -i $PORTA_WAN  -d $REDE_LOCAL -m  limit --limit 1/s -j ACCEPT
iptables -A FORWARD -p udp --sport $PA -s $REDE_LOCAL --dport 53 -d 8.8.8.8,8.8.4.4 -j ACCEPT
iptables -A FORWARD -p udp --sport 53 -s 8.8.8.8,8.8.4.4 --dport $PA -d $REDE_LOCAL -j ACCEPT

iptables -A FORWARD -p tcp --sport $PA -s $REDE_LOCAL --dport 80 -d 0/0 -j ACCEPT
iptables -A FORWARD -p tcp --sport 80 -s 0/0 --dport $PA -d $REDE_LOCAL -j ACCEPT

