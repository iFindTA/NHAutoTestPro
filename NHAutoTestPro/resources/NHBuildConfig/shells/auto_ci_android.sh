#!/bin/bash
cd ${WORKSPACE}/Aicaibang/app
rm -rf build/
rm -f *.apk
#gradle build
gradle assembleRelease
cd build/outputs/apk
#mv app-release.apk ../../../
cp app-release.apk ../../../app_release.apk
rm -f *.apk
#mv `ls | grep 'app-release-\d\{6\}\.apk'` ../../../ 
