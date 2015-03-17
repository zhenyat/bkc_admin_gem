#!/usr/bin/env ruby
################################################################################
#   bin/bkc
#     Deletes Admin view layouts
#
#   17.02.2015  ZT
################################################################################

puts colored RED,  "Module is not ready yet"
exit

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