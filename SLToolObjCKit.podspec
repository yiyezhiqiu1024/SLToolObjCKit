#
# Be sure to run `pod lib lint SLToolObjCKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'SLToolObjCKit'
    s.version          = '0.2.0'
    s.summary          = '封装的工具类库'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = <<-DESC
    封装了弹窗、文件管理、对AFNetworking封装、对SVProgressHUD封装、检查版本更新、归档存储等工具类
    DESC
    
    s.homepage         = 'https://github.com/CoderSLZeng/SLToolObjCKit'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'CoderSLZeng' => '359297567@qq.com' }
    s.source           = { :git => 'https://github.com/CoderSLZeng/SLToolObjCKit.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.ios.deployment_target = '8.0'
    
    # 导入二进制文件和非二进制文件判断
    if ENV['IS_BINARY']
        
        s.source_files = 'SLToolObjCKit/Classes/**/*.h'
        s.public_header_files = 'SLToolObjCKit/Classes/**/*.h'
        s.dependency 'AFNetworking'
        s.dependency 'SVProgressHUD'
        s.dependency 'SLCategoryObjCKit/String'
        
        if ENV['IS_LIB'] # Use demo: IS_BINARY=1 IS_LIB=1 pod install
            
            # 打包 【.a】 文件命令行
            # pod package SLToolObjCKit.podspec --library --exclude-deps --spec-sources='https://github.com/CoderSLZeng/SLToolObjCKit.git,https://github.com/CocoaPods/Specs.git'
            
            s.ios.vendored_libraries = 'SLToolObjCKit/Products/libSLToolObjCKit.a'
            
            else # Use demo: IS_BINARY=1 pod install
            
            # 打包 【.framework】 文件命令行
            # pod package SLToolObjCKit.podspec  --exclude-deps --spec-sources='https://github.com/CoderSLZeng/SLToolObjCKit.git,https://github.com/CocoaPods/Specs.git'
            
            s.ios.vendored_frameworks = 'SLToolObjCKit/Products/SLToolObjCKit.framework'
            
        end
        
        else # Use demo: pod install
        # 导入资源文件
        # s.source_files = 'SLToolObjCKit/Classes/**/*{.h,.m}'
        
        # 导入图片资源文件
        # s.resource_bundles = {
        #   'SLToolObjCKit' => ['SLToolObjCKit/Assets/*.png']
        # }
        
        # subspec
        s.subspec 'Alert' do |alert|
            alert.source_files = 'SLToolObjCKit/Classes/Alert/*.{h,m}'
        end
        
        s.subspec 'File' do |file|
            file.source_files = 'SLToolObjCKit/Classes/File/*.{h,m}'
        end
        
        s.subspec 'Network' do |network|
            network.source_files = 'SLToolObjCKit/Classes/Network/*.{h,m}'
            network.dependency 'AFNetworking'
            network.dependency 'SVProgressHUD'
            network.dependency 'SLCategoryObjCKit/String'
        end
        
        s.subspec 'ProgressHUD' do |progressHUD|
            progressHUD.source_files = 'SLToolObjCKit/Classes/ProgressHUD/*.{h,m}'
            progressHUD.dependency 'SVProgressHUD'
        end
        
        s.subspec 'UpdateApp' do |updateApp|
            updateApp.source_files = 'SLToolObjCKit/Classes/UpdateApp/*.{h,m}'
        end
        
        s.subspec 'UserDefaults' do |userDefaults|
            userDefaults.source_files = 'SLToolObjCKit/Classes/UserDefaults/*.{h,m}'
        end
                
    end
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    # s.dependency 'AFNetworking', '~> 2.3'
end
