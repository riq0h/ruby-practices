# frozen_string_literal: true

class Shot
  def self.convert_to_shots(scores)
    scores.flat_map do |s|
      if s == 'X'
        [10, 0]
      else
        [s.to_i]
      end
    end
  end
end
