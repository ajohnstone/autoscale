#!/usr/bin/env bash

export AWS_ACCESS_KEY=${AWS_ACCESS_KEY:-'AWS_ACCESS_KEY_HERE'}
export AWS_SECRET_KEY=${AWS_SECRET_KEY:-'AWS_SECRET_KEY_HERE'}
export JAVA_HOME=${JAVA_HOME:-$(readlink -f /usr/bin/java | sed "s:bin/java::")}
export EC2_HOME=${EC2_HOME:-'/opt/amazon/src/ec2-api-tools/'};


for i in $($EC2_HOME/bin/ec2-describe-tags \
    --filter "resource-type=instance" \
    --filter "resource-id=`facter ec2_instance_id`" | grep -v cloudformation | cut -f 4-
)
do
    key=$(echo $i | cut -f1);
    value=$(echo $i | cut -f2-);

    if [ ! -d "/opt/facts/tags/" ]; then
        mkdir -p /opt/facts/tags;
    fi

    if [ -n $value ]; then
        echo $value > /opt/facts/tags/$key;
        logger "set fact $key to $value";
    elif
        touch /opt/facts/tags/$key;
    fi
done
