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

frames = []
shots.each_slice(2) do |s|
  frames << s
end

point = 0

frames[0..9].each_with_index do |frame, index| # 条件分岐を要するフレームの加点処理
  point += frame.sum
  # 連続ストライクの場合、2つ先のフレームの1投目も得点となる
  point += frames[index + 2].first if frame == [10, 0] && frames[index + 1].first == 10
  if frame == [10, 0] # ストライク1回のみの場合
    point += frames[index + 1].sum # 次のフレームの合計値が得点となる
  end
  if frame.sum == 10 && frame != [10, 0] # スペアの場合
    point += frames[index + 1].first # 次のフレームの1投目が得点となる
  end
end

frames[10, 11].each do |frame| # 条件分岐を要しないフレームの加点処理
  point += frame.sum
end

point -= frames[10].sum if frames[10] # 計算結果から余剰加点を除外

if frames[11].nil? # 3投目が存在しなかった場合は得点を表示して終了
  puts point
elsif frames[11] == [10, 0] || frames[9] == [10, 0]
  point -= frames[11].first # 計算結果から余剰加点を除外して得点表示
  puts point
end
