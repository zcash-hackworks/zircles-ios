platform :ios, '13.1'
use_frameworks!

inhibit_all_warnings!
target 'Zircles' do 
 pod 'ZcashLightClientKit'
 pod 'KeychainSwift', '~> 19.0.0'
 pod 'MnemonicSwift'
 pod 'lottie-ios'
 target 'ZirclesTests' do 
  inherit! :search_paths
 end
 
 target 'ZirclesUITests' do 
   inherit! :complete
 end
end 

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if target.name == 'ZcashLightClientKit'
         config.build_settings['ZCASH_NETWORK_ENVIRONMENT'] = ENV["ZCASH_NETWORK_ENVIRONMENT"]
      end
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end