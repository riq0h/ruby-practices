# frozen_string_literal: true

require 'etc'
require_relative 'constants'

class FileInfo
  include Constants

  def file_details(file, filenames)
    file_stat = File::Stat.new(file)
    [
      TYPES[file_stat.ftype],
      file_mode(file_stat),
      owner_info(file_stat, filenames),
      time_stamp(file_stat),
      symbolic(file)
    ].join
  end

  def total_file_blocks(filenames)
    blocks = filenames.map { |file| File::Stat.new(file).blocks }
    "total #{blocks.sum}"
  end

  private

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
    file_permission = file_count.split('').map { |file| PERMISSIONS[file] }
    file_permission.join('')
  end

  def max_filename_length(filenames)
    filenames.map { |file| File.size(file) }.max.to_s.length + MARGIN
  end

  def time_stamp(file_stat)
    file_stat.mtime.strftime(' %_m月 %_d %H:%M')
  end
end
