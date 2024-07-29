# frozen_string_literal: true

require 'optparse'

def main
  options, filenames = parse_options
  file_stats = collect_file_stats(filenames)
  total_stats = calculate_total_stats(file_stats)
  max_widths = calculate_max_widths(total_stats)
  print_file_stats(file_stats, max_widths, options)
  print_file_stats([total_stats], max_widths, options) if filenames.size > 1
end

def parse_options
  options = {}
  OptionParser.new do |opts|
    opts.on('-l') { options[:lines] = true }
    opts.on('-w') { options[:words] = true }
    opts.on('-c') { options[:bytes] = true }
  end.parse!
  options = { bytes: true, lines: true, words: true } if options.empty?
  filenames = ARGV.empty? ? [''] : ARGV
  [options, filenames]
end

def collect_file_stats(filenames)
  filenames.map do |filename|
    input = filename.empty? ? ARGF.read : File.read(filename)
    { filenames: filename, lines: input.lines.count, words: input.split.size, bytes: input.bytesize }
  end
end

def calculate_total_stats(file_stats)
  total_stats = { filenames: '合計', lines: 0, words: 0, bytes: 0 }
  file_stats.each do |stats|
    total_stats[:lines] += stats[:lines]
    total_stats[:words] += stats[:words]
    total_stats[:bytes] += stats[:bytes]
  end
  total_stats
end

def calculate_max_widths(total_stats)
  %i[lines words bytes].each_with_object({}) do |key, max_widths|
    max_widths[key] = total_stats[key].to_s.length
  end
end

def format_result(stats, max_widths, options)
  %i[lines words bytes].filter_map do |key|
    stats[key].to_s.rjust(max_widths[key]) if options[key]
  end.join(' ')
end

def print_file_stats(file_stats, max_widths, options)
  file_stats.each do |stats|
    result = format_result(stats, max_widths, options)
    puts [result, stats[:filenames]].join(' ')
  end
end

main
