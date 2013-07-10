# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Index100'

  app.codesign_certificate = 'iPhone Developer: Yoshifumi Sato'

  app.identifier = 'com.satoyos.Index_100'

  app.icons = ['百首決まり字.png', '百首決まり字@2x.png']
  app.prerendered_icon = true

  app.provisioning_profile = '/Users/yoshi/Library/MobileDevice/Provisioning/My_Provisioning_for_Test_App_on_iPhone5.mobileprovision'

  app.frameworks += ['QuartzCore']

  app.vendor_project(
      'vendor/Reveal.framework',
      :static,
      :products => %w{Reveal},
      :headers_dir => 'Headers'
  )
end
