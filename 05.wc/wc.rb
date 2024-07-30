# frozen_string_literal: true

require 'optparse'

def main
  options, filenames = parse_options
  file_details = collect_file_stats(filenames)
  total_stats = calculate_total_stats(file_details)
  max_widths = calculate_max_widths(total_stats)

  file_details.each { |file_stats| print_stats(file_stats, max_widths, options) }
  print_stats(total_stats, max_widths, options) if filenames.size > 1
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
    text = filename.empty? ? ARGF.read : File.read(filename)
    { filename: filename, lines: text.lines.count, words: text.split.size, bytes: text.bytesize }
  end
end

def calculate_total_stats(file_details)
  total_stats = { filename: '合計', lines: 0, words: 0, bytes: 0 }
  file_details.each do |stats|
    total_stats[:lines] += stats[:lines]
    total_stats[:words] += stats[:words]
    total_stats[:bytes] += stats[:bytes]
  end
  total_stats
end

def calculate_max_widths(total_stats)
  %i[lines words bytes].to_h { |key| [key, total_stats[key].to_s.length] }
end

def format_result(stats, max_widths, options)
  %i[lines words bytes].filter_map do |key|
    stats[key].to_s.rjust(max_widths[key]) if options[key]
  end
end

def print_stats(stats, max_widths, options)
  puts (format_result(stats, max_widths, options) << stats[:filename]).join(' ')
end

main
