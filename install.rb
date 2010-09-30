#!/usr/bin/env ruby

require 'fileutils'


FORCE_OVERWRITE=false
EXCEPTIONS=[ "README", "install.rb" ]


#TODO
#receives a folder.
#receives an option {}
def create_links( overwrite=FORCE_OVERWRITE )
    Dir.glob("*").each { |i|
        new_copy = "#{ENV['HOME']}/.#{i}"
        next if EXCEPTIONS.include? i
        if overwrite || ! File.exist?(new_copy) 
            FileUtils::DryRun.ln_sf(Dir.pwd + "/" + i, new_copy)
        else
            puts "File #{i} exists. Cowardly refusing to overwrite"
        end
    }
end

def strip_dashes( str )
    str[/[ -]*(.*)/,1]
end

ARGV.map! { |arg|
    strip_dashes arg.downcase
}

def usage()
    puts "#{__FILE__} [options]"
    puts
    puts "options:"
    puts "   -f   --force                       overwrite links"
end


if ARGV.size == 0
    create_links
elsif ARGV[0] == "f" || ARGV[0] == "force"
    create_links(true)
else
    usage
end
