source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '12.0'

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			config.build_settings['CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF'] = 'NO'
			if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 11.0
				config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
			end
		end
	end
end

target 'WuMai' do
	pod 'AMap3DMap-NO-IDFA', '~>7.1.0'
	# pod 'AMapLocation-NO-IDFA', '~> 2.6.3'			#定位SDK
	pod 'AMapSearch-NO-IDFA', '~>7.1.0'

	pod 'AFNetworking', '~> 3.2.1'
	pod 'JSONModel', '~> 1.8.0' 			#2018/03/04
end
