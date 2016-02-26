require_relative 'data_manager'
require 'open-uri'
require 'colorize'
# this class handles the  search and add
class ContactManager < DataManager
  def initialize(name = nil, phone_number = nil)
    if !name.nil? && !phone_number.nil?
      prepare_user_table
      user_hash = { 'user_name' => name, 'phone_number' => phone_number }
      save_into_db('user_data', user_hash)
    end
    connect_db
  end

  def self.search_user
    look_up_user
  end

  def self.num_str?(num)
    num =~ /^\d+$/ ? true : false
  end

  def self.username_checker(name)
    unless name.empty? || name == '-e'
      puts 'You have not typed your name. Try again'
      name = gets.chomp
      username_checker(name)
    end
    name
  end

  def self.purify_number(number)
    unless num_str?(number) || number == '-e'
      puts 'Invalid phone Number. Try again'
      number = gets.chomp
      purify_number(number)
    end
    number
  end

  def send_sms_using_api(sender, recipient_number, clean_message)
    api_string = 'http://api.smartsmssolutions.com/smsapi.php?username=ITVessel'
    api_string += '&password=tomboy&sender=' + sender + '&recipient='
    api_string += recipient_number.to_s + '&message=' + clean_message
    server_response = open(api_string)
    server_response.status
  end

  def search_all_message
    bring_all_message
  end

  def search_all_contacts
    bring_all_contacts
  end

  def display_contacts_result(message_contact_data)
    if message_contact_data.length < 1
      puts 'Oops! Your contact is empty'.red
    else
      display = 'Found ' + message_contact_data.length.to_s + ' contacts'
      puts display.yellow
      loop_display_contact_reslut(message_contact_data)
    end
  end

  def loop_display_contact_reslut(message_contact_data)
    counter = 1
    message_contact_data.each do |each_message_data|
      display_contact_format(counter, each_message_data)
      counter += 1
    end
  end

  def display_contact_format(counter, each_message_data)
    result = "[#{counter}] Name: ".yellow + each_message_data[1].green
    result += "\nNumber: ".yellow + each_message_data[2].green + "\n\n"
    puts result
  end

  def display_message_result(message_result_data)
    if message_result_data.length < 1
      puts 'Oops! message box empty'.red
    else
      display = 'Found ' + message_result_data.length.to_s + ' messages'
      puts display.yellow
      loop_display_message_reslut(message_result_data)
    end
  end

  def loop_display_message_reslut(message_result_data)
    counter = 1
    message_result_data.each do |each_message_data|
      user_name = get_user_name_from_id(each_message_data[1].to_i)
      display_message(counter, user_name, each_message_data)
      counter += 1
    end
  end

  def display_message(counter, user_name, each_message_data)
    message_result = "[#{counter}] Sent to: ".yellow
    message_result += user_name[0][2].green + "\nName: ".yellow
    message_result += user_name[0][1].green + "\nmessage: ".yellow
    message_result += each_message_data[2].green + "\nDate and TIme: ".yellow
    message_result += each_message_data[3].green + "\n".yellow
    puts message_result
  end

  private

  def save_message(contact_idx, message)
    time = Time.new
    formated_time = time.strftime('%Y-%m-%d %H:%M:%S')
    clean_message = quote_string(message)
    new_message_hash = { 'contact_idx' => contact_idx }
    new_message_hash['message'] = clean_message
    new_message_hash['time_sent'] = formated_time
    save_into_db('contacts_message_data', new_message_hash)
  end

  def send_and_save_message(recipient_array, message)
    save_message(recipient_array[0], message)
    sender = brings_user_number
    send_sms_using_api(sender[0][0], recipient_array[2], message)
  end

  def display_search_result_for_sms(search_term, result_array)
    if result_array.length < 1
      puts 'found no result for ' + search_term
    elsif result_array.length > 1
      confirm_displayed_contact(search_term, result_array)
    else
      result_array[0]
    end
  end

  def confirm_displayed_contact(search_term, result_array)
    puts 'Which ' + search_term + '?'
    prints_result_only(result_array)
    result_array[(gets.chomp.to_i - 1)]
  end

  def add_new_contact(name, phone_number)
    clean_name = quote_string(name)
    clean_phone_number = quote_string(phone_number)
    new_contact_hash = { 'contact_name' => clean_name }
    new_contact_hash['contact_phoneNumber'] = clean_phone_number
    save_into_db('contacts_data', new_contact_hash)
  end

  def check_phone_number?(phone_number)
    phone_number = phone_number.to_i
    phone_number
  end

  def delete_search_result_for_sms(search_term, result_array)
    if result_array.length < 1
      display = 'found no result for ' + search_term
      puts display.red
      main_menu_command
    else
      puts 'Which '.yellow + search_term.green + ' ?'.yellow
      prints_result_only(result_array)
      selected_number = gets.chomp
      confirm_string_number(selected_number, result_array)
    end
  end

  def confirm_string_number(selected_number, result_array)
    if check_if_str_is_number(selected_number) == true
      display_selectd_contact_for_del(result_array[(selected_number.to_i - 1)])
    else
      puts 'Oops! Invalid selection '.red
      main_menu_command
    end
  end

  def prints_result_only(result_array)
    i = 1
    result_array.each do |value|
      display = '[' << i.to_s << '] ' << value[1]
      puts display.green
      i += 1
    end
  end

  def display_search_result(search_term, result_array)
    if result_array.is_a?(NilClass)
      puts 'Oop! You dont have any contacts in your phonebook'.red
    elsif result_array.length < 1
      puts 'found no result for ' + search_term.red
      main_menu_command
    elsif result_array.length > 1
      display_search_greater(result_array, search_term)
    else
      display_search_equals(result_array)
    end
  end

  def display_search_equals(result_array)
    puts result_array[0][1] + ': ' + result_array[0][2].green
    puts 'to continue type your command or use -e to exist'.yellow
    main_menu_command
  end

  def display_search_greater(result_array, search_term)
    display = 'Which ' + search_term + '?'
    puts display.yellow
    prints_result_only(result_array)
    selectd_val = gets.chomp
    display_selected_index(result_array[(selectd_val.to_i - 1)], selectd_val)
  end

  def check_if_str_is_number(string)
    if string =~ /^\d+$/
      true
    else
      false
    end
  end

  def display_selectd_contact_for_del(selected_array)
    if selected_array.is_a?(NilClass)
      puts 'Wrong value selected'.red
    else
      delete_contact_from_db(selected_array[0])
      puts 'Contact successfully deleted'.yellow
      puts 'to continue type your command or use -e to exist'.yellow
    end
    main_menu_command
  end

  def display_selected_index(selected_array, value)
    if selected_array.is_a?(NilClass) || !check_if_str_is_number(value.to_s)
      puts 'Wrong value selected'.red
    else
      name_and_number = selected_array[1] << ': ' << selected_array[2]
      puts name_and_number.green
      puts 'to continue type your command or use -e to exist'.yellow
    end
    main_menu_command
  end

  def search_contact(name)
    look_up_data(name)
  end
end
