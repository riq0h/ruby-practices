# frozen_string_literal: true

require 'etc'
require_relative 'constants'

class FileInfo
  def initialize(filename)
    @filename = filename
    @stat = File::Stat.new(filename)
  end

  def details
    [
      type,
      mode,
      owner_info,
      time_stamp,
      symbolic
    ].join
  end

  def blocks
    @stat.blocks
  end

  private

  def type
    Constants::TYPES[@stat.ftype]
  end

  def mode
    file_count = @stat.mode.to_s(8).slice(-3, 3)
    file_count.split('').map { |f| Constants::PERMISSIONS[f] }.join
  end

  def owner_info
    [
      @stat.nlink.to_s.rjust(2),
      Etc.getpwuid(@stat.uid).name.ljust(8),
      Etc.getgrgid(@stat.gid).name.ljust(8),
      @stat.size.to_s.rjust(8),
      ''
    ].join(' ')
  end

  def time_stamp
    @stat.mtime.strftime(' %_m月 %_d %H:%M')
  end

  def symbolic
    if File.lstat(@filename).symlink?
      " #{@filename} -> #{File.readlink(@filename)}"
    else
      " #{@filename}"
    end
  end
end
