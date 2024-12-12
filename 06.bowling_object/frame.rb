# frozen_string_literal: true

class Frame
  def self.create_frames(shots)
    shots.each_slice(2).to_a
  end

  def self.frame_score(frame, index, frames)
    score = frame.sum
    if strike?(frame)
      score += strike_bonus(index, frames)
    elsif spare?(frame)
      score += spare_bonus(index, frames)
    end
    score
  end

  def self.strike?(frame)
    frame == [10, 0]
  end

  def self.spare?(frame)
    frame.sum == 10 && !strike?(frame)
  end

  def self.strike_bonus(index, frames)
    if strike?(frames[index + 1])
      frames[index + 1].sum + frames[index + 2].first
    else
      frames[index + 1].sum
    end
  end

  def self.spare_bonus(index, frames)
    frames[index + 1].first
  end
end
