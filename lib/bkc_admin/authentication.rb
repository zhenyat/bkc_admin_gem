#!/usr/bin/env ruby
################################################################################
#   authenticate.rb
#     Generates Concerns Controller from template for user authentication
#
#   12.03.2015  ZT
#   15.03.2015  Corrected
################################################################################

# Concerns directory
relative_path = 'app/controllers/concerns'
admin_path    = "#{$app_root}/#{relative_path}"

action_report relative_path
Dir.mkdir(admin_path) unless File.exist?(admin_path)

# Controller file
file_name     = "admin_authentication.rb"
relative_path = "app/controllers/concerns/#{file_name}"
absolute_path = "#{$app_root}/#{relative_path}"
template      = File.join BkcAdmin.templates, file_name

unless File.exist?(absolute_path)
  action_report relative_path
  FileUtils.cp(template, absolute_path)
end

# Update app/controllers/application_controller.rb

relative_path = "app/controllers/application_controller.rb"

file_in  = File.open "#{$app_root}/#{relative_path}", "r"
file_out = File.open "#{$app_root}/app/controllers/tmp.rb", "w"

# Read original lines
lines = file_in.readlines
file_in.close

# Find line with *AdminAuthentication*
found = false
lines.each_with_index do |line, k|
  if line.include? "AdminAuthentication"
    found = true
    break
  end
end

if found
  # Add new *include* line
  lines.each_with_index do |line, k|
    file_out.puts line
    if line.match("protect_from_forgery") && !line.match("#") # Line exists and not a comment
      file_out.puts "  include AdminAuthentication"
    end
  end

  file_out.close

  action_report relative_path
  FileUtils.mv "#{$app_root}/app/controllers/tmp.rb", "#{$app_root}/#{relative_path}"
end