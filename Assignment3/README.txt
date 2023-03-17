Task 1
1. What is the output of “nodes” and “net”

The output of "nodes" is: 
available nodes are: 
h1 h2 h3 h4 h5 h6 h7 h8 s1 s2 s3 s4 s5 s6 s7

The output of "net" is:
h1 h1-eth0:s3-eth1
h2 h2-eth0:s3-eth2
h3 h3-eth0:s4-eth1
h4 h4-eth0:s4-eth2
h5 h5-eth0:s6-eth1
h6 h6-eth0:s6-eth2
h7 h7-eth0:s7-eth1
h8 h8-eth0:s7-eth2
s1 lo:  s1-eth1:s2-eth3 s1-eth2:s5-eth3
s2 lo:  s2-eth1:s3-eth3 s2-eth2:s4-eth3 s2-eth3:s1-eth1
s3 lo:  s3-eth1:h1-eth0 s3-eth2:h2-eth0 s3-eth3:s2-eth1
s4 lo:  s4-eth1:h3-eth0 s4-eth2:h4-eth0 s4-eth3:s2-eth2
s5 lo:  s5-eth1:s6-eth3 s5-eth2:s7-eth3 s5-eth3:s1-eth2
s6 lo:  s6-eth1:h5-eth0 s6-eth2:h6-eth0 s6-eth3:s5-eth1
s7 lo:  s7-eth1:h7-eth0 s7-eth2:h8-eth0 s7-eth3:s5-eth2

2. What is the output of “h7 ifconfig”

h7-eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.0.7  netmask 255.0.0.0  broadcast 10.255.255.255
        inet6 fe80::4883:e4ff:fe9f:7d0f  prefixlen 64  scopeid 0x20<link>
        ether 4a:83:e3:9f:7d:1f  txqueuelen 1000  (Ethernet)
        RX packets 62  bytes 4688 (4.6 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 11  bytes 886 (886.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

Task 2
1.Draw the function call graph of this controller. For example, once a packet comes to the controller, which function is the first to be called, which one is the second, and so forth?

Initially the controller will be started with the launch function
The function call graph will be as follows when the packet comes to the controller
Packet in -> _handle_PacketIn() -> act_like_hub() -> resend_packet() -> send(msg)

2.Have h1 ping h2, and h1 ping h8 for 100 times (e.g., h1 ping -c100 p2).

h1 ping -c100 h2
--- 10.0.0.2 ping statistics ---
100 packets transmitted, 100 received, 0% packet loss, time 99211ms
rtt min/avg/max/mdev = 3.011/7.452/22.011/3.499 ms

h1 ping -c100 h8
--- 10.0.0.8 ping statistics ---
100 packets transmitted, 100 received, 0% packet loss, time 99184ms
rtt min/avg/max/mdev = 12.784/27.863/61.142/11.153 ms

a.How long does it take (on average) to ping for each case?

h1 ping h2 -> 7.452 ms
h1 ping h8 -> 27.863 ms

b.What is the minimum and maximum ping you have observed?

h1 ping h2 -> min: 3.011 ms, max: 22.011 ms
h1 ping h8 -> min: 12.784 ms, max:61.142 ms

c.What is the difference, and why?

h1 ping h2 is faster than h1 ping h8. This is mainly because there is only one switch s3 in between them. Whereas in h1 ping h8, there are multiple switches in between (s3, s2, s1, s5, s7). Therefore the time taken is less for h1 ping h2

3.Run “iperf h1 h2” and “iperf h1 h8”

mininet> iperf h1 h2
*** Iperf: testing TCP bandwidth between h1 and h2
*** Results: ['3.25 Mbits/sec', '4.02 Mbits/sec']
mininet> iperf h1 h8
*** Iperf: testing TCP bandwidth between h1 and h8
*** Results: ['2.06 Mbits/sec', '2.55 Mbits/sec'

a.What is “iperf” used for?

It is used for testing the tcp bandwidth for performance evaluation. It measures the throughput between any two nodes in a network

b.What is the throughput for each case?

h1-> h2 : 4.02 Mbits/sec
h1-> h8: 2.55 Mbits/sec

c.What is the difference, and explain the reasons for the difference.

The throughput for h1 to h2 is faster than h1 to h8. This is mainly because there is only one switch s3 in between them. Whereas in h1 ping h8, there are multiple switches in between (s3, s2, s1, s5, s7). Because of this there will be multiple hops which increases the time. Also since this is a tcp connection, congestion is bound to happen as for each request there is an acknowledgement which adds on the traffic during multiple hops.

4.Which of the switches observe traffic? Please describe your way for observing such traffic on switches (e.g., adding some functions in the “of_tutorial” controller).

Since of_tutorial.py has act_like_behaviour, all the switches observe the traffic. That is, all the packets are forwarded to all the switches. We can observe this traffic by adding the below line in handle_PackeIn function.

sw=”s” + str.(self.connection.dpid)
log.debug(“Inside switch   ”+sw)

Task 3

1.Describe how the above code works, such as how the "MAC to Port" map is established. You could use a ‘ping’ example to describe the establishment process (e.g., h1 ping h2).

The of_tutorial will act as a switch which automatically learns the mac address to port
routing of every packet that it receives. It makes use of the mac_to_port data structure to store the mapping as it learns. Initially it is empty. The establishment process for first h1 ping h2 will be as follows:

h1 ping h2 will hop through switch s3.
The mac_to_port is queried to check if a mapping exists for h1. Since it is the first time it looks at h1 a new mapping will be added.
Similarly, a mac_to_port mapping of the destination’s(h2) mac address to port mapping is checked in order to send the packets to the destination port.
Since the information is not there, the switch will send the packets to all the ports except the input port(flooding).
Only the port that belongs to h2 will send an acknowledgement. Now the switch will be able to add the mac to port mapping for h2
The acknowledgement will now be directly sent to the port of h1, since a mapping for it already exists.

The establishment process for second h1 ping h2 will be as follows:

h1 ping h2 will hop through switch s3.
The mac_to_port is queried to check if a mapping exists for h2. Since it is already there the packet will be sent directly to the port of h2 without flooding operation.


2.(Comment out all prints before doing this experiment)
Have h1 ping h2, and h1 ping h8 for 100 times (e.g., h1 ping -c100 p2).

h1 ping -c100 h2
--- 10.0.0.2 ping statistics ---
100 packets transmitted, 100 received, 0% packet loss, time 99209ms
rtt min/avg/max/mdev = 2.413/6.693/12.311/2.349 ms

h1 ping -c100 h8
--- 10.0.0.8 ping statistics ---
100 packets transmitted, 100 received, 0% packet loss, time 99174ms
rtt min/avg/max/mdev = 11.147/27.389/54.667/9.060 ms

a.How long did it take (on average) to ping for each case?

h1 ping h2 -> 6.693 ms
h1 ping h8 -> 27.389 ms

b.What is the minimum and maximum ping you have observed?

h1 ping h2 -> min: 2.413 ms, max: 12.311 ms
h1 ping h8 -> min: 11.147 ms, max: 54.667 ms

c.Any difference from Task 2 and why do you think there is a change if there is?

Task 3 is faster than Task 2 in terms min, max and avg time taken . This is mainly because of the hub like behavior in task 2, where every packet is broadcasted to every other port thereby increasing congestion which in turn increases the time taken. On the other hand the switch-like behavior in task 3 enables the switch to learn and store the mapping in which case flooding will be avoided and packets will be delivered faster.

3.Run “iperf h1 h2” and “iperf h1 h8”.

mininet> iperf h1 h2
*** Iperf: testing TCP bandwidth between h1 and h2
*** Results: ['12.5 Mbits/sec', '14.5 Mbits/sec']
mininet> iperf h1 h8
*** Iperf: testing TCP bandwidth between h1 and h8
*** Results: ['2.39 Mbits/sec', '2.97 Mbits/sec'

a.What is the throughput for each case?

h1-> h2 : 14.5 Mbits/sec
h1-> h8: 2.97 Mbits/sec

b.What is the difference from Task 2 and why do you think there is a change if there is?

Task 3 has higher throughput than Task 2 . This is mainly because of the hub-like behavior in task 2, where most of the bandwidth is wasted in flooding every other port for each packet that comes in. On the other hand the switch-like behavior in task 3 enables the switch to use the bandwidth optimally without flooding by having a map table. This enables the switch to have higher throughput and avoid any congestion due to flooding.

