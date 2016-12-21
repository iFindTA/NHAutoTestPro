#!/bin/sh
#echo "hello, world!"
cd ${JENKINS_HOME}/jobs/${JOB_NAME}/
#echo "this is right path: $(pwd)"
cp FLKAutoCIConfigs/shells/package.sh package_copy.sh
#echo "is copy action successfully?"
./package_copy.sh mihua 0 1 ${WORKSPACE}/ - 'mixintong5.0' 'com.hzflk.mixintong-5.0' Release "iPhone Distribution:Flk Information Security Technology Co., Ltd." AnJiaXin
rm package_copy.sh