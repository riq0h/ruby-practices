# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMNS = 3
MARGIN = 3

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
  params = ARGV.getopts('a', 'r', 'l')
  filenames = params['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  filenames = filenames.reverse if params['r']
  params['l'] ? output_l(filenames) : output(filenames)
end

def output(filenames)
  rows = (filenames.size / COLUMNS)
  length_limits = limiter(filenames, rows)
  (0...rows).each do |row|
    COLUMNS.times do |column|
      index = row + column * rows
      print filenames[index].ljust(length_limits[column] + COLUMNS) if filenames[index]
    end
    puts
  end
end

def limiter(filenames, rows)
  filenames.each_slice(rows).map { _1.map(&:length).max }
end

def output_l(filenames)
  fileblock(filenames)
  filenames.each do |file|
    file_stat = File::Stat.new(file)
    print TYPES[file_stat.ftype]
    filemod(file_stat)
    print_ownerinfo(file_stat, filenames)
    timestamp(file_stat)
    print_symbolic(file)
    puts
  end
end

def print_ownerinfo(file_stat, filenames)
  print " #{file_stat.nlink}"
  print " #{Etc.getpwuid(file_stat.uid).name}"
  print " #{Etc.getgrgid(file_stat.gid).name}"
  print " #{file_stat.size}".rjust(filesize(filenames))
end

def print_symbolic(filenames)
  if File.lstat(filenames).symlink?
    print " #{filenames} -> #{File.readlink(filenames)}"
  else
    print " #{filenames}"
  end
end

def filemod(file_stat)
  file_count = file_stat.mode.to_s(8).slice(-3, 3)
  file_permission = file_count.split('').map do |file|
    PERMISSIONS[file]
  end
  print file_permission.join('')
end

def filesize(filenames)
  filenames.map { |file| File.size(file) }.max.to_s.length + MARGIN
end

def timestamp(file_stat)
  print file_stat.mtime.strftime('%_m月 %_d %H:%M')
end

def fileblock(filenames)
  blocks = filenames.map do |file|
    File::Stat.new(file).blocks
  end
  puts "total #{blocks.sum}"
end

run
