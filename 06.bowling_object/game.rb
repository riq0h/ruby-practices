# frozen_string_literal: true

require_relative 'frame'
require_relative 'shot'

class Game
  def initialize(score_string)
    scores = score_string.split(',')
    shot = Shot.new(scores)
    shots = shot.convert_to_shots
    @frames = Frame.create_frames(shots)
  end

  def calculate_score
    @frames[0..8].each_with_index.sum do |frame, index|
      frame.score(@frames[index + 1], @frames[index + 2])
    end + @frames[9..11].sum { |frame| frame.shots.sum }
  end
end
