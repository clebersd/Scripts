tcpdump -i  wlan0 -n   | grep -i IP | cut -f 3-5 -d  | sed -n  's/\://pg'
