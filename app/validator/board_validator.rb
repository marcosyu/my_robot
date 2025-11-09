# frozen_string_literal: true

require_relative 'base_validator'

# Validates Board Input
module BoardValidator
  include BaseValidator

  MIN_LENGTH = 3
  MAX_LENGTH = 100

  MIN_WIDTH = 3
  MAX_WIDTH = 100

  validates :length, :width, presence: true

  validates :length,
            numericality: {
              greater_than_or_equal_to: MIN_LENGTH,
              less_than_or_equal_to: MAX_LENGTH,
              only_integer: true
            }

  validates :width,
            numericality: {
              greater_than_or_equal_to: MIN_WIDTH,
              less_than_or_equal_to: MAX_WIDTH,
              only_integer: true
            }
end
