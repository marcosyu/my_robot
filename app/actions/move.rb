# frozen_string_literal: true

# Move robot location by one point
class Move
  def self.run(robot)
    case robot.direction
    when 'N'
      robot.y_coordinate += 1
    when 'E'
      robot.x_coordinate += 1
    when 'S'
      robot.y_coordinate -= 1
    when 'W'
      robot.x_coordinate -= 1
    end
  end
end
