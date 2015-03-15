################################################################################
#   setpar.rb
#     Initializses parameters for the gem
#
#   09.03.2015   ZT
################################################################################

# Constants
BLACK = 'black'
BLUE  = 'blue'
GRAY  = 'grey'
GREY  = 'gray'
GREEN = 'green'
RED   = 'red'

# Variables: paths
$app_root     = `pwd`.chomp    # chomp without arguments removes "\n" or "\r\n" if any
$migrate_path = "#{$app_root}/db/migrate"
$model_path   = "#{$app_root}/app/models"

# Special attribute cases (identified in *get_attributes*)
$references_names    = []
$password_attribute  = nil

# Enumerated options
$enum = []

module BkcAdmin
  def self.root
    File.dirname(__dir__).chomp("/lib")
  end

  def self.assets
    File.join root, 'assets'
  end

  def self.bin
    File.join root, 'bin'
  end

  def self.lib
    File.join root, 'lib'
  end

  def self.templates
    File.join root, 'templates'
  end
end