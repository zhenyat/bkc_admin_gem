################################################################################
#   command_parser.rb
#     Command line options analysis on a base of Ruby OptionParser class
#
#     ref: http://ruby-doc.org/stdlib-2.2.0/libdoc/optparse/rdoc/OptionParser.html#top
#
#   10.03.2015  ZT
#   17.03.2015  v 0.2.0
#   18.03.2015  v 0.3.0
#   21.03.2015  *access*  authorization added
#   16.04.2015  *logbook* added
################################################################################
require 'optparse'
require 'optparse/time'
require 'ostruct'

module BkcAdmin
  class OptparseCommand

    # Returns a structure describing the Command options
    def self.parse(args)
      if args.size == 0
        puts colored RED,  "Arguments required. To learn the command use options: -h or --help"
        exit
      end

      # The options specified on the command line will be collected in *options*.
      # We set default values here.
      options = OpenStruct.new
      options.access = nil      # Access Authorization tool (gem) to be applied
      options.enum   = []       # List of enumerated attributes
      options.editor = nil      # HTML Editor to be applied

      opt_parser = OptionParser.new do |opts|
        opts.banner  = "\nUsage:    bkc_admin {g | generate} model <model_name> [options]"
        opts.banner << "\n          bkc_admin {d | destroy} <model_name>"
        opts.banner << "\n          bkc_admin {g | generate | d | destroy} assets"
        opts.banner << "\n          bkc_admin {g | generate | d | destroy} layouts"
        opts.banner << "\nExamples: bkc_admin g model User -a pundit -e role -t ckeditor"
        opts.banner << "\n          bkc_admin d model Product"
        opts.banner << "\n          bkc_admin g assets"
        opts.banner << "\n          bkc_admin destroy layouts"

        opts.separator ""
        opts.separator "Specific options:"

        # Mandatory argument(s)
        opts.on("-a", "--access AUTHORIZATION TOOL", "To select and apply access authorization tool") do |access|
          options.access = access
        end

        opts.on("-e", "--enum ENUMERATED ATTRIBUTE", "To present the Model enum attribute as a proper input field in a view form") do |enum|
          options.enum << enum
        end

        opts.on("-t", "--text TEXTEDITOR", "To select an HTML text editor for working with textarea input fields in a view form") do |text|
          options.editor = text
        end

        opts.separator ""
        opts.separator "Options without parameters:"

        # Logbook to be used
        opts.on_tail("-l", "--logbook", "Logbook to be used") do
          options.logbook = true
        end

#        opts.separator ""
#        opts.separator "Common options:"

        # No argument, shows at tail.  This will print an options summary
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end

        # To print the version.
        opts.on_tail("-v", "--version", "Show version") do
          puts VERSION
          exit
        end
      end

      opt_parser.parse!(args)
      options
    end           # parse()
  end             # class OptparseCommand
end