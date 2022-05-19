platform :ios, '15.4'

target 'AllTrailsAtLunch' do
  use_frameworks!
  pod 'Alamofire', '5.6.1'
  pod 'GoogleMaps', '6.2.1'
end

post_install do |installer|   
      installer.pods_project.build_configurations.each do |config|
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      end
end