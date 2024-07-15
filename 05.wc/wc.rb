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
  [options, ARGV.empty? ? [ARGF] : ARGV]
end

def count_file_stats(input)
  lines = words = bytes = 0
  input.each_line do |line|
    lines += 1
    words += line.split.size
    bytes += line.bytesize
  end
  [lines, words, bytes]
end

def process_input(source)
  if source == ARGF || File.exist?(source)
    input = source == ARGF ? ARGF.read : File.read(source)
    count_file_stats(input)
  else
    puts "wc: #{source}: そのようなファイルやディレクトリはありません"
    exit
  end
end

def update_totals(totals, stats)
  totals.zip(stats).map { |total, stat| total + stat }
end

def update_max_widths(max_widths, stats)
  max_widths.zip(stats).map { |max, stat| [max, stat.to_s.length].max }
end

def format_result(stats, max_widths, options)
  result = []
  %i[lines words bytes].each_with_index do |key, index|
    result << stats[index].to_s.rjust(max_widths[index]) if options[key]
  end
  result.join(' ')
end

def print_result(result, source)
  puts "#{result} #{source == ARGF ? '' : source}"
end

def print_total(total_stats, max_widths, options)
  total_result = format_result(total_stats, max_widths, options)
  puts "#{total_result} 合計"
end

def process_input_sources(input_sources, options)
  total_stats = [0, 0, 0]
  max_widths = [0, 0, 0]

  input_sources.each do |source|
    stats = process_input(source)
    total_stats = update_totals(total_stats, stats)
    max_widths = update_max_widths(max_widths, stats)
    result = format_result(stats, max_widths, options)
    print_result(result, source)
  end

  print_total(total_stats, max_widths, options) if input_sources.size > 1
end

options, input_sources = parse_options
process_input_sources(input_sources, options)
