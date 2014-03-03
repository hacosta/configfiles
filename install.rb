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
            FileUtils.ln_sf(Dir.pwd + "/" + i, new_copy)
        else
            puts "File #{i} exists. Cowardly refusing to overwrite"
        end
    }
	`git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle`
	`vim +BundleInstall +qall`
end

def strip_dashes( str )
    str[/[ -]*(.*)/,1]
end

def usage()
    puts "#{__FILE__} [options]"
    puts
    puts "options:"
    puts "   -f   --force                       overwrite links"
end

ARGV.map! { |arg|
    strip_dashes arg.downcase
}

if ARGV.size == 0
    create_links
elsif ARGV[0] == "f" || ARGV[0] == "force"
    create_links(true)
else
    usage
end
