#!/usr/bin/env ruby
#
# next thing i'm doing is making this thing work with two dotfiles instead of my foo.txt
# and foo.txt.archive

# rubygems
require 'rubygems'

# libs
require 'thor'
require 'fileutils'
require 'tempfile'

class Buf < Thor

  def initialize(*args)
    super
    # 1. create ~/.bufrc if it does not exist 
    check_dotfile('~/.bufrc')

    # 2. read the config file
    read_dotfile('~/.bufrc')

    @buffile = "/users/rocker/buf/lib/foo.txt"
    @archivefile = "/users/rocker/buf/lib/foo.txt.archive"
  end

  def check_dotfile(dotfile)
    unless File.file?(dotfile)
      File.open(dotfile, 'a') do |f|
        f << "set buffile = ~/buffile.txt\n"
        f << "set archivefile = ~/buffile.txt.archive"
      end
    end
  end

  def read_dotfile(dotfile)
    IO.foreach(dotfile) do |line|
      line = line.chomp
      if (line[0] != '#')
        line = line.split
        if (line.length == 4 &&
            line[0] == 'set' &&
            line[2] == '=' &&
            # I'm working here. I don't know what to do. I need
            # to um like. get this conditional right and read or write the 
            # right file

           

        


  end

  desc "wr NOTE TIME", "appends note to buffile with the expiration time appended"
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
    temp = Tempfile.new("tempbaby")

    buf.each do |line|
      date = (line.split)[-1]
      date = Time.new(date[0..3], date[4..5], date[6..7], date[9..10], date[11..12], date[13..14])
      if ((date <=> now) == -1)
        # write to archive
        File.open(@archivefile, "r") do |origArch|
          File.unlink(@archivefile)
          File.open(@archivefile, "w") do |newArch|
            newArch.write(line)
            newArch.write(origArch.read)
          end
        end
      else 
        temp << line
      end
    end
    temp.close
    FileUtils.mv(temp.path, @buffile)
  end
      
  desc "echo", "prints unexpired notes"
  def echo
    cull
    now = Time.now
    f = File.open(@buffile, "r")
    count = 1
    f.each do |line|
      date = (line.split)[-1]
      date = Time.new(date[0..3], date[4..5], date[6..7], date[9..10], date[11..12], date[13..14])
      time_string = [60, 60, 24].inject([date - now]) { |m, o| m.unshift(m.shift.divmod(o)).flatten }
      time_string = time_string[0..2].join(":")
      puts "#{count}. #{(line.split)[0..-2].join(" ")} #{time_string}"
      count+= 1
    end
  end
end

Buf.start(ARGV)
