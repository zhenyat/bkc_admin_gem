#!/usr/bin/env ruby
################################################################################
#   bin/bkc
#     Deletes Admin files for a given Model
#
#   15.02.2015  ZT
#   23.02.2015  v 1.0.0
#   14.03.2015  v 1.1.0  Assets removing
#   26.03.2015  v 1.2.0  Bug fixed
################################################################################

# Delete controller
relative_path = 'app/controllers/admin'
admin_path    = "#{$app_root}/#{relative_path}"

if File.exist? admin_path
  file = "#{admin_path}/#{$names}_controller.rb"
  if File.exist? file
    File.delete file
    puts colored(RED,  "\tremove     ") + "#{relative_path}/#{$names}_controller.rb"
  end
end

# Delete views
view_relative_path = 'app/views/admin'
views_path    = "#{$app_root}/#{view_relative_path}/#{$names}"

if File.exist? views_path
  FileUtils.rm_r views_path
  puts colored(RED,  "\tremove     ") + "#{view_relative_path}/#{$names}"
end

# Delete Model helpers
helper_file   = "app/helpers/admin/#{$names}_helper.rb"
absolute_path = "#{$app_root}/#{helper_file}"

if File.exist?(absolute_path)
  File.delete absolute_path
  puts colored(RED,  "\tremove     ") + "#{helper_file}"
end

# Delete policy file
  policy_relative_path = "app/policies"
  policy_absolute_path = "#{$app_root}/#{policy_relative_path}"
  policy_file          = "#{policy_absolute_path}/#{$name}_policy.rb"

  if File.exist? policy_file
    File.delete policy_file
    puts colored(RED,  "\tremove     ") + "#{policy_relative_path}/#{$name}_policy.rb"
  end

# Delete everything if no more models in Admin
if File.exist?(admin_path) && Dir.glob("#{admin_path}/*").empty?
  Dir.rmdir admin_path
  puts colored(RED,  "\tremove     ") + "#{relative_path}"

  view_admin_path = "#{$app_root}/#{view_relative_path}"
  if File.exists?(view_admin_path) && Dir.glob("#{view_admin_path}/*").empty?
    Dir.rmdir view_admin_path
    puts colored(RED,  "\tremove     ") + "#{view_relative_path}"
  end

  # Delete BKC helper
  helper_relative_path = "app/helpers/admin"
  helper_admin_path    = "#{$app_root}/#{helper_relative_path}"
  helper_file          = "#{helper_admin_path}/bkc_helper.rb"
  if File.exist? helper_file
    File.delete helper_file
    puts colored(RED,  "\tremove     ") + "#{helper_relative_path}/bkc_helper.rb"
  end

  # Delete admin directory for helpers
  if Dir.glob("#{helper_admin_path}/*").empty?
    Dir.rmdir helper_admin_path
    puts colored(RED,  "\tremove     ") + "#{helper_relative_path}"
  end

#  relative_images_path = "app/assets/images/admin"
#  FileUtils.rm_rf "#{$app_root}/#{relative_images_path}"
#  puts colored(RED,  "\tremove     ") + "#{relative_images_path}"
#
#  relative_images_path = "app/assets/images/buttons"
#  FileUtils.rm_rf "#{$app_root}/#{relative_images_path}"
#  puts colored(RED,  "\tremove     ") + "#{relative_images_path}"
#
#  relative_images_path = "app/assets/stylesheets/admin"
#  FileUtils.rm_rf "#{$app_root}/#{relative_images_path}"
#  puts colored(RED,  "\tremove     ") + "#{relative_images_path}"
end

