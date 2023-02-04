#! /bin/bash
#

modes='rndwr seqrd seqrewr'
no=5
file=fileio_test_qemu_op.txt

echo FILEIO TEST FOR QEMU > $file

for mode in $modes;  do
echo $filecommand

for(( i = 1; i <= no; i++ ))
do
	echo Test $i started in mode $mode >> $file
	sysbench --threads=16 fileio --file-total-size=1G --file-test-mode=$mode prepare
	sysbench --threads=16 fileio --file-total-size=1G --file-test-mode=$mode run >> $file
	sysbench --threads=16 fileio --file-total-size=1G --file-test-mode=$mode cleanup
	echo Test $i done >> $file
	echo Clearing Cache >> $file
	sudo sh -c "/usr/bin/echo 3 > /proc/sys/vm/drop_caches"
done
done