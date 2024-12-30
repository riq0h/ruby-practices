# frozen_string_literal: true

require_relative 'file_info'
require_relative 'constants'

class DetailedLister
  def list(filenames)
    puts total_file_blocks(filenames)
    filenames.each do |filename|
      puts FileInfo.new(filename).details
    end
  end

  private

  def total_file_blocks(filenames)
    blocks = filenames.map { |file| File::Stat.new(file).blocks }
    "total #{blocks.sum}"
  end
end
