# frozen_string_literal: true

require_relative '../validator/board_validator'

# Board entity to describe the playing board
class Board
  include BoardValidator

  attr_accessor :length, :width

  def initialize(length:, width:)
    @length = length
    @width = width

    validate!
  end
end
