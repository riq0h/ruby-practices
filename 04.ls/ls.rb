# frozen_string_literal: true
# lsコマンド5

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
  params['l'] ? output_file_datails(filenames) : output(filenames)
end

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

def pad_created(filenames, rows)
  filenames.each_slice(rows).map { _1.map(&:length).max }
end

def output_file_datails(filenames)
  puts total_file_blocks(filenames)
  filenames.each do |file|
    file_stat = File::Stat.new(file)
    print TYPES[file_stat.ftype]
    print file_mode(file_stat)
    print owner_info(file_stat, filenames)
    print time_stamp(file_stat)
    print symbolic(file)
    puts
  end
end

def owner_info(file_stat, filenames)
  [
    file_stat.nlink.to_s.prepend(' '),
    Etc.getpwuid(file_stat.uid).name,
    Etc.getgrgid(file_stat.gid).name,
    file_stat.size.to_s.rjust(max_filename_length(filenames))
  ].join(' ')
end

def symbolic(filenames)
  if File.lstat(filenames).symlink?
    " #{filenames} -> #{File.readlink(filenames)}"
  else
    " #{filenames}"
  end
end

def file_mode(file_stat)
  file_count = file_stat.mode.to_s(8).slice(-3, 3)
  file_permission = file_count.split('').map do |file|
    PERMISSIONS[file]
  end
  file_permission.join('')
end

def max_filename_length(filenames)
  filenames.map { |file| File.size(file) }.max.to_s.length + MARGIN
end

def time_stamp(file_stat)
  file_stat.mtime.strftime('%_m月 %_d %H:%M')
end

def total_file_blocks(filenames)
  blocks = filenames.map do |file|
    File::Stat.new(file).blocks
  end
  "total #{blocks.sum}"
end

run
