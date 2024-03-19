#!/usr/bin/ruby
# frozen_string_literal: true

require 'date'
require 'optparse'

year = Date.today.year
month = Date.today.month
week = %w[日 月 火 水 木 金 土]

opt = OptionParser.new
opt.on('-m month') { |v| month = v.to_i }
opt.on('-y year') { |v| year = v.to_i }
opt.parse(ARGV)

first_day = Date.new(year, month, 1)
last_day = Date.new(year, month, -1)
puts "#{month.to_s.rjust(7)}月\s#{year}"
puts week.join(' ')
print "\s\s\s" * first_day.wday

(first_day..last_day).each do |date|
  day_string = date.day.to_s.rjust(2, "\s")
  day_string = "\e[7m#{day_string}\e[0m" if date == Date.today
  print day_string
  print "\s"
  puts if date.saturday?
end
puts
