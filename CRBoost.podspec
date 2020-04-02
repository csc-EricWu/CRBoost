#
# Be sure to run `pod lib lint CRBoost.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CRBoost'
  s.version          = '0.2.3'
  s.summary          = 'A short description of CRBoost.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/csc-EricWu/CRBoost'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Eric Wu' => 'sleman@foxmail.com' }
  s.source           = { :git => 'https://github.com/csc-EricWu/CRBoost', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.source_files = 'CRBoost/**/*.{h,m}'
  s.xcconfig     = {'OTHER_LDFLAGS' => '-ObjC'}

  # s.resource_bundles = {
  #   'CRBoost' => ['CRBoost/Assets/*.png']
  # }

  s.public_header_files = 'CRBoost/CRBoost.h'

  s.frameworks = 'UIKit' ,'Foundation'
  s.module_name = 'CRBoost'

  # s.dependency 'AFNetworking', '~> 2.3'
end
