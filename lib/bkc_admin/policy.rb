#!/usr/bin/env ruby
################################################################################
#   policy.rb
#     Generates Pundit Policy file for the given Model
#
#   22.03.2015  ZT
################################################################################

if $access == 'pundit'
  # policies directory
  relative_path = 'app/policies'
  policies_path    = "#{$app_root}/#{relative_path}"

  action_report relative_path
  Dir.mkdir(policies_path) unless File.exist?(policies_path)

  # Policy file
  relative_path = "app/policies/#{$names}_policy.rb"
  absolute_path = "#{$app_root}/#{relative_path}"

  action_report relative_path

  file_in  = File.open File.join(BkcAdmin.templates, "pundit", "policy.rb"), "r"
  file_out = File.open absolute_path, "w"

  file_in.each do |line|
    line.gsub!('ModelPolicy', "#{$model}Policy") if line.include? "ModelPolicy"
    file_out.puts line
  end

  file_in.close
  file_out.close
  exit
end
