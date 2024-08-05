#!/bin/bash
# Anti-DPI script to access YouTube.
#
# Requires root privileges.

iptables \
    -I OUTPUT \
    -o enp0s20f0u3c2 \
    -p tcp --dport 443 \
    -m connbytes --connbytes-dir=original --connbytes-mode=packets --connbytes 1:6 \
    -m mark ! --mark 0x40000000/0x40000000 \
    -j NFQUEUE --queue-num 200 --queue-bypass

ip6tables \
    -I OUTPUT \
    -o enp0s20f0u3c2 \
    -p tcp --dport 443 \
    -m connbytes --connbytes-dir=original --connbytes-mode=packets --connbytes 1:6 \
    -m mark ! --mark 0x40000000/0x40000000 \
    -j NFQUEUE --queue-num 200 --queue-bypass

/home/self/src/aur/zapret/nfq/nfqws \
    --qnum=200 \
    --dpi-desync=disorder2 \
    --dpi-desync-split-pos=1 \
    --hostlist=/home/self/src/aur/zapret/youtube-domain.txt \
    &
