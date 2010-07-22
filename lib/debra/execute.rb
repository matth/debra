module Debra

  module Execute
    
    def run(options)
      
      @@options  = options
      @@control  = {}
      @@files    = []
      @@generate = {}
      
      puts "Loading #{options.file}" if options.verbose
      load_file

      puts "Creating temp files" if options.verbose
      tmp_dir = "/tmp/debra_" + Process.pid.to_s
      
      Dir.mkdir tmp_dir
      Dir.mkdir tmp_dir + "/DEBIAN"
      
      if @@options.revision != nil
        @@control[:version] = @@control[:version] + "-" + @@options.revision
      end
      
      write tmp_dir + "/DEBIAN/control", generate_control_text

      @@generate.each_pair do |name, contents|
        write tmp_dir + "/DEBIAN/#{name.to_s}", contents
        File.chmod 0755, tmp_dir + "/DEBIAN/#{name.to_s}"
      end
      
      @@files.resolve.each do |file|
        if File.directory?(file)
          FileUtils.mkdir_p  tmp_dir + "/" + file
        else
          FileUtils.cp file, tmp_dir + "/" + file
        end
      end
      
      puts "Generating debian package" if options.verbose      
      `dpkg --build #{tmp_dir} #{package_name}`
      
      if $? != 0 
        puts "Error running dpkg, exiting"
        FileUtils.rm_rf tmp_dir        
        exit 1
      end
            
      puts "Removing temp files" if options.verbose            
      FileUtils.rm_rf tmp_dir
      
      puts "Created package: #{package_name}" 
      
    end
    
    def package_name
      "#{@@control[:package]}-#{@@control[:version]}-#{@@control[:architecture]}.deb"
    end
    
    def write(file, str)
      file = File.new(file, "w")
      file.write(str + "\n")
      file.close
    end

    def method_missing(sym, *args)
      @@control[sym] = args[0]      
    end
    
    def files(*args, &block)
      @@files = Rake::FileList.new *args, &block
    end
    
    def generate_control_text
      @@control.to_a.map do |item|
        key = item[0].to_s.split("_").map{|v| v.capitalize}.join("-")
        "#{key}: #{item[1]}"
      end.join("\n")      
    end

    def control
      yield
    end
    
    [:preinst, :postinst, :prerm, :postrm].each do |method|
      class_eval <<-EVAL
        def #{method.to_s}(str)
          @@generate[:#{method.to_s}] = str
        end
      EVAL
    end
    
    def load_file
      class_eval "load '#{@@options.file}'"
    end
    
  end

end
