#!/bin/bash
mkdir -p reports



# "num-cores cpuset"
for row in "1 0" "2 0-1"
do
    set -- $row
    cores=$1
    cpuset=$2
    for worker in {1,2,8,50,100,200}
    do
        pworker=$(printf "%03d" $worker)
        pcores=$(printf "%02d" $cores)
        file=reports/${pcores}core-${pworker}worker.txt
        json=reports/${pcores}core-${pworker}worker.json
        if [[ ! -f $file ]]
        then
            ./run-php.sh $cpuset $worker $file
            ./run-bench.sh 3 $worker $json >> $file
        fi
    done
done
