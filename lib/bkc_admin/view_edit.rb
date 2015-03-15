#!/usr/bin/env ruby
#################################################################################
#   view_edit.rb
#
#   Generates View file: admin/views/<model>/edit.html.haml
#
#   01.02.2014  ZT
#   23.02.2015  v 1.0.0
################################################################################

relative_path = "#{$relative_views_path}/edit.html.haml"
action_report relative_path

file = File.open("#{$absolute_views_path}/edit.html.haml", 'w')

file.puts "%h1 Editing #{$model}"
file.puts "= render 'form'"
file.puts "= link_to 'Show', [:admin, @#{$name}]"
file.puts "\\|"
file.puts "= link_to 'Back', admin_#{$names}_path"

file.close
