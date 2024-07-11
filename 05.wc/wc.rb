# frozen_string_literal: true

require 'optparse'

total_lines = 0
total_words = 0
total_bytes = 0

options = {}
OptionParser.new do |opts|
  opts.on('-l') { options[:lines] = true }
  opts.on('-w') { options[:words] = true }
  opts.on('-c') { options[:bytes] = true }
end.parse!

input_sources = ARGV.empty? ? [ARGF] : ARGV

input_sources.each do |source|
  lines = 0
  words = 0
  bytes = 0

  begin
    input = source == ARGF ? ARGF.read : File.read(source)

    input.each_line do |line|
      lines += 1
      words += line.split.size
      bytes += line.bytesize
    end

    total_lines += lines
    total_words += words
    total_bytes += bytes

    options = { bytes: true, lines: true, words: true } if options.empty?
    result = []
    result << lines if options[:lines]
    result << words if options[:words]
    result << bytes if options[:bytes]

    puts "#{result.join(' ')} #{source == ARGF ? '' : source}"
  rescue Errno::ENOENT
    puts "wc: #{source}: そのようなファイルやディレクトリはありません"
  end
end

if input_sources.size > 1
  total_result = []
  total_result << total_lines if options[:lines]
  total_result << total_words if options[:words]
  total_result << total_bytes if options[:bytes]

  puts "#{total_result.join(' ')} 合計"
end
