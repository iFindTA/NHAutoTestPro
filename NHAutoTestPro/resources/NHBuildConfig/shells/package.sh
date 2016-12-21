#!/bin/sh

declare -x SCHEME=$1
declare -x IS_WORKSPACE=$2
declare -x IS_DISTRIBUTE=$3
declare -x CHANNEL='CHANNEL'
declare -x DESTPATH=$4
declare -x DEV_PROFILE_NAME=$5
declare -x DIS_PROFILE_NAME=$6
declare -x BUNDLE_IDENTITY=$7
declare -x CONFIGURATION=$8
declare -x CODE_SIGN_IDENTITY=$9

#channels=('appstore' 'c360' 'wandoujia' 'c91' 'xiaomi')
channels=${@:10}

if [ ! -d "$DESTPATH" ]; then
echo 'failed on previous build: no such directory:$(DESTPATH)!'
exit
fi
cd $DESTPATH

if [ $IS_WORKSPACE = 1 ]
then
#judge the profile type
set Profile=$DEV_PROFILE_NAME
if [ $IS_DISTRIBUTE = 1 ]
then 
Profile=$DIS_PROFILE_NAME 
else 
Profile=$DEV_PROFILE_NAME 
fi
#build project named SCHEME.xcworkspace
rm -rf build/
xcodebuild clean
xcodebuild -workspace $SCHEME.xcworkspace -scheme $SCHEME -configuration $CONFIGURATION -sdk iphoneos CODE_SIGN_IDENTITY=$"CODE_SIGN_IDENTITY" -archivePath build/$SCHEME.xcarchive archive PRODUCT_BUNDLE_IDENTIFIER=$BUNDLE_IDENTITY
#xcodebuild -exportArchive -exportFormat ipa -archivePath build/$SCHEME.xcarchive  -exportPath build/$SCHEME.ipa -exportProvisioningProfile $Profile

#generate dsym file
rm DSYM
mkdir DSYM
zip -r DSYM/$SCHEME.zip $SCHEME.xcarchive/DSYMs/$SCHEME.app.dsym

cd build
rm ipas
mkdir ipas

project_infoplist_path="$SCHEME.xcarchive/Products/Applications/$SCHEME.app/info.plist"
#取版本号
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${project_infoplist_path}")
#取build值
bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" "${project_infoplist_path}")
DATE="$(date +%Y%m%d)"
#export ipas for difference channels
if [ ${#channels[@]} > 0 ]; then
	for i in ${channels[@]}
	do
		#/usr/libexec/PlistBuddy -c "set :CFBundleIdentifier ${BUNDLE_IDENTITY}" ${project_infoplist_path}
		/usr/libexec/PlistBuddy -c "set :$CHANNEL ${i}" ${project_infoplist_path}
		IPANAME="${SCHEME}_V${bundleShortVersion}_B${bundleVersion}_${DATE}_${i}.ipa"
		echo $IPANAME
    	rm -Rf $IPANAME
    	xcodebuild -exportArchive —exportFormat ipa -archivePath $SCHEME.xcarchive -exportPath ipas/$IPANAME -exportProvisioningProfile $Profile
done
fi

unset Profile
else
#judge the profile type
set Profile=$DEV_PROFILE_NAME
if [ $IS_DISTRIBUTE = 1 ]
then 
Profile=$DIS_PROFILE_NAME 
else 
Profile=$DEV_PROFILE_NAME 
fi
#build project named SCHEME.xcodeproj
rm -rf build/
xcodebuild clean
xcodebuild -scheme $SCHEME -configuration $CONFIGURATION -sdk iphoneos CODE_SIGN_IDENTITY="$CODE_SIGN_IDENTITY" -archivePath build/$SCHEME.xcarchive archive PRODUCT_BUNDLE_IDENTIFIER=$BUNDLE_IDENTITY
#next step create *.ipa file
#xcodebuild -exportArchive -exportFormat ipa -archivePath build/$SCHEME.xcarchive -exportPath build/$SCHEME.ipa -exportProvisioningProfile $Profile

#generate dsym file
rm DSYM
mkdir DSYM
zip -r DSYM/$SCHEME.zip $SCHEME.xcarchive/DSYMs/$SCHEME.app.dsym

cd build
rm ipas
mkdir ipas
project_infoplist_path="$SCHEME.xcarchive/Products/Applications/$SCHEME.app/info.plist"
#取版本号
bundleShortVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleShortVersionString" "${project_infoplist_path}")
#取build值
bundleVersion=$(/usr/libexec/PlistBuddy -c "print CFBundleVersion" "${project_infoplist_path}")
DATE="$(date +%Y%m%d)"
#export ipas for difference channels
if [ ${#channels[@]} > 0 ]; then
	for i in ${channels[@]}
	do
		/usr/libexec/PlistBuddy -c "set :$CHANNEL ${i}" ${project_infoplist_path}
		IPANAME="${SCHEME}_V${bundleShortVersion}_B${bundleVersion}_${DATE}_${i}.ipa"
		echo $IPANAME
    	rm -Rf $IPANAME
    	xcodebuild -exportArchive —exportFormat ipa -archivePath $SCHEME.xcarchive -exportPath ipas/$IPANAME -exportProvisioningProfile $Profile
done
fi


unset Profile
fi 