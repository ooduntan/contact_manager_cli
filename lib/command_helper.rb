require_relative 'contact_manager'
require 'colorize'
# this class help the cli
class CommandHelper < ContactManager
  def check_add_format(command_array)
    if command_array[1] != '-u' || command_array[3] != '-p'
      puts 'Invalid command use -u <name> -p <number> or -e to exist'.red
      main_menu_command
    elsif !is_num_str(command_array[4])
      puts 'Phone number not a valid number use -u <name> -p <number> or -e to exist'.red
      main_menu_command
    else
      add_new_contact(command_array[2], command_array[4])
      puts (command_array[2] + ' has been created successfully').green
      main_menu_command
    end
  end

  def invalid_and_continue
     puts 'Invalid command press -h for help or -e to exist'.red
    main_menu_command
  end

  def is_num_str(number)
    if number =~ /^\d+$/
     true
   else
     false
   end
  end

  def clean_input(input_data)
    if !input_data.split(' ')[0].include?('"') && !input_data.split(' ')[0].include?("'")
    if input_data.include?("'")
      temp_input_data = input_data.split("'")
      input_data = []
      temp_input_data[0].split(' ').each { |z| input_data << z }
      input_data << temp_input_data[1]
      unless temp_input_data[2].is_a?(NilClass)
        temp_input_data[2].split(' ').each { |z| input_data << z }
      end
    elsif input_data.include?('"')
      temp_input_data = input_data.split('"')
      input_data = []
      temp_input_data[0].split(' ').each { |z| input_data << z }
      input_data << temp_input_data[1]
      unless temp_input_data[2].is_a?(NilClass)
        temp_input_data[2].split(' ').each { |z| input_data << z }
      end
    else
      input_data = input_data.split(' ')
  end
    input_data
  else
    invalid_and_continue
  end
  end

  def help_info
  	add_text_help = 'use add -u <Name> -p <phone number> to add new contact'
  	search_help_text = 'use search <Name> to search for a contact'
  	message_help_data = 'use text <Name> <Message> to send text to a contact'
  	list_message = 'use list -m to display all sent messages'
  	list_contact = 'use list -c to show all contacts'
  	delete_contact = 'use delete <Name> to delete a contact'
  	help_data = [add_text_help,search_help_text,message_help_data,delete_contact]
  	help_data<< list_message
  	help_data<< list_contact
  end

  def display_help(help_data)
  	counter=1
  	help_data.each do |data|
  	 puts counter.to_s+'. ' + data.magenta
  	 counter+=1
  	end
  end

  def main_menu_command
    command_string = gets.chomp
    if !command_string.empty?
      command_array = clean_input(command_string)
      if command_array[0].casecmp('add').zero?
        if command_array.length == 5
          check_add_format(command_array)
        else
          invalid_and_continue
        end
      elsif command_array[0].casecmp('search').zero?
        if command_array.length < 1 || command_array.length > 2
          puts 'Invalid command use search <keyword> -h for help or -e to exist'.red
          main_menu_command
        else
          result = search_contact(command_array[1])
          display_search_result(command_array[1], result)
        end
      elsif command_array[0].casecmp('list').zero?
        if command_array.length < 1 || command_array.length > 2
          invalid_and_continue
        elsif command_array[1] == '-m'
          message_result = search_all_message
          display_message_result(message_result)
          puts 'to continue type your command or use -e to exist'.yellow
          main_menu_command
        elsif command_array[1] == '-c'
          display_contacts_result(search_all_contacts)
          puts 'to continue type your command or use -e to exist'.yellow
          main_menu_command
        else
          puts 'Invalid command use list -m or use -h for help or -e to exist'.red
          main_menu_command
        end
      elsif command_array[0].casecmp('text').zero?
        if command_array.length < 3 || command_array.length > 4
          puts 'Invalid command use text <name> <messages> -h for help or -e to exist'.red
          main_menu_command
        else
          result = search_contact(command_array[1])
          recipiant_details = display_search_result_for_sms(command_array[1], result)
          server_reply = send_and_save_message(recipiant_details, command_array[2])
          if server_reply[1] == 'OK'
            puts 'Message Saved and sent successfully'.green
          else
            puts 'An error occurred while sending your message. Please try again'.red
          end
          main_menu_command
        end
      elsif command_array[0].casecmp('del').zero?
      	  if command_array.length < 1 || command_array.length > 2
          puts 'Invalid command use delete <keyword> -h for help or -e to exist'.red
          main_menu_command
        else
          delete_search_result_for_sms(command_array[1], search_contact(command_array[1]))
        end
      elsif command_array[0].casecmp('-e').zero?
        puts 'Thank you for using contact manager goodbye'.yellow
      elsif command_array[0].casecmp('-h').zero?
        display_help(help_info)
        main_menu_command
      else
       invalid_and_continue
      end
    else
      invalid_and_continue
      end
  end
end
