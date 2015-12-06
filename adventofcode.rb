#!/usr/bin/env ruby

require 'pathname'
require 'digest/md5'

def input(set)
  dir = Pathname.new(File.dirname(File.expand_path(__FILE__)))
  File.open(dir.join("input#{set}.txt"), "r").read.strip
end

def output(set, value)
  puts "  result #{set} => #{value}"
end

module Enumerable
  def sum
    inject{ |s,x| s + x }
  end
end

puts "adventofcode"

################################################################################
# Day 4

def md5_starting_with(problem, input, starting_with)
  int = 0
  result = nil
  while result.nil?
    if result = Digest::MD5.hexdigest("#{input}#{int}").match(/^#{starting_with}/)
      output(problem, int)
    end
    int = int + 1
  end
end

md5_starting_with(4.1, input(4), "00000")
md5_starting_with(4.2, input(4), "000000")

################################################################################
# Day 3

class House
  attr_accessor :x, :y
  def initialize(x, y)
    @x, @y = x, y
  end
  def neighbor(i)
    case i
    when ">"
      House.new(x+1, y)
    when "<"
      House.new(x-1, y)
    when "^"
      House.new(x, y+1)
    when "v"
      House.new(x, y-1)
    else
      raise "invalid direction"
    end
  end
  def to_a
    [ x, y ]
  end
  def hash
    to_a.hash
  end
  def eql?(other)
    hash.eql?(other.hash)
  end
end

instructions = input(3).split(//)

house = House.new(0, 0)
houses = [ house ]
instructions.each do |i|
  houses << house = house.neighbor(i)
end
output(3.1, houses.uniq.size)

santa = House.new(0, 0)
robosanta = House.new(0, 0)
houses = [ santa, robosanta ]
while instructions.size > 0
  houses << santa = santa.neighbor(instructions.shift)
  houses << robosanta = robosanta.neighbor(instructions.shift)
end
output(3.2, houses.uniq.size)

################################################################################
# Day 2

class Package
  attr_reader :l, :w, :h
  def initialize(d)
    @l, @w, @h = *d.split("x").map(&:to_i)
  end
  def paper
    2*l*w + 2*w*h + 2*h*l + [ l*w, w*h, h*l ].min
  end
  def ribbon
    [ 2*l+2*w, 2*w+2*h, 2*h+2*l ].min + l*w*h
  end
end

packages = input(2).split("\n").map{ |d| Package.new(d) }

output(2.1, packages.map{ |p| p.paper }.sum)
output(2.2, packages.map{ |p| p.ribbon }.sum)

################################################################################
# Day 1

instructions = input(1).bytes.map{ |x| x == 40 ? 1 : -1 }

output(1.1, instructions.sum)

c = 0
instructions.each_with_index do |op, index|
  if (c = c + op) == -1
    output(1.2, index + 1)
    break
  end
end

true