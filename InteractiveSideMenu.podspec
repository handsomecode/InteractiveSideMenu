Pod::Spec.new do |s|
  s.name         = "InteractiveSideMenu"
  s.version      = "2.2.1"
  s.summary      = "Interactive Side Menu in Swift"
  s.homepage     = "https://github.com/handsomecode/InteractiveSideMenu"
  s.license      = "Apache 2.0 license"
  s.author       = { "Eric Miller" => "eric@handsome.is" }
  
  s.source       = { :git => "https://github.com/handsomecode/InteractiveSideMenu.git", :tag => "#{s.version}" }

  s.platform     = :ios, "9.0"

  s.source_files  = "Sources/*.swift"

  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
end
