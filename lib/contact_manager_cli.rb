require_relative 'contact_manager_cli/version'
require 'colorize'
# this create and instantiate necessary dependency
module ContactManagerCli
  # Your code goes here...
  require_relative 'contact_manager'
  require_relative 'Command_helper'
  user_data = DataManager.look_up_user
  if user_data.length <= 0
    puts 'Hello! We need your name'.yellow
    name = gets.chomp
    ContactManager.username_checker(name)
    puts 'and your Phone Number'.yellow
    phone_number = gets.chomp
    purified_phone_number = ContactManager.purify_number(phone_number)
    ContactManager.new(name, purified_phone_number)
    display = 'Welcome '.yellow + name.green + ' for help type -h '.yellow
    puts display << 'and press the enter key or -e to exist'.yellow
  else
    output = 'Welcome back '.yellow + user_data[0][0].green + ' for '.yellow
    puts output << 'help type -h and press the enter key or -e to exist'.yellow
    ContactManager.new
  end
  command_checker_obj = CommandHelper.new
  command_checker_obj.main_menu_command
end
