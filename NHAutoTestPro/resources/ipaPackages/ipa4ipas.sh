
declare -x IS_WORKSPACE=1
declare -x IS_DISTRIBUTE=0
declare -x SCHEME='gscj'
declare -x DEV_PROFILE_NAME='GSDCaiJingDevelopmentProfile'
declare -x DEV_UUID='4bd87707-0e58-4db2-8ef1-385866b0ebee'
declare -x DEV_IDENTITY='iPhone Developer: Liu Yaoyao (2VV6L667F3)'
declare -x DIS_PROFILE_NAME='GSDCaiJingDistributionProfile'
declare -x DIS_UUID='1ed4f3b4-9849-40b6-b98a-b93c8964e224'
declare -x DIS_IDENTITY='iPhone Distribution: Hangzhou LaXiong Technology Co., Ltd. (4543P6M55S)'
declare -x DESTPATH='/Users/nanhujiaju/Desktop/gscj/build'
declare -x PROFILE_PATH='/Users/nanhujiaju/Library/MobileDevice/Provisioning\ Profiles'

if [ ! -d "$DESTPATH" ]; then
echo 'no such directory'
exit
fi
cd $DESTPATH

set Profile=$DEV_PROFILE_NAME
if [ $IS_DISTRIBUTE = 1 ]
then 
Profile=$DIS_PROFILE_NAME 
else 
Profile=$DEV_PROFILE_NAME 
fi
#echo $Profile
#path=$(pwd)

channels=('c360' 'wandoujia' 'c91' 'xiaomi')
#!/bin/sh
 
sourceipaname="$SCHEME.ipa"
appname="$SCHEME.app"  #加压后Pauload目录项.app文件名需要根据自己的项目修改
distDir="$DESTPATH/resign"   #打包后文件存储目录
rm -rdf $distDir
mkdir  $distDir
rm -rdf Payload

unzip $sourceipaname     #解压母包文件
 
kChannelNumber=("c360" "c91" "huawei")
for ((i=0;i<${#kChannelNumber};i++))
do
	#cd Payload
	#cd $appname
	#modify channel
    ipafilename=${kChannelNumber[$i]}
    targetName="gscj"
    /usr/libexec/PlistBuddy -c "set :CHANNEL ${kChannelNumber[$i]}" Payload/$appname/Info.plist
 	
    #remove old sign
 	rm -rf Payload/$appname/_CodeSignature
 	#copy new provion profile
 	cp $PROFILE_PATH/$DEV_UUID.mobileprovision Payload/$appname/embedded.mobileprovision
 	#codesign with new certificate and provision
 	(/usr/bin/codesign -f -s $DEV_IDENTITY --resource-rules Payload/$appname/ResourceRules.plist Payload/$appname) || {
 		##if code sign error will to here
 		echo 'failed to codesign for new ipa file'
 		exit
 	}

    #cd ../..
    zip -r ${targetName}_${ipafilename}.ipa Payload   #打成其他渠道的包
    mv ${targetName}_${ipafilename}.ipa $distDir
done
rm -rdf Payload