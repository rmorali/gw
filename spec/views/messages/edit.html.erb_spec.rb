require 'spec_helper'

describe "messages/edit" do
  before(:each) do
    @message = assign(:message, stub_model(Message,
      :sender => 1,
      :receiver => 1,
      :title => "MyString",
      :body => "MyText"
    ))
  end

  it "renders the edit message form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", message_path(@message), "post" do
      assert_select "input#message_sender[name=?]", "message[sender]"
      assert_select "input#message_receiver[name=?]", "message[receiver]"
      assert_select "input#message_title[name=?]", "message[title]"
      assert_select "textarea#message_body[name=?]", "message[body]"
    end
  end
end
