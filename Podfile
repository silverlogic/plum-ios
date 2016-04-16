source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
inhibit_all_warnings!

link_with 'PlumCash'

pod 'Crashlytics', '~> 3.3'
pod 'DBCamera', '~> 2.3'
pod 'Fabric', '~> 1.5'
pod 'FBSDKCoreKit'
pod 'FBSDKLoginKit'
pod 'FBSDKShareKit'
pod 'GRKAlertBlocks', '~> 1.0'
pod 'MBProgressHUD', '~> 0.8'
pod 'RestKit', '~> 0.24'
pod 'RKCLLocationValueTransformer', '~> 1.1'
pod 'YLMoment', '~> 0.5'

# avoids issues with objc_msgSend
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_STRICT_OBJC_MSGSEND'] = "NO"
        end
    end
end

target :'PlumCashTests', :exclusive => true do
	platform :ios, '7.0'
    pod 'KIF-Kiwi'
end
