require "debra/cli"
require "debra/execute"
require 'rubygems'
require 'rake'

module Debra
  
  include Cli
  include Execute  
  
  VERSION  = [0,0,3] 
     
  module_function :exec, :find_debfile, :run, :load_file
  
end

def Debra
  include Debra
  yield
end


