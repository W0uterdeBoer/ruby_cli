# frozen_string_literal: true

require 'readline'
require './Cli'

command = Readline.readline('> ', true).split
Cli.new.grep(command)
