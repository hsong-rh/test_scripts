#! /bin/sh

mkdir /tmp/junk

oc rsync s2i-python-container-2-rnvph:/tmp /tmp/junk/


cp /tmp/junk/tmp/upload.json /tmp

jq -rc . /tmp/upload.json | kafka-console-producer --broker-list localhost:9092 --topic platform.upload.catalog



