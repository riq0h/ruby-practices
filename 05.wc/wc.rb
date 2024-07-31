# frozen_string_literal: true

require 'optparse'

def main
  options, filenames = parse_options
  file_stats = collect_file_stats(filenames)
  total_stat = calculate_total_stat(file_stats)
  max_widths = calculate_max_widths(total_stat)

  file_stats << total_stat if filenames.size > 1
  file_stats.each { |file_stat| puts format_row(file_stat, max_widths, options) }
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
    {
      filename: filename,
      lines: text.lines.count,
      words: text.split.size,
      bytes: text.bytesize
    }
  end
end

def calculate_total_stat(file_stats)
  total_stat = { filename: '合計', lines: 0, words: 0, bytes: 0 }
  file_stats.each do |stats|
    total_stat[:lines] += stats[:lines]
    total_stat[:words] += stats[:words]
    total_stat[:bytes] += stats[:bytes]
  end
  total_stat
end

def calculate_max_widths(total_stat)
  %i[lines words bytes].to_h { |key| [key, total_stat[key].to_s.length] }
end

def format_row(stats, max_widths, options)
  result = %i[lines words bytes].filter_map do |key|
    stats[key].to_s.rjust(max_widths[key]) if options[key]
  end
  [*result, stats[:filename]].join(' ')
end

main
