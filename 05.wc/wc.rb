# frozen_string_literal: true

require 'optparse'

lines = 0
words = 0
bytes = 0

options = {}
OptionParser.new do |opts|
  opts.on('-l') { options[:lines] = true }
  opts.on('-w') { options[:words] = true }
  opts.on('-c') { options[:bytes] = true }
end.parse!

input = if !ARGV.empty?
          File.read(ARGV[0])
        elsif !$stdin.tty?
          $stdin.read
        else
          puts 'ファイルパスまたはパイプラインからの入力がありません。'
          exit
        end

input.each_line do |line|
  lines += 1
  words += line.split.size
  bytes += line.bytesize
end

options = { bytes: true, lines: true, words: true } if options.empty?
result = []
result << lines if options[:lines]
result << words if options[:words]
result << bytes if options[:bytes]

file_name = ARGV[0]
puts "#{result.join(' ')} #{file_name}"
