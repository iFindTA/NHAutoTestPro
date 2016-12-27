BUILD_DIR="${WORKSPACE}/build/"
TARGET="FLKANAN_InHouse"
INFO_PLIST_PATH="$BUILD_DIR/Release-iphoneos/$TARGET.app/Info.plist"
#取版本号${WORKSPACE}/build/
SHORT_VERSION=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${INFO_PLIST_PATH}")
#取build值
BUILD_VERSION=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" "${INFO_PLIST_PATH}")
DATE="$(date +%Y%m%d%H%M)"

#remove old ipas
rm -rf $BUILD_DIR/*.ipa

/usr/bin/xcrun -sdk iphoneos PackageApplication -v $BUILD_DIR/Release-iphoneos/$TARGET.app -o $BUILD_DIR/$TARGET_V${SHORT_VERSION}_B${BUILD_VERSION}_${DATE}.ipa

#compress dsym file, -q disable log
cd $BUILD_DIR
rm -rf *.zip
zip -r -T -y -j -q ${TARGET}_V${SHORT_VERSION}_B${BUILD_VERSION}_${DATE}.zip /Release-iphoneos/$TARGET.app.dSYM


#!bin/bash
#im notice channel
curl -d '{"content":"密信通新版本发布啦！尝鲜请移步：https://fir.im/flkmxt.\n\t --来自神秘的anglar!","enterpriseId":"1"}' http://112.74.77.9:2004/upgrade/8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92