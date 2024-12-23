# frozen_string_literal: true

class Shot
  def initialize(scores)
    @scores = scores
  end

  def convert_to_shots
    @scores.flat_map do |s|
      if s == 'X'
        [10, 0]
      else
        [s.to_i]
      end
    end
  end
end
