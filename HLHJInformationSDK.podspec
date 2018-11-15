
Pod::Spec.new do |s|

  s.name         = "HLHJInformationSDK"
  s.version      = "1.1.0"

  s.summary      = "天马茂县新闻资讯"
  s.description  = <<-DESC
                   "天马茂县新闻资讯"
                   DESC

  s.platform =   :ios, "9.0"

  s.ios.deployment_target = '9.0'

  s.homepage     = "https://github.com/zaijianrumo/HLHJInformationSDK"
  s.source       = { :git => "https://github.com/zaijianrumo/HLHJInformationSDK.git", :tag => s.version}
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "zaijianrumo" => "2245190733@qq.com"}
    

  s.source_files            = "HLHJFramework/HLHJInformationSDK.framework/Headers/*.{h,m}"
  s.ios.vendored_frameworks = "HLHJFramework/HLHJInformationSDK.framework"
  s.resources               = "HLHJFramework/HLHJImageResources.bundle"

  s.xcconfig = {'VALID_ARCHS' => 'arm64 x86_64'}  

  s.dependency            "AFNetworking"
  s.dependency            "Masonry"
  s.dependency            "MJRefresh"
  s.dependency            "YYModel"
  s.dependency            "SDWebImage"
  s.dependency            "SVProgressHUD"
  s.dependency            "IQKeyboardManager"
  s.dependency            "DZNEmptyDataSet"
  s.dependency            "UMengAnalytics-NO-IDFA"
  s.dependency            "WMPageController"
  s.dependency            "ZFPlayer"
  s.dependency            "SDCycleScrollView"
  s.dependency            "TMUserCenter"

 end