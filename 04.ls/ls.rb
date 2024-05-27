# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMNS = 3
MARGINS = 3

TYPES = {
  'fifo' => 'p',
  'characterSpecial' => 'c',
  'directory' => 'd',
  'blockSpecial' => 'b',
  'file' => '-',
  'link' => 'l',
  'socket' => 's'
}.freeze

PERMISSIONS = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

def run
  listed_filenames = list_filenames
  filenames_matrix = slice_filenames(listed_filenames)
  filled_filenames = fill_filenames(filenames_matrix)
  arrange_filenames(filled_filenames)
end

def list_filenames
  params = ARGV.getopts('a', 'r', 'l')
  filenames = params['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  filenames = filenames.reverse if params['r']
  if params['l']
    outputs(filenames)
    exit
  else
    filenames
  end
end

def outputs(filenames)
  fileblocks(filenames)
  filenames.each do |file|
    file_stat = File::Stat.new(file)
    print TYPES[file_stat.ftype]
    filemods(file_stat)
    prints(file_stat, filenames)
    timestamps(file_stat)
    symbolics(file)
    puts
  end
end

def prints(file_stat, filenames)
  print " #{file_stat.nlink}"
  print " #{Etc.getpwuid(file_stat.uid).name}"
  print " #{Etc.getgrgid(file_stat.gid).name}"
  print " #{file_stat.size}".rjust(filesizes(filenames))
end

def symbolics(filenames)
  if File.lstat(filenames).symlink?
    print " #{filenames} -> #{File.readlink(filenames)}"
  else
    print " #{filenames}"
  end
end

def filemods(file_stat)
  file_count = file_stat.mode.to_s(8).slice(-3, 3)
  file_permission = file_count.split('').map do |file|
    PERMISSIONS[file]
  end
  print file_permission.join('')
end

def filesizes(filenames)
  filenames.map { |file| File.size(file) }.max.to_s.length + MARGIN
end

def timestamps(file_stat)
  print file_stat.mtime.strftime('%_m月 %_d %H:%M')
end

def fileblocks(filenames)
  blocks = filenames.map do |file|
    File::Stat.new(file).blocks
  end
  puts "total #{blocks.sum}"
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
