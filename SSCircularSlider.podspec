#
#  Be sure to run `pod spec lint SSCircularSlider.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "SSCircularSlider"
  s.version      = "1.0.1"
  s.summary      = "A simple, powerful and fully customizable circular ring slider, written in swift."

  #s.description  = "A simple, powerful and fully customizable circular ring slider, written in swift."

  s.homepage     = "https://github.com/simformsolutions/SSCircularSlider"


  #s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Ketan Chopda" => "Ketan.C@simformsolutions.com" }

  s.platform     = :ios
  s.ios.deployment_target = "10.0"
 

  s.source       = { :git => "https://github.com/simformsolutions/SSCircularSlider.git", :tag => "#{s.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.source_files  = 'SSCircularSlider/SSCircularSlider/**/*.swift'
  s.documentation_url = 'docs/index.html'

end
