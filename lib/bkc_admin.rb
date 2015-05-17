################################################################################
#   bkc_admin.rb
#     Main Module to generate / update / destroy directories and files
#
#   10.03.2015   ZT
#   17.03.2015  v 0.2.0
################################################################################

require "bkc_admin/version"
require "bkc_admin/setpar"
require 'active_support/inflector'
require "bkc_admin/methods_pool"
require "bkc_admin/command_parser"
require "bkc_admin/get_names"
require 'pp'
require "active_support/dependencies/autoload"

options = BkcAdmin::OptparseCommand.parse(ARGV)

BkcAdmin.get_names options

if $mode == 'generate'                          # Generate Admin directories and files
  case $object
    when 'model'
      get_attributes                            # Handle Model attributes
      enum_values                               # Handle enum attributes

      require "bkc_admin/controller"            # Admin Controller
      require "bkc_admin/authentication"        # Concerns Controller & Updates application_controller
      require "bkc_admin/policy"                # Pundit policy file

      require "bkc_admin/helper"                # Admin Helpers

      require "bkc_admin/add_resource"          # Update config/routes.rb file

      create_views_path                         # Generate Admin Views for the Model
      require "bkc_admin/view_index"            # View:     index
      require "bkc_admin/view_show"             # View:     show
      require "bkc_admin/view_new"              # View:     new
      require "bkc_admin/view_edit"             # View:     edit
      require "bkc_admin/view_form"             # Partial: _for

      require "bkc_admin/add_assets_for_controller"  # Add JS and SCSS files for the controller
    when 'assets'
      require "bkc_admin/add_assets"            # Add assets for Admin
    when 'layouts'
      require "bkc_admin/add_layouts"           # Add layouts for Admin
  end

else                                            # Destroy Admin files and directories
  case $object
    when 'model'
      require "bkc_admin/destroy"               # Destroy files and directories
      require "bkc_admin/remove_resource"       # Remove resource from config/routes.rb file
      require "bkc_admin/remove_authentication" # Update application_controller.rb
    when 'assets'
      require "bkc_admin/remove_assets"         # Remove assets for Admin
    when 'layouts'
      require "bkc_admin/remove_layouts"        # Remove layouts for Admin
  end
end
