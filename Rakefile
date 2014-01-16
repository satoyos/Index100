# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
# require 'bubble-wrap'
require 'guard/motion'
require 'motion-localization'
require 'sugarcube'
require 'sugarcube-color'
require 'sugarcube-uikit'
require 'sugarcube-nsuserdefaults'
require 'motion-testflight'
require 'bundler/setup'
Bundler.require :default

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Index100'

  app.version = '1.02'

  app.codesign_certificate = 'iPhone Developer: Yoshifumi Sato'

  app.identifier = 'com.satoyos.Index_100'

#  app.icons = ['百首決まり字.png', '百首決まり字@2x.png']
  app.icons = ['index100.png', 'index100@2x.png']
  app.prerendered_icon = true

  app.provisioning_profile = '/Users/yoshi/data/dev/Provisioning_for_100series_Tester_with_iPad_Air.mobileprovision'

  app.frameworks += ['QuartzCore']
  app.frameworks += ['AVFoundation', 'AudioToolbox']

  app.info_plist['CFBundleURLTypes'] = [
      { 'CFBundleURLName' => 'com.satoyos.Index_100',
        'CFBundleURLSchemes' => ['index100'] }
  ]

  app.vendor_project('app/lib/UIView+shake', :static,
                     :headers_dir => 'app/lib/UIView+shake')

  app.development do
    app.testflight do
      app.testflight.sdk = 'vendor/TestFlightSDK2.0.2'
      app.testflight.api_token = '1fa759189453676c7e99c623b61c1657_OTEzMzU4MjAxMy0wMy0wNSAwODowMToyNS44NTMxNjg'
      app.testflight.team_token = '6396149579b3bcb7410be09ba868f8b7_MjgxOTEwMjAxMy0xMC0wNiAwNTowMDo0MS42MzA2OTQ'
      app.testflight.app_token = '696d14ae-140b-403f-8434-6109aaf6d745'
      app.testflight.notify = true # default is false
      app.testflight.identify_testers = true # default is false
    end
  end

end
