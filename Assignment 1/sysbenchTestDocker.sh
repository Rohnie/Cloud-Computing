#! /bin/bash
#

primes='20000 50000 90000'
no=5
file=cpu_test_docker_automated_op.txt

echo OS Virtualization CPU Test > $file

for prime in $primes;  do

for(( i = 1; i <= no; i++ ))
do
	echo Test $i started for prime no. $prime >> $file
	sysbench cpu --cpu-max-prime=$prime run >> $file
	echo Test $i done >> $file
done
done
