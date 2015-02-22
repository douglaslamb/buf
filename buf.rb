require 'thor'

class Buf < Thor

	def initialize(*args)
		super
		@buffile = "poop.txt"
	end

	desc "add NOTE [--time optional TIME]", "adds a note to the buffile"
	def add(note)
		File.open(@buffile, "w") do |f2|
			f2.puts note
		end
		
	end

=begin
	private
	def loadconfig
		File.open("poop.txt") do |f|
			f.any? do |line|
				if line.include?("buffile")
					puts line
				end
			end
		end
		#f = File.new("poop.txt", "r")
		#buffile = f.match /^buffile = (.*)/
		#puts "turd"
	end
=end

end

Buf.start(ARGV)

# This app is going to look like this. It's going to have
# a text file that it is going to read and write from.
# There will also be a config file that is loaded every time the
# app is loaded. That config will be call .bufrc and it will
# be in ~/. It will point buf to the default buffer file.
# Buf will be able to do the following
# 1. add a note
# 	when adding a note we will specify a string and a time. both will
# 	be written to the buffile. User can leave time blank and
# 	default time will be used.
# 2. remove a note
# 	The note will be removed from the buffile.
# 3. print notes
# 	The notes will be culled and unexpired notes will be echoed.
# 	We can print without time expirations if we want.
# 4. cull notes
# 	Move expired notes to an archive file.
#
