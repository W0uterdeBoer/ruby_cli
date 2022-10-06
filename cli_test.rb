# frozen_string_literal: true

require 'minitest/autorun'
require_relative './cli'

class CliTest < Minitest::Test
 
  def setup 
    @cli = Cli.new
  end 
  
  class GrepTest < CliTest
    def test_grep_finds_relevant_lines_in_txt_file  
      out, _err = capture_io do
        @cli.grep(['grep', 'wout', 'input.txt'])
      end
      # increments assertions by 2, see https://github.com/minitest/minitest/issues/584
      assert_match(/wout/, out)
    end 

    def test_grep_is_case_sensitive
      out, _err = capture_io do
        @cli.grep(['grep', 'WOUT', 'input.txt'])
      end
      refute_match(/input.txt/, out)
    end
    
    def test_grep_can_handle_multiple_files
      out, _err = capture_io do
        @cli.grep(['grep', '-l', 'wout', 'input.txt', 'second_input.txt'])
      end
      assert_match(/input.txt/, out)
      assert_match(/second_input.txt/, out)
    end
  end

  class FlagTests < CliTest
    def test_grep_displays_line_number_with_n_flag
      out, _err = capture_io do
        @cli.grep(['grep', '-n', 'wout', 'input.txt'])
      end
      assert_match(/regel 5/, out)
    end 
  
    def test_grep_displays_filename_with_l_flag
      out, _err = capture_io do
        @cli.grep(['grep', '-l', 'wout', 'input.txt'])
      end
      assert_match(/input.txt/, out)
    end 

    def test_grep_ignores_casing_with_i_flag
      out, _err = capture_io do
        @cli.grep(['grep', '-i', 'WOUT', 'input.txt'])
      end
      assert_match(/wout/, out)
    end 

    def test_grep_shows_non_matching_lines_with_v_flag
      out, _err = capture_io do
        @cli.grep(['grep', '-v', 'wout', 'input.txt'])
      end
      refute_match(/wout/, out)
    end
  
    def test_grep_matches_entire_line_with_x_flag
      out, _err = capture_io do
        @cli.grep(['grep', '-x', 'wou', 'input.txt'])
      end
      refute_match(/wout/, out)
    end

    class FlagInteractionsTests < FlagTests
      def test_grep_can_handle_n_and_l_flags_similtaneously
        out, _err = capture_io do
          @cli.grep(['grep', '-l', '-n', 'wout', 'input.txt'])
        end
        assert_match(/input.txt regel: 2/, out)
      end           
    
      def test_grep_can_handle_x_and_i_flags_similtaneously
        out, _err = capture_io do
          @cli.grep(['grep', '-x', '-i', 'WOUT', 'input.txt'])
        end
        assert_match(/wout/, out)
      end 

      def test_grep_takes_correct_searchterm_with_wrongly_placed_flags
        out, _err = capture_io do
          @cli.grep(['grep', 'wout', 'input.txt', '-v'])
        end
        refute_match(/asdf/, out)
      end
    end
  
  end 

  private

  attr_reader :cli
end
