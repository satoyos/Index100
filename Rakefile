# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
# require 'bubble-wrap'
require 'guard/motion'
require 'motion-localization'
require 'bundler/setup'
Bundler.require :default

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Index100'

  app.codesign_certificate = 'iPhone Developer: Yoshifumi Sato'

  app.identifier = 'com.satoyos.Index_100'

  app.icons = ['百首決まり字.png', '百首決まり字@2x.png']
  app.prerendered_icon = true

  app.provisioning_profile = '/Users/yoshi/data/dev/Provisioning_Profile_Dev_iPhone5s.mobileprovision'

  app.frameworks += ['QuartzCore']
  app.frameworks += ['AVFoundation', 'AudioToolbox']

  app.vendor_project(
      'vendor/Reveal.framework',
      :static,
      :products => %w{Reveal},
      :headers_dir => 'Headers'
  )

  app.files_dependencies  'app/app_delegate.rb' => 'app/lib/rm_settings/rmsettable.rb',
                          'app/lib/rm_settings/rmsettable.rb' => 'app/lib/rm_settings/rmsettings.rb'
end
