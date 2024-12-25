# frozen_string_literal: true

require_relative 'constants'

class OutputFormatter
  include Constants

  def output(filenames)
    rows = filenames.size.ceildiv(COLUMNS)
    pads = pad_created(filenames, rows)
    (0...rows).each do |row|
      COLUMNS.times do |column|
        index = row + column * rows
        print filenames[index].ljust(pads[column] + COLUMNS) if filenames[index]
      end
      puts
    end
  end

  private

  def pad_created(filenames, rows)
    filenames.each_slice(rows).map { _1.map(&:length).max }
  end
end
