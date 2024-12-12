# frozen_string_literal: true

require_relative 'frame'
require_relative 'shot'

class Game
  def initialize(score_string)
    @scores = score_string.split(',')
    @shots = Shot.convert_to_shots(@scores)
    @frames = Frame.create_frames(@shots)
  end

  def calculate_score
    point = 0
    @frames[0..8].each_with_index do |frame, index|
      point += Frame.frame_score(frame, index, @frames)
    end
    point += @frames[9..11].flatten.sum
    point
  end
end
