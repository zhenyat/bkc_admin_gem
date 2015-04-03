#!/usr/bin/env ruby
#################################################################################
#   view_index.rb
#
#   Generates View file: admin/views/<models>/index.html.haml
#
#   01.02.2014  ZT
#   24.02.2015  v 1.0.0
#   05.03.2015  v 1.1.0 view of references type updated
#   26.03.2015  v 1.2.0 Translation added
################################################################################
relative_path = "#{$relative_views_path}/index.html.haml"
action_report relative_path

file = File.open("#{$absolute_views_path}/index.html.haml", 'w')

file.puts "%p#notice= notice"
file.puts "\n%h1= t(:listing_objects) + \": \" + t(:#{$names})\n\n"     # Page Title

# Table heads line
file.puts "%table\n\  %thead\n    %tr"

$attr_names.each do |attr_name|
  file.puts "      %th= t :#{attr_name}" unless attr_name.include?('password') || attr_name.include?('remember')
end
file.puts "      %th= t :actions"

#Table body
file.puts "\n  %tbody"
file.puts "    - @#{$names}.each do |#{$name}|"
file.puts "      %tr"
$attr_names.each_with_index do |attr_name, index|
  if $attr_types[index] == 'references'
    file.puts "        %td= #{$name}.#{attr_name}.title"
  else
    if attr_name == 'status'
      file.puts "        %td= status_mark #{$name}.#{attr_name}"
    elsif $attr_types[index] == 'boolean'
      file.puts "        %td= status_mark #{$name}.#{attr_name}"
    else
      file.puts "        %td= #{$name}.#{attr_name}" unless attr_name.include?('password') || attr_name.include?('remember')
    end
  end
end

file.puts "        %td.buttons"
file.puts "          = link_to image_tag('buttons/show.png', alt: 'показать', title: 'показать'), [:admin, #{$name}]"
file.puts "          = link_to image_tag('buttons/edit.png', alt: 'редактировать', title: 'редактировать'), edit_admin_#{$name}_path(#{$name})"
file.puts "          = link_to image_tag('buttons/delete.png', alt: 'удалить', title: 'удалить'), [:admin, #{$name}], method: :delete, data: {confirm: 'Вы уверены?'}"

file.puts "%br"
file.puts "= link_to t(:new), new_admin_#{$name}_path"

file.close
