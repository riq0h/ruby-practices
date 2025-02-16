# frozen_string_literal: true

require_relative 'file_lister'
require_relative 'three_column_formatter'
require_relative 'detailed_lister'
require_relative 'file_info'
require_relative 'constants'

FileLister.new.run
