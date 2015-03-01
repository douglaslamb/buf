require 'thor'

class Buf < Thor

  def initialize(*args)
    super
    @buffile = "foo.txt"
    @archivefile = "foo.txt.archive"
  end

  desc "wr NOTE TIME", "appends note to buffile with the expiration time appended"
  # this method needs to add a string and a time to the top line of the 
  # file and it needs to be able to deduce the time
  def wr(note, hours)
    t = Time.now + 60 * 60 * hours.to_i
    File.open(@buffile, "r") do |orig|
      File.unlink(@buffile)
      File.open(@buffile, "w") do |new|
        new.write("#{note} #{t.strftime("%Y%m%d-%H%M%S")}")
        new.write("\n")
        new.write(orig.read)
      end
    end
  end

  desc "cull", "moves expired notes to archive file"
  def cull
    now = Time.now
    buf = File.open(@buffile, "r")

    buf.each do |line|
      date = (line.split)[-1]
      date = Time.new(date[0..3], date[4..5], date[6..7], date[9..10], date[11..12], date[13..14])
      if ((date <=> now) == -1)
        # write to archive
        File.open(@archivefile, "r") do |origArch|
          File.unlink(@archivefile)
          File.open(@archivefile, "w") do |newArch|
            newArch.write(line)
            newArch.write("\n")
            newArch.write(origArch.read)
          end
        end
        # delete line from buffile. that's up next
      end
    end
  end
      
  desc "echo", "prints unexpired notes"
  def echo
    now = Time.now
    f = File.open(@buffile, "r")
    f.each do |line|
      date = (line.split)[-1]
      date = Time.new(date[0..3], date[4..5], date[6..7], date[9..10], date[11..12], date[13..14])
      if ((date <=> now) == 1)
        puts line
      end
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
		#f = File.open("poop.txt", "r")
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
