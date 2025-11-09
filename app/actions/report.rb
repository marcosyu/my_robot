# frozen_string_literal: true

# Shows robot's current location and orientation
class Report
  def self.run(robot)
    p "Robot is currently in #{robot.x_coordinate}, #{robot.y_coordinate} facing #{robot.direction}"
  end
end
