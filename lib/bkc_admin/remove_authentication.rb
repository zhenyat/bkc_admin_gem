################################################################################
#   remove_authentication.rb
#     Removes line "include AdminAuthentication" from application_controller.rb
#
#   14.03.2015  ZT
################################################################################

unless File.exists? "#{$app_root}/app/controllers/admin"
  file_name = "app/controllers/application_controller.rb"
  file_in   = File.open "#{$app_root}/#{file_name}", "r"
  file_out = File.open "#{$app_root}/#{file_name}.tmp", "w"

  # Read original lines
  lines = file_in.readlines
  file_in.close

  lines.each do |line|
    file_out.puts line unless line.match("AdminAuthentication")
  end

  FileUtils.mv "#{$app_root}/#{file_name}.tmp", "#{$app_root}/#{file_name}"
  #FileUtils.rm "#{$app_root}/#{file_name}.tmp"

  action_report file_name
end