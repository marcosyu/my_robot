# frozen_string_literal: true

# Place robot on a different location
class Place
  def self.run(robot, command)
    robot.x_coordinate = command.arguments[0].to_i
    robot.y_coordinate = command.arguments[1].to_i
    robot.direction = command.arguments[2].upcase
  end
end
