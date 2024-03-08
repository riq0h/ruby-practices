#!/usr/bin/ruby
require 'date'
require 'optparse'

## 年月の初期設定（現在の年月）
year = Date.today.year
month = Date.today.month

## コマンドラインオプション指定で年月を置き換える
opt = OptionParser.new
opt.on('-m month') { |v| month = v.to_i }
opt.on('-y year') { |v| year = v.to_i }
opt.parse(ARGV)

## 月初日の曜日、当該月の総日数、週の配列
startwday = Date.new(year, month, 1).wday
totaldate = Date.new(year, month, -1).day
week = %w[日 月 火 水 木 金 土]

## カレンダーを出力する
puts month.to_s.rjust(8) + '月 ' + year.to_s
puts week.join(' ')
print '   ' * startwday
days = startwday
(1..totaldate).each do |day|
  print day.to_s.rjust(2) + ' '
  days += 1
  print "\n" if days % 7 == 0
  if day == Date.today.day - 1 && ARGV == []
    print "\e[30m\e[47m"
  else
    print "\e[0m"
  end
end
