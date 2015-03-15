################################################################################
#   bkc_admin.rb
#     Main Module to generate / update / destroy directories and files
#
#   10.03.2015   ZT
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

if $mode == 'generate'                      # Generate Admin directories and files
  get_attributes

  require "bkc_admin/controller"            # Admin Controller
  require "bkc_admin/authentication"        # Concerns Controller & Updates application_controller

  require "bkc_admin/helper"                # Admin Helpers

  require "bkc_admin/add_resource"          # Update config/routes.rb file

  create_views_path                         # Generate Admin Views for the Model
  require "bkc_admin/view_index"            # View:     index
  require "bkc_admin/view_show"             # View:     show
  require "bkc_admin/view_new"              # View:     new
  require "bkc_admin/view_edit"             # View:     edit
  require "bkc_admin/view_form"             # Partial: _form

  require "bkc_admin/add_assets"            # Assets for Admin

else                                        # Destroy Admin files and directories
  require "bkc_admin/destroy"               # Destroy files and directories
  require "bkc_admin/remove_resource"       # Remove resource from config/routes.rb file
  require "bkc_admin/remove_authentication" # Update application_controller.rb
end
