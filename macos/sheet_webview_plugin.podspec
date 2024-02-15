#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint sheet_webview_plugin.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'sheet_webview_plugin'
  s.version          = '0.0.1'
  s.summary          = 'Flutter sheet webview dialog.'
  s.description      = <<-DESC
Sheet webview dialog for macos.
                       DESC
  s.homepage         = 'http://aungthu.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'newarunkatwal@gmail.com' }

  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
