# frozen_string_literal: true

# Handles orientation by rotating counter-clockwise
class Right
  COMPASS = %w[N E S W].freeze

  def self.run(robot)
    updated_direction_index = COMPASS.index(robot.direction) - 1
    robot.direction = if updated_direction_index.negative?
                        COMPASS[-1]
                      else
                        COMPASS[updated_direction_index]
                      end
  end
end
