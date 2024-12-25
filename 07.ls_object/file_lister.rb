# frozen_string_literal: true

require 'optparse'
require_relative 'output_formatter'
require_relative 'file_info'

class FileLister
  def initialize
    @formatter = OutputFormatter.new
    @file_info = FileInfo.new
  end

  def run
    params = ARGV.getopts('a', 'r', 'l')
    filenames = get_filenames(params)
    params['l'] ? output_file_details(filenames) : output(filenames)
  end

  private

  def get_filenames(params)
    filenames = params['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    params['r'] ? filenames.reverse : filenames
  end

  def output(filenames)
    @formatter.output(filenames)
  end

  def output_file_details(filenames)
    puts @file_info.total_file_blocks(filenames)
    filenames.each do |file|
      puts @file_info.file_details(file, filenames)
    end
  end
end
