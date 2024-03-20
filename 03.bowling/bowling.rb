#!/usr/bin/ruby
# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = shots.each_slice(2).to_a

point = 0
strike = [10, 0]

frames[0..8].each_with_index do |frame, index|
  point += frame.sum
  # 連続ストライクの場合、2つ先のフレームの1投目も得点となる
  point += frames[index + 2].first if frame == strike && frames[index + 1] == strike
  point += frames[index + 1].sum if frame == strike
  point += frames[index + 1].first if frame.sum == 10 && frame != strike
end

frames[9..11].map { |frame| point += frame.sum } # 条件分岐を要しない加点処理

puts point
