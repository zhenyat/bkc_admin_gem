#!/usr/bin/env ruby
################################################################################
# Library of methods to generate Admin files for a Model
#
# 31.01.2015  ZT
# 23.02.2015  v 1.0.0
# 28.02.2015  v 1.0.1
# 01.03.2015  v 1.1.0  sort_object helper added
# 03.03.2015  v 1.2.0  Compound names handling
################################################################################

require 'fileutils'

# Reports an action applied to a Directory / File
def action_report relative_path

  # Case: routes.rb
  if relative_path.include? "routes.rb"
    puts colored(BLUE,  "\tupdate     ") + relative_path
    puts colored(GREEN, "\tcreate     ") + 'config/routes_backup.rb'
    return
  end
  absolute_path = "#{$app_root}/#{relative_path}"

  if File.basename(relative_path).include?('.')   # It's a file
    if File.exist? absolute_path
      puts colored(BLUE,  "\treplace      ") + relative_path
    else
      puts colored(GREEN, "\tcreate       ") + relative_path
    end
  else                                            # It's a directory
    if File.exist? absolute_path
      puts colored(GREY, "\tinvoke     ")  + relative_path
    else
      puts colored(GREEN, "\tcreate     ") + relative_path
    end
  end
end

# Colorizes text for output to bash terminal
def colored flag, text
  case flag
    when BLACK
      index = 0
    when BLUE
      index = 34
    when GREEN
      index = 32
    when RED
      index = 31
    when GREY, GRAY
      index = 37
  else
    index = 0
  end
  return "\e[#{index}m #{text}" + "\e[0m"
end

# Creates Admin views path for a Model
def create_views_path
  $relative_views_path = "app/views/admin/#{$names}"
  $absolute_views_path = "#{$app_root}/#{$relative_views_path}"
  action_report $relative_views_path

  FileUtils::mkdir_p($absolute_views_path) unless File.exist?($absolute_views_path)
end

# Selects type of input field for a given Model attribute in a form_for helper
def field_type attr_name, attr_type
  case attr_type
    when 'boolean'
      return "check_box :#{attr_name}"

    when 'date'
      return "date_select(:#{attr_name}, order: [:day, :month, :year], selected: Date.today, use_month_names: ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября','декабря']) "

    when 'decimal'
      return "number_field :#{attr_name}, step: 0.01"

    when 'integer'
      if attr_name == 'active'
        return "radio_button :status, :active"
      elsif attr_name == 'archived'
        return "radio_button :status, :archived"
      else
        return "number_field :#{attr_name}"
      end

    when 'references'
      return "collection_select :#{attr_name}_id, sort_objects(@#{attr_name}s, :title), :id, :title, include_blank: false"
    when 'string'
      case attr_name
        when 'email'
          return "email_field :#{attr_name}"
        when 'password', 'password_confirmation'
          return "password_field :#{attr_name}"
        else
          return "text_field :#{attr_name}"
      end

    when 'text'
      return "text_area :#{attr_name}"
    else
      puts  colored(RED, "ERROR in field_type: UNDEFINED Attribute Type = '#{attr_type}' for attribute: '#{attr_name}'")
      return "BAD"
  end
end
# Gets Model attributes aka arrays of names and types from the migration file
def get_attributes
  $attr_names = []
  $attr_types = []
  filename    = nil
  attributes  = []    # to be array aka:  ['string:name', 'integer:status']

  file_list   = Dir.entries($migrate_path)

  file_list.each do |f|
    filename = f if f.include? "create_#{$names}"   # find a proper migration file
  end

  if filename
    file_in = File.open("#{$migrate_path}/#{filename}", 'r')
    lines   = file_in.readlines

    # Collect attributes parsing lines of a migration file
    lines.each do |line|
      if line.match("t.") && !line.match("t.timestamps") && !line.match("create_table") && !line.match("class") && !line.match("add_index") &&!line.match("add_foreign_key")

        # remove non-attribute text
        if line.match(",")            # aka:  t.boolean :stock, default: true
          buffer = line.split(",")
          line   = buffer.first       # Cut off text e.g: ", index: true"
        end

        line = line.strip.sub('t.', '').gsub(' ', '')  # line to contain:  string:name

        attributes << line
      end
    end

    # Split attributes array into names and types arrays
    attributes.each do |attribute|
      pair         = attribute.split(":")
      $attr_types << pair.first.rstrip
      $attr_names << pair.last.rstrip

      # Identify special cases
      $references_names  << pair.last if pair.first == 'references'
      $password_attribute = true      if pair.first == 'password'
    end
  else
    puts colored(RED, "Файл миграции для модели #{$model} не найден")
    exit
  end
end

# Gets Model names (capitalized and plural)
#def get_names
#  count = ARGV[1].scan(/\p{Upper}/).count  # Number of uppercase characters
#
#  if count > 1                      # Compound name
#    $model  = ARGV[1]
#    $models = $model.pluralize
#    $name   = ARGV[1][0].downcase
#    string  = ARGV[1][1..-1]
#    string.chars do |c|
#      if c.match(/\p{Upper}/)
#        $name << '_' << c.downcase
#      else
#        $name << c
#      end
#    end
#    $names = $name.pluralize
##    puts $model; puts $models; puts $name; puts $names
##    exit
#  else                              # Simple name
#    $model  = ARGV[1].capitalize    # e.g.  City
#    $models = $model.pluralize      # e.g.  Cities
#    $name   = $model.downcase       # e.g.  city
#    $names  = $name.pluralize       # e.g.  cities
##    puts $model; puts $models; puts $name; puts $names
##    exit
#  end
#
#  # Special attribute cases (identified in 'get_attributes')
#  $references_names    = []
#  $password_attribute  = nil
#end

# Verifies the Command line and parses arguments
#def verify_command_line
#  if ARGV.count == 0 || (ARGV.count == 1 && (ARGV[0] == '-h' || ARGV[0] == '--help'))
#    puts "Command format: bin/admin <action> <Model_name>"
#    puts "                where action is { generate | g | destroy | d}"
#    exit
#  end
#
#  if ARGV.count == 1 && (ARGV[0] == 'g' || ARGV[0] == 'generate' || ARGV[0] == 'd' || ARGV[0] == 'destroy')
#    puts 'Provide Model_name'
#    exit
#  end
#
#  if    ARGV[0] == 'g' || ARGV[0] == 'generate'
#    $mode = 'generate'
#  elsif ARGV[0] == 'd' || ARGV[0] == 'destroy'
#    $mode = 'destroy'
#  else
#    puts 'Incorrect command format'
#    exit
#  end
#end
