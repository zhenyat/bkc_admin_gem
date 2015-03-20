################################################################################
#   get_name.rb
#     Identifies parameters for the procedure
#
#   10.03.2015   ZT
#   17.03.2015  v 0.2.0
################################################################################

module BkcAdmin
  # Gets Model names (capitalized and plural)
  def self.get_names options

    # ARGV[0] must be the procedure *mode*
    case ARGV[0]
      when 'g', 'generate'
        $mode = 'generate'
      when 'd', 'destroy'
        $mode = 'destroy'
    else
        puts colored(RED, "First argument must be the command mode: 'g[enerate]' or 'd[estroy]'")
        exit
    end

    # ARGV[1] must be the procedure *object*
    case ARGV[1]
      when 'model'
        $object = 'model'
        if ARGV.count < 3
          puts colored(RED, "Select model name")
          exit
        end
      when 'assets'
        $object = 'assets'
      when 'layouts'
        $object = 'layouts'
      else
        puts colored(RED, "Second argument must be the object: 'model', 'assets' or 'layouts'")
        exit
    end

    # Define names for Model
    if $object == 'model'
      upper_count = ARGV[2].scan(/\p{Upper}/).count  # Number of uppercase characters

      if upper_count > 1                # Compound name (e.g. RedWineGlass)
        $model  = ARGV[2]
        $models = $model.pluralize
        $name   = ARGV[2][0].downcase
        string  = ARGV[2][1..-1]
        string.chars do |c|
          if c.match(/\p{Upper}/)
            $name << '_' << c.downcase
          else
            $name << c
          end
        end
        $names = $name.pluralize
      else                              # Simple name (e.g. User)
        $model  = ARGV[2].capitalize    # e.g.  City
        $models = $model.pluralize      # e.g.  Cities
        $name   = $model.downcase       # e.g.  city
        $names  = $name.pluralize       # e.g.  cities
      end

      # Enumerated options
      $enums  = options[:enum] if options[:enum].size > 0
      $editor = options[:editor] unless options[:editor].nil?
    end
  end
end