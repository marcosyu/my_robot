# frozen_string_literal: true

require_relative '../entities/board'

module Initializers
  # Handles board initialization
  class BoardInitializer
    class << self
      def run
        @retry_count = 1
        inquire_properties
        if @board.nil?
          puts "Board initialization failed. #{@board.inspect}".red
        else
          puts "Board successfully initialized. #{@board.inspect}".green
        end

        @board
      end

      private

      def inquire_properties
        prompt = TTY::Prompt.new
        puts 'Please input board properties.'
        @length = prompt.ask("What's the length of the Board?")
        @width = prompt.ask("What's the width of the Board?")

        set_board
      end

      def set_board
        @board = ::Board.new(length: @length, width: @width)
      rescue StandardError => e
        puts e.message.red
        if @retry_count <= 3
          @retry_count += 1
          inquire_properties
        end
      end
    end
  end
end
