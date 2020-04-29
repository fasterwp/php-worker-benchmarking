#!/bin/bash
CPUSET=${1-0}
WORKERS=${2-1}
REPORT=${3-/dev/null}

docker network inspect php-bench > /dev/null
if [[ $? -eq 1 ]]
then
    docker network create php-bench
fi
docker stop php-bench
echo "Running on cpuset $CPUSET"
echo "Using $WORKERS workers"
sed "s/WORKERS/$WORKERS/" php-fpm-pool.conf > php-fpm-run.conf
grep 'pm.max_children' php-fpm-run.conf

docker run \
    --rm \
    --name=php-bench \
    --network=php-bench \
    -d \
    --cpuset-cpus=$CPUSET \
    -v "`pwd`/php-fpm-run.conf:/etc/php7/php-fpm.d/www.conf" \
    -v "`pwd`/htdocs:/var/www/html" \
    trafex/alpine-nginx-php7

sleep 2

echo "Sample runs";
for i in {1..5}
do
    docker run \
        --rm \
        -ti \
        --cpuset-cpus=3 \
        --network=php-bench \
        byrnedo/alpine-curl "http://php-bench:8080/test.php?print=1"
done
docker run \
    --rm \
    -ti \
    --cpuset-cpus=3 \
    --network=php-bench \
    byrnedo/alpine-curl "http://php-bench:8080/test.php?print=1" > $REPORT

