# frozen_string_literal: true

require 'optparse'

class FileLister
  def run
    options = {}
    OptionParser.new do |opts|
      opts.on('-a') { |v| options[:a] = v }
      opts.on('-r') { |v| options[:r] = v }
      opts.on('-l') { |v| options[:l] = v }
    end.parse!

    filenames = get_filenames(options)

    if options[:l]
      DetailedLister.new.list(filenames)
    else
      ThreeColumnFormatter.new.output(filenames)
    end
  end

  private

  def get_filenames(options)
    filenames = options[:a] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    options[:r] ? filenames.reverse : filenames
  end
end
