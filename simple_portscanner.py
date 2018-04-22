#!/usr/bin/env python

#Homework 8 ENPM 685
# Port Scanner -- takes 3 arguments

import sys
import socket

if len(sys.argv) <= 3:
    print("The script needs some arguments. Try with the following format: ")
    print("python python portScanner.py <IP> <start_port> <end_port>")
    exit(1)

host = socket.gethostbyname(sys.argv[1])
start_port = sys.argv[2]
end_port = sys.argv[3]

print("\n")
print("Checking if open ports on the range of " + start_port + " to " + end_port)
print("\n")

try:
    for port in range(int(start_port), int(end_port) +1):
        socket.setdefaulttimeout(0.1)
        s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        result = s.connect_ex((host, port))
        if result == 0:
            print("--> Port " + str(port) + " is open!")
finally:
    s.close()
print("\n")
