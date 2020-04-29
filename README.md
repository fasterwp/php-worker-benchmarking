# PHP Worker Benchmarking

This set of benchmarks tries to produce reproducable reports by using docker cpuset to isolate the
components.  It can be used to investigate the effects of various worker counts have on overall performance.

## Goals for included `run-series.sh` reports
* Minimize effects of request queing in php (k6.io worker per php worker)
* Show how latency is increased by increasing the # of workers for the same cores
* Show how throughput is lowered by increasing the # of workers for the same cores

## Requirements
Only that is required is docker, jq, sed, and bash

`./run-series.sh` requires a 4 core server

## Running
There are 3 scripts
* `./run-php.sh` - run a nginx/php-fpm stack in docker, on a named docker network
* `./run-bench.sh` - run a k6.io benchmark against php
* `./run-series.sh` - run a set of php/bench runs with different #s of cores and workers
* `./compare-reports.sh` - Pull data out of set of json reports for comparision

### `./run-php.sh`
`./run-php.sh cpuset workers logfile`

cpuset is which cpus to run on
* `0` - run on the first cpu
* `0-1` - run on the first 2cpus

use 2 cores and run 20 php workers
`./run-php.sh 0-1 20`

use 2 cores and run 20 php workers, logging sample timing data and php version to a file
`./run-php.sh 0-1 20 report.txt`

### `./run-bench.sh`
Always pick a different core than what php is running on, to reduce noise
`./run-bench.sh cpuset workers`

run 20 workers on core 3
`./run-bench.sh 3 20`

Note that k6.io produces output on stdout and stderr, you can redirect the report which is on stdout
`./run-bech.sh 3 1 > report.txt`


### `./run-series.sh`

No options, will output reports in the `reports` in the current folder

Note that `run-series.sh` won't overwrite existing reports, so clear the directory to rerun
