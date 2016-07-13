#!/bin/bash
cd ${JENKINS_HOME}/jobs/${JOB_NAME}/
cp NHBuildConfig/shells/package.sh package_copy.sh
./package_copy.sh AiCaiBangTest 1 0 'AiCaiBang-InHouse' -  com.erongdu.aicaibang appstore
rm package_copy.sh