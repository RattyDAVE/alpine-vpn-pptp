FROM alpine:edge

RUN apk --update --no-cache add pptpd ppp iptables && \
    rm -rf /var/cache/apk/* && \
\
echo "#debug" > /etc/pptpd.conf &&\
echo "#stimeout 10" >> /etc/pptpd.conf &&\
echo "logwtmp" >> /etc/pptpd.conf &&\
echo "#bcrelay eth1" >> /etc/pptpd.conf &&\
echo "#delegate" >> /etc/pptpd.conf &&\
echo "#connections 100" >> /etc/pptpd.conf &&\
echo "localip 10.99.99.1" >> /etc/pptpd.conf &&\
echo "remoteip 10.99.99.100-200" >> /etc/pptpd.conf &&\
echo "name pptpd" >> /etc/pptpd.conf &&\
echo "refuse-pap" >> /etc/pptpd.conf &&\
echo "refuse-chap" >> /etc/pptpd.conf &&\
echo "refuse-mschap" >> /etc/pptpd.conf &&\
echo "require-mschap-v2" >> /etc/pptpd.conf &&\
echo "require-mppe-128" >> /etc/pptpd.conf &&\
echo "# Network and Routing" >> /etc/pptpd.conf &&\
echo "ms-dns 8.8.8.8" >> /etc/pptpd.conf &&\
echo "ms-dns 8.8.4.4" >> /etc/pptpd.conf &&\
echo "proxyarp" >> /etc/pptpd.conf &&\
echo "nodefaultroute" >> /etc/pptpd.conf &&\
echo "lock" >> /etc/pptpd.conf &&\
echo "nobsdcomp" >> /etc/pptpd.conf &&\
echo "novj" >> /etc/pptpd.conf &&\
echo "novjccomp" >> /etc/pptpd.conf &&\
echo "nologfd" >> /etc/pptpd.conf &&\
\
echo "#!/bin/sh" > startup.sh && \
echo "set -e" >> startup.sh && \
echo "sysctl -w net.ipv4.ip_forward=1" >> startup.sh && \
echo "iptables -t nat -A POSTROUTING -s 10.99.99.0/24 ! -d 10.99.99.0/24 -j MASQUERADE" >> startup.sh && \
echo "iptables -A FORWARD -s 10.99.99.0/24 -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j TCPMSS --set-mss 1356" >> startup.sh && \
echo "iptables -A INPUT -i ppp0 -j ACCEPT" >> startup.sh && \
echo "iptables -A OUTPUT -o ppp0 -j ACCEPT" >> startup.sh && \
echo "iptables -A FORWARD -i ppp0 -j ACCEPT" >> startup.sh && \
echo "iptables -A FORWARD -o ppp0 -j ACCEPT" >> startup.sh && \
echo "pptpd --fg" >> startup.sh && \
\
chmod 755 startup.sh

EXPOSE 1723
CMD ["/startup.sh"]
    
