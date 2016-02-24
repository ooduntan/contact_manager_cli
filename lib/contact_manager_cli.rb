require_relative "contact_manager_cli/version"

module ContactManagerCli
  # Your code goes here...
	require_relative 'contact_manager'
	require_relative 'Command_helper'
	user_data=DataManager.look_up_user
	if user_data.length<=0
		puts 'Hello! We need your name'
		name = gets.chomp
		puts "and your Phone Number"
		phone_number = gets.chomp
		purified_phone_number=ContactManager.purify_number(phone_number)
		contact_manager_obj = ContactManager.new(name,purified_phone_number)
		puts "Welcome #{name} for help type -h and press the enter key or -e to exist"
	else
		puts 'Welcome back '+user_data[0][0]+' for help type -h and press the enter key or -e to exist'
		contact_manager_obj = ContactManager.new()
	end
	command_checker_obj=CommandHelper.new()
	command_checker_obj.main_menu_command

end
