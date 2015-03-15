################################################################################
#   add_resource
#     Generates a Model resource in Admin namespace
#     Previous version of *routes.rb* file is backuped
#
#   31.01.2015  ZT
#   23.02.2015  v 1.0.0
################################################################################

file_in  = File.open "#{$app_root}/config/routes.rb", "r"
file_out = File.open "#{$app_root}/config/routes_tmp.rb", "w"

found = false
key   = nil

# Read original lines
lines = file_in.readlines

# Find line with *admin* namespace
lines.each_with_index do |line, k|
  if line.match("namespace :admin do") && !line.match("#") # Line exists and not a comment
    found = true
    key   = k
    break
  end
end

if found
  # Add new resource to existing admin namespace
  lines.each_with_index do |line, k|
    if k == key
      file_out.puts line
      file_out.puts "    resources :#{$names}"
    else
      file_out.puts line
    end
  end
else
  # Create admin namespace and add the resource to it
  lines.each_with_index do |line, k|
    if k == 0
      file_out.puts line
      file_out.puts "\n  namespace :admin do"
      file_out.puts "    resources :#{$names}"
      file_out.puts "  end"
    else
      file_out.puts line
    end
  end
end

file_in.close
file_out.close

FileUtils.mv "#{$app_root}/config/routes.rb",     "#{$app_root}/config/routes_backup.rb"
FileUtils.mv "#{$app_root}/config/routes_tmp.rb", "#{$app_root}/config/routes.rb"

action_report "config/routes.rb"