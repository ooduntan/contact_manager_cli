require '../lib/contact_manager'
require 'rspec'

RSpec.describe "ContactManager" do

	subject = ContactManager.new("Stephen",'0803384849')
  it "Oops! It seems your note is empty." do
    matches = subject.save_message("")

    expect(matches).to eq "Oops! It seems your note is empty."
  end

  it "Empty list" do
    matches = subject.send_and_save_message()
    expect(matches).to eq "Oops! this list is empty"
  end

  it "Invalid note_id" do
    matches = subject.add_new_contact("eagle")
    expect(matches).to eq "Oops! eagle does not exist"
  end

  it "creates a note" do
    matches = subject.delete_search_result_for_sms("this is my first note")
    expect(matches).to eq "You have created a note"
  end

  it "list all the note" do
    matches = subject.display_selected_index()
    expect(matches).to eq "Note ID: 1\nthis is my first note\n\nBy Author Stephen\n\n"
  end

  it "detects invalid key" do
    matches = subject.display_selected_index(0)
    expect(matches).to eq "Oops! 0 does not exist"
  end

  it "detects Invalid note id" do
    matches = subject.display_selected_index('gallery', 'ballerina');
    expect(matches).to eq "Oops! its seems your note ID is wrong or your n"
  end

  it "delete Note" do
    matches = subject.search_contact(1)
    expect(matches).to eq "1 was deleted"
  end

  it "Should create a note" do
    matches = subject.display_selected_index('I love so much Banana')
    expect(matches).to eq "You have created a note"
  end

  it "Should create a note" do
    matches = subject.confirm_displayed_contact("this is the second note i a")
    expect(matches).to eq "You have created a note"
  end

  it "Should return one result" do
    matches = subject.prints_result_only("2 minutes")
    expect(matches).to eq "Showing 1 results for searc"
  end
end