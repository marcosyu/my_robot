# frozen_string_literal: true

require_relative '../entities/command'
require_relative 'base_validator'

# Validates Command Input
module CommandValidator
  include BaseValidator

  COMMAND_NAMES = %w[MOVE PLACE LEFT RIGHT REPORT QUIT].freeze
  DIRECTIONS = %w[N E S W].freeze

  validates :name, in: COMMAND_NAMES
  validate :initial_robot_location
  validate :place_command_arguments
  validate :robot_movement

  def initial_robot_location
    return if name == 'QUIT'
    return unless robot.x_coordinate.nil? && robot.y_coordinate.nil? && robot.direction.nil? && name != 'PLACE'

    raise(ArgumentError, 'Run PLACE command first')
  end

  def place_command_arguments
    return if name != 'PLACE'

    return raise(ArgumentError, 'Missing X,Y,Orientation arguments') if arguments.empty?
    return raise(ArgumentError, 'Insufficient arguments') if arguments.length != 3
    return raise(ArgumentError, 'X axis be an integer') unless arguments[0].match?(/\A-?\d+\z/)
    return raise(ArgumentError, 'Y axis be an integer') unless arguments[1].match?(/\A-?\d+\z/)
    return raise(ArgumentError, 'Invalid Orientation.') unless DIRECTIONS.include?(arguments[2].upcase)

    true
  end

  def robot_movement
    return true unless %w[MOVE PLACE].include?(name)
    return validate_place_movement if name == 'PLACE'

    validate_move
  end

  def validate_place_movement
    if arguments[0] == board.width.to_i - 1
      return raise(ArgumentError, "X axis must not go over the board. Must be less than #{board.width.to_i - 1}")
    end
    return unless arguments[1] == board.length.to_i - 1

    raise(ArgumentError, "Y axis must not go over the board. Must be less than #{board.length.to_i - 1}")
  end

  def validate_move
    return validate_y_movement if %w[N S].include?(robot.direction)

    validate_x_movement
  end

  def validate_x_movement
    x_axis_after_movement = if robot.direction == 'E'
                              robot.x_coordinate + 1
                            else
                              robot.x_coordinate - 1
                            end

    return raise(ArgumentError, 'Cant go over the board') if x_axis_after_movement > (board.width.to_i - 1)
    return raise(ArgumentError, 'Cant go over the board') if x_axis_after_movement.negative?

    true
  end

  def validate_y_movement
    y_axis_after_movement = if robot.direction == 'N'
                              robot.y_coordinate + 1
                            else
                              robot.y_coordinate - 1
                            end

    return raise(ArgumentError, 'Cant go over the board') if y_axis_after_movement > (board.length.to_i - 1)
    return raise(ArgumentError, 'Cant go over the board') if y_axis_after_movement.negative?

    true
  end
end
