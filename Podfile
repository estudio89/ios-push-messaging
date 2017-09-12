# Uncomment this line to define a global platform for your project
# platform :ios, '6.0'

target 'ios-push-messaging' do
pod 'SIOSocket', '~> 0.2.0'
pod 'Syncing', :git => 'https://github.com/estudio89/ios-syncing.git', :tag => ‘1.2.4’
end

target 'ios-push-messagingTests' do

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = ‘7.0’
    end
  end
end
