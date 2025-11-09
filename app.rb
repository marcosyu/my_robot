# frozen_string_literal: true

require 'bundler/setup'
require_relative 'app/initializers/board_initializer'
require_relative 'app/entities/robot'
require_relative 'app/initializers/command_initializer'

ENV['RUBY_ENV'] ||= 'development'

Bundler.require(:default, ENV['RUBY_ENV'].to_sym)

puts "Running on #{ENV['RUBY_ENV']} mode"

@board = Initializers::BoardInitializer.run
return if @board.nil?

@robot = Robot.new

loop do
  @command = Initializers::CommandInitializer.run(@robot, @board)
  @robot = @command.robot

  if @command.name == 'QUIT'
    puts 'Sayonara!'.green
    break
  end
rescue StandardError => e
  puts e.message.red
end
