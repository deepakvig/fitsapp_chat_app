require 'rails_helper'

RSpec.describe MessageCopy, type: :model do
  let!(:entity1)  { FactoryGirl.create(:user) }
  let!(:entity2)  { FactoryGirl.create(:user) }
  let!(:entity3)  { FactoryGirl.create(:user) }
  let!(:message1) { entity1.sent_messages.create(body: "Body", to: entity2.id.to_s) }

  it "should validate presence of recipient" do
    message_copy = build(:message_copy, recipient_id: nil)
    
    expect(message_copy).not_to be_valid
  end
  
  it { MessageCopy.reflect_on_association(:recipient).macro.should  eq(:belongs_to)}
  it { MessageCopy.reflect_on_association(:message).macro.should  eq(:belongs_to)}
end
