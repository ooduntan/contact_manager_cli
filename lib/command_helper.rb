# this class help the cli
require_relative 'contact_manager'
class CommandHelper < ContactManager
	def check_add_format(command_array)
		if command_array[1] != '-u' || command_array[3] != '-p'
			puts 'Invalid command use -u <name> -p <number> or -e to exist'
			main_menu_command
		elsif !is_num_str(command_array[4])
			puts 'Phone number not a valid number use -u <name> -p <number> or -e to exist'
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

	def clean_input(input_data)
			if input_data.include?("'")
			temp_array=input_data.split("'")
			input_data=[]
			temp_array[0].split(' ').each{ |z| input_data<< z}
			input_data<< temp_array[1]
			if !temp_array[2].is_a?(NilClass)
				temp_array[2].split(' ').each{ |z| input_data<< z}
			end
		elsif input_data.include?('"')
			temp_array=input_data.split('"')
			input_data=[]
			temp_array[0].split(' ').each{ |z| input_data<< z}
			input_data<< temp_array[1]
			if !temp_array[2].is_a?(NilClass)
				temp_array[2].split(' ').each{ |z| input_data<< z}
			end
		else
			input_data=input_data.split(" ")
		end
		input_data
	end


	def main_menu_command
		command_string=gets.chomp
		command_array=clean_input(command_string)
		if command_array[0].downcase == 'add'
			if command_array.length==5
				check_add_format(command_array)
			else
				puts 'Invalid command press -h for help or -e to exist'
				main_menu_command
			end
		elsif command_array[0].downcase == 'search'
			if command_array.length<1
				puts "Invalid command use search <keyword> -h for help or -e to exist"
				main_menu_command
			else
				puts search_contact(command_array[1])
				na=gets.chomp
			end
			print command_array
		elsif command_array[0].downcase == 'text'

		elsif command_array[0].downcase == '-e'
			puts 'Thank you for using contact manager goodbye'
		else
			puts 'Invalid command press -h for help or -e to exist'
			main_menu_command
		end

	end

end