# frozen_string_literal: true

require_relative '../validator/command_validator'

# Command entity to describe the playing board
class Command
  include CommandValidator

  attr_accessor :name, :arguments, :robot, :board

  def initialize(command_string, robot:, board:)
    command_array = command_string.split(' ')
    @name = command_array[0].upcase
    @arguments = command_array[1]&.split(',')
    @robot = robot
    @board = board

    validate!
  end
end
