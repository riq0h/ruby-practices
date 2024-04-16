# frozen_string_literal: true

COLUMNS = 3
files = []

def run(files)
  served = serve(files)
  sliced = slice(served)
  filled = fill(sliced)
  arranged(filled)
end

def serve(files)
  files.concat(Dir.glob('*'))
end

def slice(served)
  element = if (served.size % COLUMNS).zero?
              served.size / COLUMNS
            else
              served.size / COLUMNS + 1
            end
  served.each_slice(element).to_a
end

def fill(sliced)
  array_size = sliced.map(&:size).max
  sliced.each do |slice|
    slice << '' while slice.size < array_size
  end
  sliced.transpose
end

def arranged(filled)
  element2 = filled.flatten.map(&:size).max
  filled.each do |arrange|
    arrange.each do |arranged|
      print arranged.ljust(element2 + 5)
    end
    puts
  end
end

run(files)
