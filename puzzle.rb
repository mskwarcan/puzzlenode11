require 'rubygems'
require 'pry'
require 'bundler'
Bundler.setup

require 'sinatra'

get "/" do
  lines = read_file("public/complex_cave.txt")
  amount = lines.shift.to_i

  #remove_ceiling
  lines.shift
  
  fill_cave(lines, amount)

  water = water_in_column(lines)
  
  @graphic = lines
  @total = water
  erb :total
end

def read_file(file)
  lines = []
  File.open(file).each do |line|
    lines << line.chomp unless line.chomp.empty?
  end
  lines
end

def fill_cave(cave, water)
  location = [0,0]
  water.times do |x|
    location = next_location(cave, location)
    cave[location[0]][location[1]] = "~"
  end
  cave
end

def next_location(cave, location)
  if cave[location[0] +1][location[1]] == "#" || cave[location[0] +1][location[1]] == "~"
    if cave[location[0]][location[1] +1] == "#" || cave[location[0]][location[1] +1] == "~"
      [location[0]-1, cave[location[0]-1].index(" ")]
    else
      [location[0], location[1]+1]
    end
  else
    [location[0]+1, location[1]]
  end
end

def water_in_column(lines)
  water = Array.new(lines.first.size, 0)

  lines.each do |row|
    row.size.times do |x|
      if row[x] == "~"
        water[x] = water[x] + 1
      end
      if row[x] == " " && water[x] != 0
        water[x] = "~"
      end
    end
  end
  water
end
