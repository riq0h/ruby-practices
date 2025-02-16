# frozen_string_literal: true

require_relative 'game'

score = ARGV[0]
if score.nil? || score.empty?
  puts "Usage: ruby bowling.rb 'X,X,X,X,X,X,X,X,X,X,X,X'"
else
  game = Game.new(score)
  puts game.calculate_score
end
