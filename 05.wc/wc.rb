# frozen_string_literal: true

require 'optparse'

def main
  options, sources = parse_options
  file_stats = collect_file_stats(sources)
  total_stats = calculate_total_stats(file_stats)
  max_widths = calculate_max_widths(file_stats, total_stats)
  print_file_stats(file_stats, max_widths, options)
  print_file_stats([['合計', total_stats]], max_widths, options) if sources.size > 1
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
    stats = { lines: input.lines.count, words: input.split.size, bytes: input.bytesize }
    [source, stats]
  end
end

def calculate_total_stats(file_stats)
  file_stats.reduce({ lines: 0, words: 0, bytes: 0 }) do |total, (_, stats)|
    total.merge(stats) { |_, a, b| a + b }
  end
end

def calculate_max_widths(file_stats, total_stats)
  (file_stats.map(&:last) + [total_stats]).each_with_object({ lines: 0, words: 0, bytes: 0 }) do |stats, max_widths|
    max_widths.merge!(stats) { |_, max, stat| [max, stat.to_s.length].max }
  end
end

def format_result(stats, max_widths, options)
  %i[lines words bytes].map { |key| stats[key].to_s.rjust(max_widths[key]) if options[key] }.compact.join(' ')
end

def print_file_stats(file_stats, max_widths, options)
  file_stats.each do |source, stats|
    result = format_result(stats, max_widths, options)
    puts "#{result} #{source}"
  end
end

main
