# frozen_string_literal: true

class Logger
  class << self
    attr_reader :flags

    def log_matches(line, line_number, filename, flags)
      @flags = flags
      return log_matching_file(filename, line_number) if @@flags.include?('l')
    
      log_matching_line(line, line_number)       
    end

    def log_matching_line(line, line_number)
      output = line
      output = "regel #{line_number}: #{line}" if @@flags.include?('n')
      puts(output) 
    end 
        
    def log_matching_file(filename, line_number)
      output = filename
      output = "#{filename} regel: #{line_number}" if @@flags.include?('l')
      puts(output)
    end
  end
end
