#!/usr/bin/env ruby
################################################################################
#   bin/bkc
#     Deletes Admin assets directories and files
#
#   17.02.2015  ZT
################################################################################

pathes = ["app/assets/images/admin",
          "app/assets/images/buttons",
          "app/assets/stylesheets/admin",
          "app/assets/javascripts/admin"
         ]

pathes.each do |path|
  if File.exist? "#{$app_root}/#{path}"
    FileUtils.rm_rf "#{$app_root}/#{path}"
    puts colored(RED,  "\tremove     ") + "#{path}"
  end
end