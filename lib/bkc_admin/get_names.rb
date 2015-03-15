################################################################################
#   get_name.rb
#     Identifies parameters for the procedure
#
#   10.03.2015   ZT
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
        puts colored(RED, "First argument must be g[enerate] or d[estroy]")
        exit
    end

    if ARGV[1].nil?
      puts colored(RED, "Second argument must be <Model_name>")
      exit
    end

    # Define names
    upper_count = ARGV[1].scan(/\p{Upper}/).count  # Number of uppercase characters

    if upper_count > 1                # Compound name (e.g. RedWineGlass)
      $model  = ARGV[1]
      $models = $model.pluralize
      $name   = ARGV[1][0].downcase
      string  = ARGV[1][1..-1]
      string.chars do |c|
        if c.match(/\p{Upper}/)
          $name << '_' << c.downcase
        else
          $name << c
        end
      end
      $names = $name.pluralize
    else                              # Simple name (e.g. User)
      $model  = ARGV[1].capitalize    # e.g.  City
      $models = $model.pluralize      # e.g.  Cities
      $name   = $model.downcase       # e.g.  city
      $names  = $name.pluralize       # e.g.  cities
#        puts $model; puts $models; puts $name; puts $names
#        exit
    end

    # Enumerated options
    $enum = options[:enum] if options[:enum].size > 0
  end
end