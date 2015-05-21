#!/usr/bin/env ruby
#

# rubygems
require 'rubygems'

# libs
require 'thor'
require 'fileutils'
require 'tempfile'

class Buf < Thor

  def initialize(*args)
    super
    dotfile = File.expand_path('~/.bufrc')
    check_dotfile(dotfile)
    read_dotfile(dotfile)
    check_files
  end

  no_commands do
    def check_files
      unless File.file?(@buffile)
        unless File.directory?(File.dirname(@buffile))
          FileUtils.mkdir_p(File.dirname(@buffile))
        end
        File.open(@buffile, 'w') do
        end
      end
      unless File.file?(@archivefile)
        unless File.directory?(File.dirname(@archivefile))
          FileUtils.mkdir_p(File.dirname(@archivefile))
        end
        File.open(@archivefile, 'w') do
        end
      end
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
      File.foreach(dotfile).with_index do |line, line_num|
        line = line.chomp
        line_array = line.split
        if (line[0] != '#')
          if (line_array.length == 4 &&
              line_array[0] == 'set' &&
              line_array[2] == '=' &&
              (line_array[1] == 'buffile' || line_array[1] == 'archivefile'))
                if line_array[1] == 'buffile'
                  @buffile = File.expand_path(line_array[3])
                else
                  @archivefile = File.expand_path(line_array[3])
                end
          else 
            raise "Error in .bufrc line #{line_num}"
          end
        end
      end
    end

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
