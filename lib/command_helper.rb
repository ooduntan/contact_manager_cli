# this class help the cli
require_relative 'contact_manager'
class CommandHelper < ContactManager
	def check_add_format(command_array)
		if command_array[1] != '-u' || command_array[3] != '-p'
			puts 'Invalid command use -u <name> -p <number>'
			main_menu_command
		elsif !is_num_str(command_array[4])
			puts 'Phone number not a valid number use -u <name> -p <number>'
			main_menu_command
		else
			add_new_contact(command_array[2], command_array[4])
			puts command_array[2]+' has been created successfully'
			main_menu_command
		end
	end

	def is_num_str(number)
		number =~ /^\d+$/?true:false
	end

	def main_menu_command
		command_array=gets.chomp
		if command_array.include?("'")
			temp_array=command_array.split("'")
			command_array=[]
			temp_array[0].split(' ').each{ |z| command_array<< z}
			command_array<< temp_array[1]
			temp_array[2].split(' ').each{ |z| command_array<< z}
		elsif command_array.include?('"')
			temp_array=command_array.split('"')
			command_array=[]
			temp_array[0].split(' ').each{ |z| command_array<< z}
			command_array<< temp_array[1]
			temp_array[2].split(' ').each{ |z| command_array<< z}
		else
			command_array=command_array.split(" ")
		end

		print command_array
		if command_array[0].downcase == 'add'
			if command_array.length==5
				check_add_format(command_array)
			else
				puts 'Invalid command press -h for help or -e to exist'
				main_menu_command
			end
		elsif command_array[0].downcase == 'search'

		elsif command_array[0].downcase == 'text'

		else
			puts 'Invalid command press -h for help or -e to exist'
			main_menu_command
		end

	end

end