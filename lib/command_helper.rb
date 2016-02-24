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

	def display_search_result(search_term,result_array)
		if result_array.length<1
			puts "found no result for "+search_term
			main_menu_command
		elsif result_array.length>1
			puts 'Which '+search_term+'?'
			prints_result_only(result_array)
			display_selected_index(result_array[(gets.chomp.to_i-1)])
		else
			puts result_array[0][1] +": "+result_array[0][2]
			puts 'to continue type your command or use -e to exist'
			main_menu_command
		end
end

	def display_selected_index(selected_array)
		puts selected_array[1] << ": "<< selected_array[2]
		puts 'to continue type your command or use -e to exist'
		main_menu_command
	end

	def prints_result_only(result_array)
			for i in 0...(result_array.length)
   		puts "["<< (i+1).to_s << "] " << result_array[i][1]
		end
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
				result =search_contact(command_array[1])
				display_search_result(command_array[1],result)
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