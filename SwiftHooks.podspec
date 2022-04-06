Pod::Spec.new do |s|
  s.name             = 'SwiftHooks'
  s.version          = '0.0.6'
  s.summary          = 'A little module for plugins'
  s.swift_versions   = ['5.5']
  s.description      = <<-DESC
SwiftHooks is a package for enabling plugins and plugin architecture
with a variety of different hook implementations synchronous and
asynchronous
                       DESC

  s.homepage         = 'https://github.com/intuit/swift-hooks'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hborawski' => 'harris_borawski@intuit.com' }
  s.source           = { :git => 'https://github.com/intuit/swift-hooks.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.macos.deployment_target = '10.15'
  s.tvos.deployment_target = '13.0'
  s.watchos.deployment_target = '6.0'

  s.source_files = ['Sources/SwiftHooks/**/*.swift']
  s.exclude_files = ['**/*.docc/**/*']
end
