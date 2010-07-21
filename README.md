# Debra: Make Debian packages with Ruby

## Why?

Because I found the process of making Debian packages a little long winded. It does seem to work well for my use case: building binary packages of web applications on a CI server.

Also, I'm still learning the Debian packaging system so wouldn't recommend this for serious use, just your own packages.

## How?

Install 

	$: sudo gem install debra
	
Create a Debfile in your projects directory

	# Debfile
	Debra do
	
		# Specify the files to be included (just a Rake::FileList delegate)
		files "etc/**/*"

		# Specify your control file fields
		# See http://www.debian.org/doc/debian-policy/ch-controlfields.html
		control do 
		    package       "my-package"
		    version       "0.1"
		    section       "base"
		    priority      "optional"
		    architecture  "all"
		    depends       "apache2, apache2-dev"
		    maintainer    "My Name <me@example.com>"
		    description   %q{My Pacakge Title
				Extended description goes here ...
			} 
		end
		
		# Specify preinst, postinst, prerm, postrm files like this
		postinst %q{#!/bin/bash			
			
	service apache restart
						
		}

	end
	
Build your file 

	$: sudo debra

## Command line options

	Usage: debra [options]
	    -h, --help                       Show this message
	    -v, --verbose                    Run verbosely
	    -f, --file file                  Load a specific Debfile
	        --version                    Show version

## Examples

See the examples directory

## License

(GPLv3)

Copyright (C) 2009 Matt Haynes

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see <w
