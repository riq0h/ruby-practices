# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def self.create_frames(shots)
    shots.each_slice(2).map { |frame_shots| new(frame_shots) }
  end

  def score(next_frame = nil, after_next_frame = nil)
    @shots.sum + bonus_score(next_frame, after_next_frame)
  end

  def strike?
    @shots == [10, 0]
  end

  def spare?
    @shots.sum == 10 && !strike?
  end

  private

  def bonus_score(next_frame, after_next_frame)
    if strike?
      strike_bonus(next_frame, after_next_frame)
    elsif spare?
      spare_bonus(next_frame)
    else
      0
    end
  end

  def strike_bonus(next_frame, after_next_frame)
    if next_frame.strike?
      next_frame.shots.first + second_bonus_ball(next_frame, after_next_frame)
    else
      next_frame.shots.sum
    end
  end

  def second_bonus_ball(next_frame, after_next_frame)
    if after_next_frame
      after_next_frame.shots.first
    else
      next_frame.shots.last
    end
  end

  def spare_bonus(next_frame)
    next_frame.shots.first
  end
end
