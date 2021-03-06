#!/usr/bin/env ruby
#################################################################################
#   view_form.rb
#
#   Generates partial file: admin/views/<models>/_form.html.haml
#
#   01.02.2014  ZT
#   23.02.2015  v 1.0.0
#   26.03.2015  v 1.1.0 Localization
################################################################################

relative_path = "#{$relative_views_path}/_form.html.haml"
action_report relative_path

file = File.open("#{$absolute_views_path}/_form.html.haml", 'w')

file.puts "= form_for([:admin, @#{$name}]) do |f|"

# Errors block
file.puts "  - if @#{$name}.errors.any?"
file.puts "    #error_explanation"
file.puts "      %h2"
file.puts "        = pluralize(@#{$name}.errors.count,  'error')"
file.puts "        \! Не удается сохранить объект #{$name}"
file.puts "      %ul"
file.puts "        - @#{$name}.errors.full_messages.each do |msg|"
file.puts "          %li= msg"

# Input fields
$attr_names.each_with_index do |attr_name, k|
  if attr_name == 'status'
    file.puts "  %div"
    file.puts "    %p= t(:status)"
    file.puts "    =f.#{field_type('active',   $attr_types[k])}"
    file.puts "    = label :status, t(:active)"
    file.puts "    =f.#{field_type('archived', $attr_types[k])}"
    file.puts "    = label :status, t(:archive)"
  elsif attr_name.match 'password'
    file.puts "  .field"
    file.puts "    =f.label t(:password)"
    file.puts "    =f.#{field_type('password', $attr_types[k])}"

    file.puts "  .field"
    file.puts "    =f.label t(:password_confirmation)"
    file.puts "    =f.#{field_type('password_confirmation', $attr_types[k])}"
  elsif attr_name.match 'remember_digest'
    # skip this attribute
  elsif attr_name == 'position'
    file.puts "  %input{:type => 'hidden', :name => 'position',  :value => @#{$name}.position}"
  else
    file.puts "  .field"
    file.puts "    =f.label t(:#{attr_name})"
    file.puts "    =f.#{field_type(attr_name, $attr_types[k])}"
  end
end

# Submit button
file.puts "  .actions"
file.puts "    = f.submit t(:save)"

file.close
