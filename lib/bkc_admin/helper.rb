#!/usr/bin/env ruby
#################################################################################
#   helper_model.rb
#     Generates Admin Helper file from template
#
#   13.03.2015  ZT
################################################################################

# Helper admin directory
relative_path = 'app/helpers/admin'
admin_path    = "#{$app_root}/#{relative_path}"

action_report relative_path
Dir.mkdir(admin_path) unless File.exist?(admin_path)

# BKC Helper file
file_name     = "bkc_helper.rb"
relative_path = "app/helpers/admin/#{file_name}"
absolute_path = "#{$app_root}/#{relative_path}"
template      = File.join BkcAdmin.templates, file_name

unless File.exist?(absolute_path)
  action_report relative_path
  FileUtils.cp(template, absolute_path)
end
