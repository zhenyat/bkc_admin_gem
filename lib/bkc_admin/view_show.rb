#!/usr/bin/env ruby
#################################################################################
#   view_show.rb
#
#   Generates View file: admin/views/<model>/show.html.haml
#
#   29.01.2014  ZT
#   24.02.2015  v 1.0.0
#   05.03.2015  v 1.1.0 view of references type updated
################################################################################

relative_path = "#{$relative_views_path}/show.html.haml"
action_report relative_path

file = File.open("#{$absolute_views_path}/show.html.haml", 'w')

file.puts "%p#notice= notice\n\n"

file.puts "%h1 Просмотр #{$name}"
$attr_names.each_with_index do |attr_name, index|
  if $attr_types[index] == 'references'
    file.puts "%p\n  %strong #{attr_name.capitalize}:\n  = @#{$name}.#{attr_name}.title"
  else
    if attr_name == 'status'
      file.puts "%p\n  %strong Active"
      file.puts "  = status_mark @#{$name}.#{attr_name}"
    else
      file.puts "%p\n  %strong #{attr_name.capitalize}:\n  = @#{$name}.#{attr_name}" unless attr_name.include?('password') || attr_name.include?('remember')
    end
  end
end

file.puts "\n= link_to 'Edit', edit_admin_#{$name}_path(@#{$name})"
file.puts "\\|"
file.puts "= link_to 'Back', admin_#{$names}_path"

file.close