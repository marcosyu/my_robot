# frozen_string_literal: true

# Handles orientation by rotating clockwise
class Left
  COMPASS = %w[N E S W].freeze

  def self.run(robot)
    updated_direction_index = COMPASS.index(robot.direction) + 1
    robot.direction = if updated_direction_index == COMPASS.length
                        COMPASS[0]
                      else
                        COMPASS[updated_direction_index]
                      end
  end
end
