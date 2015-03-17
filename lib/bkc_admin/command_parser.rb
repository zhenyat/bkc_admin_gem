################################################################################
#   command_parser.rb
#     Command line options analysis on a base of Ruby OptionParser class
#
#     ref: http://ruby-doc.org/stdlib-2.2.0/libdoc/optparse/rdoc/OptionParser.html#top
#
#   10.03.2015  ZT
#   17.03.2015  v 0.2.0
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
      options.enum = []

      opt_parser = OptionParser.new do |opts|
        opts.banner  = "\nUsage:    bkc_admin {g | generate} model <model_name> [options]"
        opts.banner << "\n          bkc_admin {d | destroy} <model_name>"
        opts.banner << "\n          bkc_admin {g | generate | d | destroy} assets"
        opts.banner << "\n          bkc_admin {g | generate | d | destroy} layouts"
        opts.banner << "\nExamples: bkc_admin g model User -e role"
        opts.banner << "\n          bkc_admin d model Product"
        opts.banner << "\n          bkc_admin g assets"
        opts.banner << "\n          bkc_admin destroy layouts"

        opts.separator ""
        opts.separator "Specific options:"

        # Mandatory argument(s)
        opts.on("-e", "--enum ENUMERATED ATTRIBUTE", "To present the Model enum attribute as a proper input field in a view form") do |enum|
          options.enum << enum
        end

        opts.separator ""
        opts.separator "Common options:"

        # No argument, shows at tail.  This will print an options summary.
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