platform :ios, '13.0'
use_frameworks!

target 'NoGaDa' do
  # Pods for NoGaDa
  # Rx
  pod 'RxSwift',            '~> 6.5.0'
  pod 'RxCocoa',            '~> 6.5.0'
  pod 'RxGesture',          '~> 4.0.4'
  
  # UI
  pod 'Hero',               '~> 1.6.2'
  pod 'FloatingPanel',      '~> 2.6.0'
  pod 'SafeAreaBrush',      '~> 1.0.4'
  pod 'BISegmentedControl', '~> 0.1.1'
  pod 'SwiftRater',         '~> 2.1.0'
  
  # Database
  pod 'RealmSwift',         '10.42.4'
  
  # AdMob
  pod 'Google-Mobile-Ads-SDK'
  
  # Networking
  pod 'Alamofire',          '~> 5.8.0'
  
  # Conventions
  pod 'R.swift'
  
  target 'NoGaDaTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'NoGaDaUITests' do
    # Pods for testing
  end
  
end

# Limit minimum deployment target version
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
    end
    shell_script_path = "Pods/Target Support Files/#{target.name}/#{target.name}-frameworks.sh"
    if File::exists?(shell_script_path)
      shell_script_input_lines = File.readlines(shell_script_path)
      shell_script_output_lines = shell_script_input_lines.map { |line| line.sub("source=\"$(readlink \"${source}\")\"", "source=\"$(readlink -f \"${source}\")\"") }
      File.open(shell_script_path, 'w') do |f|
        shell_script_output_lines.each do |line|
          f.write line
        end
      end
    end
  end
end
