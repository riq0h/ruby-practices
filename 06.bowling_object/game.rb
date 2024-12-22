# frozen_string_literal: true

require_relative 'frame'
require_relative 'shot'

class Game
  def initialize(score_string)
    scores = score_string.split(',')
    shots = Shot.convert_to_shots(scores)
    @frames = Frame.create_frames(shots)
  end

  def calculate_score
    point = 0
    @frames[0..8].each_with_index do |frame, index|
      point += frame.score(@frames[index + 1], @frames[index + 2])
    end
    point + @frames[9..11].sum { |frame| frame.shots.sum }
  end
end
