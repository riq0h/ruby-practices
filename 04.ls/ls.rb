# frozen_string_literal: true

require 'optparse'
opt = OptionParser.new
params = {}
opt.on('-a') { |x| params[:a] = x }
opt.parse(ARGV)

COLUMNS = 3

def run
  listed_filenames = list_filenames
  filenames_matrix = slice_filenames(listed_filenames)
  filled_filenames = fill_filenames(filenames_matrix)
  arrange_filenames(filled_filenames)
end

def list_filenames
  if ARGV[0]
    Dir.glob('*', File::FNM_DOTMATCH)
  else
    Dir.glob('*')
  end
end

def slice_filenames(listed_filenames)
  columns_size = listed_filenames.size.ceildiv(COLUMNS)
  listed_filenames.each_slice(columns_size).to_a
end

def fill_filenames(filenames_matrix)
  array_size = filenames_matrix.map(&:size).max
  filenames_matrix.each do |slice|
    slice << '' while slice.size < array_size
  end
  filenames_matrix.transpose
end

def arrange_filenames(filled_filenames)
  filenames_count = filled_filenames.flatten.map(&:size).max
  filled_filenames.each do |arrange|
    arrange.each do |arranged|
      print arranged.ljust(filenames_count + 5)
    end
    puts
  end
end

run
