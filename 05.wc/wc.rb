# frozen_string_literal: true

require 'optparse'

def main
  options, sources = parse_options
  file_stats = collect_file_stats(sources)
  total_stats = calculate_total_stats(file_stats)
  max_widths = calculate_max_widths(file_stats, total_stats)
  print_file_stats(file_stats, max_widths, options)
  print_file_stats([{ filename: '合計', **total_stats }], max_widths, options) if sources.size > 1
end

def parse_options
  options = {}
  OptionParser.new do |opts|
    opts.on('-l') { options[:lines] = true }
    opts.on('-w') { options[:words] = true }
    opts.on('-c') { options[:bytes] = true }
  end.parse!
  options = { bytes: true, lines: true, words: true } if options.empty?
  sources = ARGV.empty? ? [''] : ARGV
  [options, sources]
end

def collect_file_stats(sources)
  sources.map do |source|
    input = source.empty? ? ARGF.read : File.read(source)
    { filename: source, lines: input.lines.count, words: input.split.size, bytes: input.bytesize }
  end
end

def calculate_total_stats(file_stats)
  total_stats = { lines: 0, words: 0, bytes: 0 }
  file_stats.each do |stats|
    total_stats[:lines] += stats[:lines]
    total_stats[:words] += stats[:words]
    total_stats[:bytes] += stats[:bytes]
  end
  total_stats
end

def calculate_max_widths(file_stats, total_stats)
  all_stats = file_stats + [total_stats]
  %i[lines words bytes].each_with_object({}) do |key, max_widths|
    max_widths[key] = all_stats.map { |stats| stats[key].to_s.length }.max
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
    puts "#{result} #{stats[:filename]}"
  end
end

main
