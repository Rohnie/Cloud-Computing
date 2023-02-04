#! /bin/bash
#

modes='rndwr seqrd seqrewr'
no=5
file=fileio_test_docker_op.txt

echo FILEIO TEST FOR DOCKER > $file

for mode in $modes;  do
echo $filecommand

for(( i = 1; i <= no; i++ ))
do
	echo Test $i started in mode $mode >> $file
	docker run -u 0 myubuntu sysbench --threads=16 fileio --file-total-size=1G --file-test-mode=$mode prepare
	docker run -u 0 myubuntu sysbench --threads=16 fileio --file-total-size=1G --file-test-mode=$mode run >> $file
	docker run -u 0 myubuntu sysbench --threads=16 fileio --file-total-size=1G --file-test-mode=$mode cleanup
	echo Test $i done >> $file
	echo Clearing Cache >> $file
sync && sudo purge
done
done
