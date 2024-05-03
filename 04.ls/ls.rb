# frozen_string_literal: true

require 'optparse'

COLUMNS = 3

def run
  listed_filenames = option_filenames
  filenames_matrix = slice_filenames(listed_filenames)
  filled_filenames = fill_filenames(filenames_matrix)
  arrange_filenames(filled_filenames)
end

def option_filenames
  params = ARGV.getopts('a', 'r')
  flags = params['a'] ? File::FNM_DOTMATCH : 0
  listing = Dir.glob('*', flags)
  if params['r']
    listing.reverse
  else
    listing
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
