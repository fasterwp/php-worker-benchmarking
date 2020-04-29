#!/bin/bash
CPUSET=${1-3}
VUS=${2-1}
FILE=${3-"test.php"}

if [[ ! -z $3 ]]
then
    OUTPATH=$(realpath $3)
    mkdir -p /tmp/k6
    chmod 777 /tmp/k6
    EXPORT="-v /tmp/k6:/tmp/k6 -e K6_SUMMARY_EXPORT=/tmp/k6/report.json"
fi


echo "Running on cpuset $CPUSET"
sed "s/VUS/$VUS/" k6.js | sed "s/FILE/$FILE/" - > k6-run.js
grep 'vus' k6-run.js
docker run \
    --rm \
    --network=php-bench \
    --cpuset-cpus=$CPUSET \
    $EXPORT \
    -i \
    loadimpact/k6:0.26.2 run - < k6-run.js

if [[ -f /tmp/k6/report.json ]]
then
    mv /tmp/k6/report.json $OUTPATH
fi
