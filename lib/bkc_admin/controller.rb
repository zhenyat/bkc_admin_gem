#!/usr/bin/env ruby
################################################################################
#   bin/bkc
#     G:verify_authorizedenerates Admin Controller for the given Model
#
#   25.01.2015  ZT
#   23.02.2015  v 1.0.0
#   04.03.2015  v 1.1.0
#   05.03.2015  v 1.2.0   activate admin module and layout
#   17.03.2015  v 1.3.0
#   21.03.2015  *access* authorization added
#   17.05.2015  *alterations* bug fixed
#   19.05.2015  *access_forbidden* line updated
#   23.05.2013  *BKC* module added with -l option
################################################################################
# admin directory
relative_path = 'app/controllers/admin'
admin_path    = "#{$app_root}/#{relative_path}"

action_report relative_path
Dir.mkdir(admin_path) unless File.exist?(admin_path)

# Controller file
relative_path = "app/controllers/admin/#{$names}_controller.rb"
absolute_path = "#{$app_root}/#{relative_path}"
action_report relative_path

file = File.open(absolute_path, 'w')

# Generate controller code
file.puts "class Admin::#{$models}Controller < ApplicationController"
file.puts "\tinclude AdminAuthentication"
file.puts "\tinclude BKC" if $logbook
file.puts "\tlayout 'admin'\n\n"
file.puts "\tbefore_filter :check_login"
file.puts "\tbefore_action :set_#{$name},              only:  [:edit, :destroy, :show, :update]"

if $access == 'pundit'
  file.puts "\tafter_action  :verify_authorized,  except:  :index"
  file.puts "\tafter_action  :verify_policy_scoped, only:  :index"
end

file.puts "\tafter_action  :logbook,              only: [:create, :destroy, :update]" if $logbook

file.puts "\n\tdef create\n\t\tbuild_#{$name}\n\t\tsave_#{$name} or render 'new'\n\tend"

file.puts "\n\tdef destroy\n\t\tload_#{$name}\n\t\t@#{$name}.destroy\n\t\tredirect_to admin_#{$names}_url, notice: '#{$model} was successfully destroyed'\n\tend"

file.puts "\n\tdef edit\n\t\tload_#{$name}\n\t\tbuild_#{$name}\n\tend"

if $access == 'pundit'
  line = "\n\tdef index"
  line << "\n\t\t@#{$names} = policy_scope(#{$model})"
  line << "\n\t\tredirect_to :back, alert: t(:access_forbidden) if (@#{$names}.empty? && current_user.role != 'sysadmin')"
  line << "\n\tend"
  file.puts line
else
  file.puts "\n\tdef index\n\t\tload_#{$names}\n\tend"
end

file.puts "\n\tdef new\n\t\tbuild_#{$name}\n\tend"

file.puts "\n\tdef show\n\t\tload_#{$name}\n\tend"

file.puts "\n\tdef update\n\t\tload_#{$name}\n\t\tbuild_#{$name}\n\t\tupdate_#{$name} or render 'edit'\n\tend"

file.puts "\n\tprivate\n"

file.puts "\n\t# #{$model} white list attributes"
line = "\tdef #{$name}_params\n\t\t#{$name}_params = params[:#{$name}]\n\t\t#{$name}_params ? #{$name}_params.permit("
$attr_names.each do |attr_name|
  if $references_names.include? attr_name
    line << ":#{attr_name}_id"                        # FK attribute
  else
    line << ":#{attr_name}"                           # Ordinary attribute
  end
  line << ", " unless attr_name== $attr_names.last    # Non-last attribute
end
line << ") : {}\n\tend"
file.puts line

# Model scope
file.puts "\n\tdef #{$name}_scope\n\t\t#{$model}.all\n\tend\n"

# Enumerated scopes    - NOT NEEDED
#unless $enums.empty?
#  $enums.each do |enum|
#    $attr_names.each do |attr_name|
#      if enum.include? attr_name
#        file.puts "\n\tdef #{attr_name}_scope\n\t\t#{$model}.#{attr_name}s\n\tend\n"
#      end
#    end
#  end
#end

# FK scopes
unless $references_names.empty?
  $attr_names.each do |attr_name|
    if $references_names.include? attr_name
      if attr_name.include? "_"             # Compound model name e.g. building_type
        words = attr_name.split "_"
        compound_model_name = ""
        words.each do |word|
          compound_model_name << word.capitalize
        end
        file.puts "\n\tdef #{attr_name}_scope\n\t\t#{compound_model_name}.active\n\tend\n"
      else
        file.puts "\n\tdef #{attr_name}_scope\n\t\t#{attr_name.capitalize}.active\n\tend\n"
      end
    end
  end
end

if $references_names.empty?
  line  = "\n\tdef build_#{$name}\n\t\t@#{$name}          ||= #{$name}_scope.build\n\t\t@#{$name}.attributes = #{$name}_params"
else
  line = "\n\tdef build_#{$name}"
  $attr_names.each do |attr_name|
    line << "\n\t\t@#{attr_name}s         ||= #{attr_name}_scope.to_a" if $references_names.include? attr_name
  end
  line << "\n\t\t@#{$name}          ||= #{$name}_scope.build\n\t\t@#{$name}.attributes = #{$name}_params"
end

# Add enumerated values
unless $enums.empty?
  $enums.each do |enum|
    $attr_names.each do |attr_name|
      if enum.include? attr_name
        line << "\n\t\t@#{enum}s           = #{enum}_scope.to_a"
        file.puts "\n\tdef #{attr_name}_scope\n\t\t#{$model}.#{attr_name}s\n\tend\n"
      end
    end
  end
end
line << "\n\t\tauthorize @#{$name}"  if $access == 'pundit'
line << "\n\tend"
file.puts line

line = "\n\tdef load_#{$name}\n\t\t@#{$name} ||= #{$name}_scope.find(params[:id])"
unless $references_names.empty?
  $attr_names.each do |attr_name|
    line << "\n\t\t@#{attr_name}_title = @#{$name}.#{attr_name}.title" if $references_names.include? attr_name
  end
end
line << "\n\t\tauthorize @#{$name}"  if $access == 'pundit'
line << "\n\tend"
file.puts line

unless $access == 'pundit'
  line = "\n\tdef load_#{$names}"
  unless $references_names.empty?
    $attr_names.each do |attr_name|
      line << "\n\t\t@#{attr_name}s ||= #{attr_name}_scope.to_a" if $references_names.include? attr_name
    end
  end
  line << "\n\t\t@#{$names} ||= #{$name}_scope.to_a\n\tend"
  file.puts line
end

if $logbook
  file.puts "\n\tdef save_#{$name}\n\t\tif @#{$name}.save\n\t\t\tparams['alterations'] = @#{$name}.previous_changes\n\t\t\tredirect_to [:admin, @#{$name}], notice: '#{$model} was successfully created'\n\t\tend\n\tend"
else
  file.puts "\n\tdef save_#{$name}\n\t\tif @#{$name}.save\n\t\t\tredirect_to [:admin, @#{$name}], notice: '#{$model} was successfully created'\n\t\tend\n\tend"
end

file.puts "\n\t# Use callbacks to share common setup or constraints between actions"
file.puts "\tdef set_#{$name}\n\t\t@#{$name} = #{$model}.find(params[:id])\n\tend"

if $logbook
  file.puts "\n\tdef update_#{$name}\n\t\tif @#{$name}.update(#{$name}_params)\n\t\t\tparams['alterations'] = @#{$name}.previous_changes\n\t\t\tredirect_to [:admin, @#{$name}], notice: '#{$model} was successfully updated'\n\t\tend\n\tend"
else
  file.puts "\n\tdef update_#{$name}\n\t\tif @#{$name}.update(#{$name}_params)\n\t\t\tredirect_to [:admin, @#{$name}], notice: '#{$model} was successfully updated'\n\t\tend\n\tend"
end

file.puts "end"

file.close
