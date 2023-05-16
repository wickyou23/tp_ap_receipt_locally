rm -rf "./build";



xcodebuild archive \
-scheme TPAPReceiptLocally \
-configuration Release \
-sdk iphoneos \
-destination 'generic/platform=iOS' \
-archivePath './build/ios-devices/TPAPReceiptLocally.framework-iphoneos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES;

xcodebuild -create-xcframework \
-framework './build/ios-devices/TPAPReceiptLocally.framework-iphoneos.xcarchive/Products/Library/Frameworks/TPAPReceiptLocally.framework' \
-output './build/ios-devices/TPAPReceiptLocally.xcframework';



xcodebuild archive \
-scheme TPAPReceiptLocally-Simulator \
-configuration Release \
-sdk iphonesimulator \
-destination 'generic/platform=iOS' \
-archivePath './build/ios-simulator/TPAPReceiptLocally-Simulator.framework-iphoneos.xcarchive' \
SKIP_INSTALL=NO \
BUILD_LIBRARIES_FOR_DISTRIBUTION=YES;

xcodebuild -create-xcframework \
-framework './build/ios-simulator/TPAPReceiptLocally-Simulator.framework-iphoneos.xcarchive/Products/Library/Frameworks/TPAPReceiptLocally_Simulator.framework' \
-output './build/ios-simulator/TPAPReceiptLocally-Simulator.xcframework';



xcrun xcodebuild -create-xcframework \
-framework './build/ios-devices/TPAPReceiptLocally.xcframework/ios-arm64/TPAPReceiptLocally.framework' \
-framework './build/ios-simulator/TPAPReceiptLocally-Simulator.xcframework/ios-arm64_x86_64-simulator/TPAPReceiptLocally_Simulator.framework' \
-output './build/ios-combine/TPAPReceiptLocally.xcframework'
