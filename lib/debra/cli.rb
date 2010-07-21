require 'optparse'
require 'ostruct'

module Debra  
  
  DEBFILES = ['Debfile', 'debfile'].freeze
    
  module Cli

    def exec

      options = OpenStruct.new

      OptionParser.new do |opts|

        opts.banner = 'Usage: debra [options]'
        opts.on("-h", "--help", "Show this message") {|h| options.help = h}
        opts.on("-r", "--revision revision", "Append a revision to the file, useful if you are doing CI") {|r| options.revision = r}        
        opts.on("-v", "--verbose", "Run verbosely")  {|v| options.verbose = v}
        opts.on("-ffile", "--file file", String, "Load a specific Debfile")  {|f| options.file = f}
        opts.on("--version", "Show version") do
          puts "Debra " + Debra::VERSION.join('.')
          exit
        end

        begin
          opts.parse!
        rescue OptionParser::MissingArgument,
               OptionParser::InvalidOption,
               OptionParser::InvalidArgument => e
          puts e.message + ', use --help for more details'
          exit 1
        end

        if !options.file.nil? && !File.exists?(options.file)
          puts "Cannot find file #{options.file}"
          exit 1
        end

        if options.help
          puts opts
          exit 1
        end   
           
      end
      
      options.file = options.file || find_debfile
      
      run options
                  
    end

    def find_debfile
      
      DEBFILES.each do |filename|
        file = Dir.pwd + "/#{filename}"
        if File.exists? file
          return file
        end
      end
      
      puts "Cannot find a valid debfile, searched current working directory for #{DEBFILES.join(",")}"
      puts "Please add a valid debfile or use the --file argument"
      exit 1
      
    end    
    
  end
    
end
