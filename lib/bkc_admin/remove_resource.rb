################################################################################
#   remove_resource
#     Removes a Model resource in Admin namespace
#
#   14.02.2015  ZT
#   23.02.2015  v 1.0.0
################################################################################

file_in  = File.open "#{$app_root}/config/routes.rb", "r"
to_delete_line_number = 0

# Read original lines
lines = file_in.readlines

# Find line with admin namespace
lines.each_with_index do |line, k|
  if line.match("namespace :admin do") && !line.match("#") # Line exists and not a comment

    # Find the line to be deleted
    for i in ((k+1)..lines.count)
      if lines[i].match("end") && !lines[i].match("#")
        puts "routes.rb: no resource '#{$names}' found in admin namespace - nothing to remove"
        file_in.close
        exit
      else
        if lines[i].match("resources :#{$names}") && !lines[i].match("#")
          to_delete_line_number = i
          break
        end
      end
    end
  end
end

if to_delete_line_number > 0
  file_out = File.open "#{$app_root}/config/routes_tmp.rb", "w"
  lines.each_with_index do |line, k|
    file_out.puts line if k != to_delete_line_number
  end
  file_out.close
end

file_in.close

FileUtils.mv "#{$app_root}/config/routes.rb",     "#{$app_root}/config/routes_backup.rb"
FileUtils.mv "#{$app_root}/config/routes_tmp.rb", "#{$app_root}/config/routes.rb"

action_report "config/routes.rb"