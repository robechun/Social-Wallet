# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'Social-Wallet' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Social-Wallet
  pod 'LGButton'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'SkyFloatingLabelTextField', '~> 3.0'

  target 'Social-WalletTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'Social-WalletUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
