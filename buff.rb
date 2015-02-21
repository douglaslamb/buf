require 'rubygems'
require 'commander/import'

program :name, 'Buff'
program :version, '0.0.1'
program :description, 'Short-term memory substitute'

b = '';

command :init do |c|
	c.syntax = 'buff init nameOfBuffer file'
	c.description = 'loads text file into a Buffer'
	c.action do |args, options|
		if args.second.nil?
			b = Buffer.new(args.first)
		else
			b = Buffer.new(args.first, args.second)
	end
end

command :close do |c|
	c.syntax = 'buff close nameOfBuffer'
	c.description = 'close a Buffer to editing'
	c.action do |args, options|
		
	end
end

command :save do |c|
	c.syntax = 'writer Buffer to file'
	c.description = 

command :add do |c|
	c.syntax = 'buff add'
	c.description = 'add a note'
	c.action do |args, options|
		b.add(args.first, args.second)

