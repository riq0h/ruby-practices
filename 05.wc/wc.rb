# frozen_string_literal: true

require 'optparse'

def parse_options
  options = {}
  OptionParser.new do |opts|
    opts.on('-l') { options[:lines] = true }
    opts.on('-w') { options[:words] = true }
    opts.on('-c') { options[:bytes] = true }
  end.parse!
  options = { bytes: true, lines: true, words: true } if options.empty?
  sources = ARGV.empty? ? ['-'] : ARGV
  [options, sources]
end

def input_stream_sources(input_sources, options)
  total_stats = { lines: 0, words: 0, bytes: 0 }
  max_widths = { lines: 0, words: 0, bytes: 0 }

  input_sources.each do |source|
    stats = input_stream(source)
    total_stats = update_totals(total_stats, stats)
    max_widths = update_max_widths(max_widths, stats)
    result = format_result(stats, max_widths, options)
    print_result(result, source)
  end

  print_total(total_stats, max_widths, options) if input_sources.size > 1
end

def input_stream(source)
  if source == '-'
    count_file_stats(ARGF)
  else
    count_file_stats(File.read(source))
  end
end

def count_file_stats(input)
  stats = { lines: 0, words: 0, bytes: 0 }
  input.each_line do |line|
    stats[:lines] += 1
    stats[:words] += line.split.size
    stats[:bytes] += line.bytesize
  end
  stats
end

def update_totals(totals, stats)
  totals.merge(stats) { |_key, total, stat| total + stat }
end

def update_max_widths(max_widths, stats)
  max_widths.merge(stats) { |_key, max, stat| [max, stat.to_s.length].max }
end

def format_result(stats, max_widths, options)
  result = {}
  %i[lines words bytes].each do |key|
    result[key] = stats[key].to_s.rjust(max_widths[key]) if options[key]
  end
  result.values.join(' ')
end

def print_result(result, source)
  puts "#{result} #{source == '-' ? '' : source}"
end

def print_total(total_stats, max_widths, options)
  total_result = format_result(total_stats, max_widths, options)
  puts "#{total_result} 合計"
end

options, input_sources = parse_options
input_stream_sources(input_sources, options)
