# frozen_string_literal: true

require 'byebug'
require './Logger'

class Cli

  def grep(command)
    @flags = find_flags(command)
    input_files = find_input_files(command)
    search_term = command[flags.length + 1]
    find_matches(search_term, input_files) if command[0].match?(/grep/)
  end 
 
  private

  attr_reader :flags

  def find_matches(search_input, input_files)
    input_files.each do |filename| 
      lines = File.open(filename).readlines.map(&:chomp)
      lines.each_with_index do |line, i|
        if should_log(search_input, line) 
          Logger.log_matches(line, i, filename, @flags) 
          break if flags.include?('l')
        end
      end
    end
  end

  def should_log(search_input, line)
    return !line_matches(search_input, line) if flags.include?('v')

    line_matches(search_input, line)
  end 

  def find_flags(command)
    latest_flag_index = 0
    flags = command.select.with_index do |word, i| 
      if word.match?(/-/) && i == latest_flag_index + 1
        latest_flag_index = i
        word.match?(/-/)
      end     
    end
    flags.map { |flag| flag.delete_prefix('-') }
  end

  def find_input_files(command)
    command.select.with_index { |word, i| word.match?(/.txt/) && i > 1 }
  end

  def line_matches(search_input, line)
    case_insensitive = flags.include?('i')  
    return Regexp.new("^#{search_input}$", case_insensitive).match?(line) if flags.include?('x')

    Regexp.new(search_input, case_insensitive).match?(line) 
  end
end
