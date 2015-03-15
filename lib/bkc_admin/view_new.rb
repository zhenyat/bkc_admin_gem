#!/usr/bin/env ruby
#################################################################################
#   view_new.rb
#
#   Generates View file: admin/views/<model>/new.html.haml
#
#   29.01.2014  ZT
#   23.02.2015  v 1.0.0
################################################################################

relative_path = "#{$relative_views_path}/new.html.haml"
action_report relative_path

file = File.open("#{$absolute_views_path}/new.html.haml", 'w')

file.puts "%h1 New #{$name}"
file.puts "= render 'form'"
file.puts "= link_to 'Back', admin_#{$names}_path"

file.close