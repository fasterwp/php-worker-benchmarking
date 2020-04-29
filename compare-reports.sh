#!/bin/bash

REPORTDIR=${1-reports}

printf "%20s %20s %20s\n" Run "Http Reqs" "Avg Time"
for i in $(ls $REPORTDIR/*.json)
do
    reqs=$(jq .metrics.http_reqs.rate < $i)
    time=$(jq .metrics.http_req_waiting.avg < $i)
    f=$(basename $i)
    f="${f%.}"
    printf "%20s %20s %20s\n" $f $reqs $time
done
