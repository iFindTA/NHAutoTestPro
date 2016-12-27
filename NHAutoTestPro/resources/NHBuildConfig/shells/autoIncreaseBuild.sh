
if echo "$HOME"| grep -q "nanhu" 
then
	#statements
	b=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "$INFOPLIST_FILE")
	b=$(($b + 1))
	/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $b" "$INFOPLIST_FILE"
else
	echo "not exists!"
fi
