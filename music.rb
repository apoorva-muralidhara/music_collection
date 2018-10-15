#!/usr/bin/env ruby

require_relative 'lib/music_collection.rb'

puts
puts "Welcome to your music collection!"

music_collection = MusicCollection.new

puts
print '> '
while line = gets.strip
  break if line == 'quit'

  puts
  print music_collection.response(line)

  puts
  print '> '
end

puts
puts 'Bye!'
puts
