#method1----shell build
#!/bin/sh
#echo "hello, world!"
cd ${JENKINS_HOME}/jobs/${JOB_NAME}/
#echo "this is right path: $(pwd)"
cp FLKAutoCIConfigs/shells/package.sh package_copy.sh
#echo "is copy action successfully?"
./package_copy.sh mihua 0 1 ${WORKSPACE}/ - 'mixintong5.0' 'com.hzflk.mixintong-5.0' Release "iPhone Distribution:Flk Information Security Technology Co., Ltd." AnJiaXin
rm package_copy.sh

#method2----xcode plugin
INFO_PLIST_PATH="${WORKSPACE}/build/Release-iphoneos/mihua.app/info.plist"
#取版本号${WORKSPACE}/build/
SHORT_VERSION=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${INFO_PLIST_PATH}")
#取build值
BUILD_VERSION=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" "${INFO_PLIST_PATH}")
DATE="$(date +%Y%m%d%H%M)"

xcrun -sdk iphoneos PackageApplication -v ${WORKSPACE}/build/Release-iphoneos/mihua.app -o ${WORKSPACE}/build/mihua_V${SHORT_VERSION}_B${BUILD_VERSION}_${DATE}.ipa