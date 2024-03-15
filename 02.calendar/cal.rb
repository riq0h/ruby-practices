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
  print "#{date.day.to_s.rjust(2)}\s"
  date += 1
  print "\n" if date.sunday?
  if date == Date.today && ARGV == [] # 引数なしなら現在日をハイライトする
    print "\e[7m\e[7m"
  else
    print "\e[0m"
  end
end
