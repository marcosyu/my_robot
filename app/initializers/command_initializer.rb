# frozen_string_literal: true

require_relative '../entities/command'
require_relative '../actions/move'
require_relative '../actions/place'
require_relative '../actions/report'
require_relative '../actions/left'
require_relative '../actions/right'

module Initializers
  # Handles board initialization
  class CommandInitializer
    class << self
      attr_accessor :robot

      def run(robot, board)
        @retry_count = 1
        @board = board
        @robot = robot

        begin
          await_command
          execute_command unless @command.name == 'QUIT'
        rescue StandardError => _e
          raise
        end

        @command
      end

      private

      def await_command
        prompt = TTY::Prompt.new
        puts 'Awaiting command input.(PLACE, MOVE, LEFT, RIGHT, REPORT, QUIT)'

        @command_string = prompt.ask("What's your command?")
        @command = Command.new(@command_string, robot: @robot, board: @board)
      end

      def execute_command
        return Place.run(@robot, @command) if @command.name == 'PLACE'

        Object.const_get(@command.name.capitalize).run(@robot)
      end
    end
  end
end
