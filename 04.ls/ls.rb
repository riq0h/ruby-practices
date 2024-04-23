# frozen_string_literal: true

COLUMNS = 3

def run
  listed_string = list_string
  string_matrix = slice_string(listed_string)
  filled_string = fill_string(string_matrix)
  arrange_string(filled_string)
end

def list_string
  Dir.glob('*')
end

def slice_string(listed_string)
  columns_size = listed_string.size.ceildiv(COLUMNS)
  listed_string.each_slice(columns_size).to_a
end

def fill_string(string_matrix)
  array_size = string_matrix.map(&:size).max
  string_matrix.each do |slice|
    slice << '' while slice.size < array_size
  end
  string_matrix.transpose
end

def arrange_string(filled_string)
  string_count = filled_string.flatten.map(&:size).max
  filled_string.each do |arrange|
    arrange.each do |arranged|
      print arranged.ljust(string_count + 5)
    end
    puts
  end
end

run
