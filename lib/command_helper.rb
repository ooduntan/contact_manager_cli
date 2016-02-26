require_relative 'contact_manager'
require 'colorize'
# this class help the cli
class CommandHelper < ContactManager
  def check_add_format(command_array)
    if command_array[1] != '-u' || command_array[3] != '-p'
      puts 'Invalid command use -u <name> -p <number> or -e to exist'.red
    elsif !num_str(command_array[4])
      error = 'Phone number not a valid number use -u <name> -p <number> '.red
      put error << 'or -e to exist'.red
    else
      process_correct_formart(command_array)
    end
    main_menu_command
  end

  def process_correct_formart(command_array)
    add_new_contact(command_array[2], command_array[4])
    display = command_array[2] + ' has been created successfully'
    puts display.green
  end

  def invalid_and_continue
    puts 'Invalid command press -h for help or -e to exist'.red
    main_menu_command
  end

  def continue_flow
    main_menu_command
  end

  def num_str(number)
    if number =~ /^\d+$/
      true
    else
      false
    end
  end

  def clean_input(input_data)
    if !input_data.split(' ')[0].include?('"') && !input_data.split(' ')[0].include?("'")
      input_assembler(input_data)
    else
      invalid_and_continue
    end
  end

  def input_assembler(input_data)
    if input_data.include?("'")
      clean_single_qoute(input_data)
    elsif input_data.include?('"')
      return clean_dobule_qoute(input_data)
    else
      return input_data.split(' ')
    end
  end

  def clean_single_qoute(input_data)
    temp_input_data = input_data.split("'")
    input_data = []
    temp_input_data[0].split(' ').each { |z| input_data << z }
    input_data << temp_input_data[1]
    unless temp_input_data[2].is_a?(NilClass)
      temp_input_data[2].split(' ').each { |z| input_data << z }
    end
    input_data
  end

  def clean_dobule_qoute(input_data)
    temp_input_data = input_data.split('"')
    input_data = []
    temp_input_data[0].split(' ').each { |z| input_data << z }
    input_data << temp_input_data[1]
    unless temp_input_data[2].is_a?(NilClass)
      temp_input_data[2].split(' ').each { |z| input_data << z }
    end
    input_data
  end

  def help_info
    add_text_help = 'use add -u <Name> -p <phone number> to add new contact'
    search_help_text = 'use search <Name> to search for a contact'
    message_help_data = 'use text <Name> <Message> to send text to a contact'
    list_message = 'use list -m to display all sent messages'
    list_contact = 'use list -c to show all contacts'
    delete_contact = 'use delete <Name> to delete a contact'
    help_data = [add_text_help, search_help_text, message_help_data]
    help_data << delete_contact
    help_data << list_message
    help_data << list_contact
  end

  def display_help(help_data)
    counter = 1
    help_data.each do |data|
      puts counter.to_s + '. ' + data.magenta
      counter += 1
    end
  end

  def main_menu_command
    command_string = gets.chomp
    if !command_string.empty?
      command_array = clean_input(command_string)
      command_navigator(command_array)
    else
      invalid_and_continue
      main_menu_command
    end
  end

  def command_navigator(command_array)
    if command_array[0].casecmp('add').zero?
      add_command(command_array)
    elsif command_array[0].casecmp('-e').zero?
      puts 'Thank you for using contact manager goodbye'.yellow
    elsif command_array[0].casecmp('search').zero?
      search_command(command_array)
    elsif command_array[0].casecmp('list').zero?
      list_command(command_array)
    elsif command_array[0].casecmp('text').zero?
      text_action(command_array)
    elsif command_array[0].casecmp('del').zero?
      del_command(command_array)
    elsif command_array[0].casecmp('-e').zero?
      puts 'Thank you for using contact manager goodbye'.yellow
    elsif command_array[0].casecmp('-h').zero?
      display_help(help_info)
    else
      invalid_and_continue
    end
  end

  def add_command(command_array)
    if command_array.length == 5
      check_add_format(command_array)
    else
      invalid_and_continue
    end
  end

  def search_command(command_array)
    if command_array.length < 1 || command_array.length > 2
      display = 'Invalid command use search <keyword> -h '
      display += 'for help or -e to exist'
      puts display.red
    else
      result = search_contact(command_array[1])
      display_search_result(command_array[1], result)
    end
  end

  def del_command(command_array)
    if command_array.length < 1 || command_array.length > 2
      puts 'Invalid command use delete <keyword> -h for help or -e to exist'.red
    else
      delete_search_result_for_sms(command_array[1], search_contact(command_array[1]))
    end
  end

  def list_command(command_array)
    if command_array.length < 1 || command_array.length > 2
      puts 'Invalid command press -h for help or -e to exist'.red
    elsif command_array[1] == '-m'
      message_result = search_all_message
      display_message_result(message_result)
      puts 'to continue type u command or use -e to exist'.yellow
      main_menu_command
    elsif command_array[1] == '-c'
      display_contacts_result(search_all_contacts)
      puts 'to continue type your command or use -e to exist'.yellow
    else
      puts 'Invalid command use list -m or use -h for help or -e to exist'.red
    end
    continue_flow
  end

  def text_validator(command_array)
    result = search_contact(command_array[1])
    reci_details = display_search_result_for_sms(command_array[1], result)
    server_reply = send_and_save_message(reci_details, command_array[2])
    if server_reply[1] == 'OK'
      puts 'Message Saved and sent successfully'.green
    else
      error = 'An error occurred while sending your message. '
      error += 'Please try again'
      puts error.red
    end
  end

  def text_action(command_array)
    if command_array.length < 3 || command_array.length > 4
      display = 'Invalid command use text <name> <messages> -h for '
      display += 'help or -e to exist'
      puts display.red
      main_menu_command
    else
      text_validator(command_array)
    end
  end
end
