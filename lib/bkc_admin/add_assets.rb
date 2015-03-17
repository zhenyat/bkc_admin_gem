#!/usr/bin/env ruby
################################################################################
#   add_assets.rb
#     Generates assets for Admin
#
#   14.03.2015  ZT
################################################################################

origin_paths = ["#{BkcAdmin.assets}/images/admin",
                "#{BkcAdmin.assets}/images/buttons",
                "#{BkcAdmin.assets}/stylesheets/admin",
                "#{BkcAdmin.assets}/javascripts/admin"
               ]

paths = ["app/assets/images/admin",
         "app/assets/images/buttons",
         "app/assets/stylesheets/admin",
         "app/assets/javascripts/admin"
        ]

paths.each_with_index do |path, index|
  unless File.exist? "#{$app_root}/#{path}"
    FileUtils.mkdir "#{$app_root}/#{path}"
    puts colored(GREEN,  "\tcreate     ") + "#{path}"

    unless Dir.glob("#{origin_paths[index]}/*").empty?
      FileUtils.cp_r "#{origin_paths[index]}/.", "#{$app_root}/#{path}"

      Dir.foreach(path) do |file|
        if file != '.' && file != '..'
          puts colored(GREEN,  "\t  create     ") + "#{file}"
        end
      end
    end
  end
end