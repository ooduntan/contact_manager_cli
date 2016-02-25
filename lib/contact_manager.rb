# this class handles the  search and add
require_relative 'data_manager'
require 'open-uri'
require 'colorize'
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

  def self.is_num_str?(num)
    num =~ /^\d+$/ ? true : false
  end

    def self.username_checker(name)
    unless name.length>0  || name == "-e"
      puts 'You have not typed your name. Try again'
      name = gets.chomp
      username_checker(name)
    end
    name
 end

  def self.purify_number(number)
    unless is_num_str?(number) || number == "-e"
      puts 'Invalid phone Number. Try again'
      number = gets.chomp
      purify_number(number)
    end
    number
 end

  def send_sms_using_api(sender, recipient_number, clean_message)
    server_response = open('http://api.smartsmssolutions.com/smsapi.php?username=ITVessel&password=tomboy&sender=' + sender + '&recipient=' + recipient_number.to_s + '&message=' + clean_message + '')
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
      puts ('Found ' + message_contact_data.length.to_s + ' contacts').yellow
      counter = 1
      message_contact_data.each do |each_message_data|
        puts "[#{counter}] Name: ".yellow + each_message_data[1].green + "\nNumber: ".yellow + each_message_data[2].green+"\n\n"
        counter += 1
      end
    end
  end

  def display_message_result(message_result_data)
    if message_result_data.length < 1
      puts 'Oops! message box empty'.red
    else
      puts ('Found ' + message_result_data.length.to_s + ' messages').yellow
      counter = 1
      message_result_data.each do |each_message_data|
        user_name = get_user_name_from_id(each_message_data[1].to_i)
        puts "[#{counter}] Sent to: ".yellow + user_name[0][2].green + "\nName: ".yellow + user_name[0][1].green + "\nmessage: ".yellow + each_message_data[2].green + "\nDate and TIme: ".yellow+each_message_data[3].green+"\n".yellow
        counter += 1
      end
    end
  end

  private

  def save_message(contact_idx, message)
    time = Time.new
    formated_time=time.strftime("%Y-%m-%d %H:%M:%S")
    clean_message = quote_string(message)
    new_message_hash = { 'contact_idx' => contact_idx, 'message' => clean_message,'time_sent'=>formated_time }
    save_into_db('contacts_message_data', new_message_hash)
  end

  def send_and_save_message(recipient_array, message)
    save_message(recipient_array[0], message)
    sender=get_user_number
    send_sms_using_api(sender[0][0], recipient_array[2], message)
  end

  def display_search_result_for_sms(search_term,result_array)
    if result_array.length<1
      puts "found no result for "+search_term
      main_menu_command
    elsif result_array.length>1
      puts 'Which '+search_term+'?'
      prints_result_only(result_array)
      result_array[(gets.chomp.to_i-1)]
    else
      result_array[0]
    end
  end

  def add_new_contact(name, phone_number)
    clean_name = quote_string(name)
    clean_phone_number = quote_string(phone_number)
    new_contact_hash = { 'contact_name' => clean_name, 'contact_phoneNumber' => clean_phone_number }
    save_into_db('contacts_data', new_contact_hash)
  end

  def check_phone_number?(phone_number)
    phone_number = phone_number.to_i
    phone_number
  end

  def delete_search_result_for_sms(search_term, result_array)
    if result_array.length < 1
      puts ('found no result for ' + search_term).red
      main_menu_command
    else
      puts 'Which '.yellow + search_term.green + ' ?'.yellow
      prints_result_only(result_array)
      selected_number=gets.chomp
      if check_if_string_is_number(selected_number) == true
        display_selected_contact_for_del(result_array[(selected_number.to_i - 1)])
      else
        puts 'Oops! Invalid selection '.red
        main_menu_command
      end
    end
end

  def prints_result_only(result_array)
    for i in 0...(result_array.length)
      puts ('[' << (i + 1).to_s << '] ' << result_array[i][1]).green
    end
  end

  def display_search_result(search_term, result_array)
    if result_array.is_a?(NilClass)
      puts 'Oop! You dont have any contacts in your phonebook'.red
    else
    if result_array.length < 1
      puts 'found no result for ' + search_term.red
      main_menu_command
    elsif result_array.length > 1
      puts ('Which ' + search_term + '?').yellow
      prints_result_only(result_array)
      display_selected_index(result_array[(gets.chomp.to_i - 1)])
    else
      puts result_array[0][1] + ': ' + result_array[0][2].green
      puts 'to continue type your command or use -e to exist'.yellow
      main_menu_command
    end
  end
end

  def check_if_string_is_number(string)
    if string =~ /^\d+$/
      true
    else
      false
    end
  end

  def display_selected_contact_for_del(selected_array)
    if selected_array.is_a?(NilClass)
      puts 'Wrong value selected'.red
      main_menu_command
    else
      delete_contact_from_db(selected_array[0])
      puts 'Contact successfully deleted'.yellow
      puts 'to continue type your command or use -e to exist'.yellow
      main_menu_command
    end
  end

  def display_selected_index(selected_array)
    if selected_array.is_a?(NilClass)
      puts 'Wrong value selected'.red
      main_menu_command
    else
      puts (selected_array[1] << ': ' << selected_array[2]).green
      puts 'to continue type your command or use -e to exist'.yellow
      main_menu_command
    end
  end

  def search_contact(name)
    look_up_data(name)
  end

  # def display_search_result(listed_number)
  #   return_value = ''
  #   if listed_number.empty?
  #     return_value += 'Your search result has produced #{listedNumber.length}'
  #     return_value += ' results'
  #     return_value
  #   else
  #     false
  #   end
  # end
end
