# this class handles the  search and add
require_relative 'data_manager'
require 'open-uri'
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

  def self.purify_number(number)
    unless is_num_str?(number)
      puts 'Invalid phone Number. Try again'
      number = gets.chomp
      purify_number(number)
    end
    number
 end

  def send_sms_using_api(sender, recipient_number, clean_message)
    server_response = open('http://api.smartsmssolutions.com/smsapi.php?username=ITVessel&password=tomboy&sender=' + sender + '&recipient=' + recipient_number + '&message=' + clean_message + '')
    server_response.status
  end

  def search_all_message
    bring_all_message
  end

  def display_message_result(message_result_data)
    if message_result_data.length < 1
      puts 'Oops! message box empty'
    else
      puts ('Found ' + message_result_data.length.to_s + ' messages').yellow
      counter = 1
      message_result_data.each do |each_message_data|
        user_name = get_user_name_from_id(each_message_data[1].to_i)
        puts "[#{counter}] Sent to: ".yellow + user_name[0][2].green + "\nName: ".yellow + user_name[0][1].green + "\nmessage: ".yellow + each_message_data[2].green + "\n\n".yellow
        counter += 1
      end
    end
  end

  private

  def save_message(contact_idx, message)
    clean_message = quote_string(message)
    new_message_hash = { 'contact_idx' => contact_idx, 'message' => clean_message }
    save_into_db('contacts_message_data', new_message_hash)
  end

  def send_and_save_message(recipient_array, message)
    save_message(recipient_array[0], message)
    send_sms_using_api(sender, recipient_array[0], message)
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

  def search_contact(name)
    look_up_data(name)
  end

  def display_search_result(listed_number)
    return_value = ''
    if listed_number.empty?
      return_value += 'Your search result has produced #{listedNumber.length}'
      return_value += ' results'
      return_value
    else
      false
    end
  end
end
