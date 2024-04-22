# frozen_string_literal: true

COLUMNS = 3
files = []

def run(files)
  served_files = serve_files(files)
  sliced_files = slice_files(served_files)
  filled_files = fill_files(sliced_files)
  arrange_files(filled_files)
end

def serve_files(_files)
  Dir.glob('*')
end

def slice_files(served_files)
  columns_size = served_files.size.ceildiv(COLUMNS)
  served_files.each_slice(columns_size).to_a
end

def fill_files(sliced_files)
  array_size = sliced_files.map(&:size).max
  sliced_files.each do |slice|
    slice << '' while slice.size < array_size
  end
  sliced_files.transpose
end

def arrange_files(filled_files)
  string_count = filled_files.flatten.map(&:size).max
  filled_files.each do |arrange|
    arrange.each do |arranged|
      print arranged.ljust(string_count + 5)
    end
    puts
  end
end

run(files)
