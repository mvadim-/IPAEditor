#!/bin/sh

IPA="LibPowwowDemo.ipa"
PROVISION="Softjourn_Distribution_Profile.mobileprovision"
CERTIFICATE="004D3AE917F2A68CB7A7914BE61AC1BF787146E7" # must be in keychain
PLISTBUDDY=/usr/libexec/PlistBuddy

id="OpenAccounts"
appurl="progress-openaccounts-iphone"
appname="Open Accounts"

# unzip the ipa
unzip -q "$IPA"

# remove the signature
rm -rf Payload/*.app/_CodeSignature Payload/*.app/CodeResources

# replace the provision
cp "$PROVISION" Payload/*.app/embedded.mobileprovision

# make a temporary copy
cp -R Payload $id

# replace the icon
cp -R $appurl/AppIcon*.png $id/*.app/
    
# change the application URL
$PLISTBUDDY -c "set :AppURL $appurl" $id/*.app/Info.plist

# change the bundle identifier
$PLISTBUDDY -c "set :CFBundleIdentifier 111$id.LibPowwowDemo" $id/*.app/Info.plist

# change the name
$PLISTBUDDY -c "set :CFBundleDisplayName $appname" $id/*.app/Info.plist

# sign with the new certificate
/usr/bin/codesign -f -s "$CERTIFICATE" --resource-rules $id/*.app/ResourceRules.plist $id/*.app

# zip it back up
mkdir tmp
mv $id tmp/Payload
cd tmp
zip -qr ../$id.ipa Payload
mv Payload ../$id
cd .. 
rmdir tmp

# remove temporary directory
rm -rf $id
rm -rf Payload 
#done
