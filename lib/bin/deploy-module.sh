#!/bin/bash -e

if [ "$JBOSS_HOME" == "" ]; then
	echo '$JBOSS_HOME must be set'
	exit 1
fi

mvn install -DskipTests
mkdir -p $JBOSS_HOME/modules/system/layers/base/org/myinterceptor/main/
cp ./target/lib-1.0-SNAPSHOT.jar $JBOSS_HOME/modules/system/layers/base/org/myinterceptor/main/
cp ./resources/module.xml $JBOSS_HOME/modules/system/layers/base/org/myinterceptor/main/
