#!/bin/bash

REPORTDIR=${1-reports}

for i in $(ls $REPORTDIR)
do
    grep 
    echo $i;
done
