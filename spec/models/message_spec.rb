require 'rails_helper'

RSpec.describe Message, type: :model do
  let!(:entity1)  { FactoryGirl.create(:user) }
  let!(:entity2)  { FactoryGirl.create(:user) }
  let!(:entity3)  { FactoryGirl.create(:user) }
  let!(:message1) { entity1.sent_messages.create(body: "Body", to: entity2.id.to_s) }

  it "should validate presence of message body" do
    message = build(:message)
    
    expect(message).not_to be_valid
  end
  
  it { Message.reflect_on_association(:author).macro.should  eq(:belongs_to)}
  it { Message.reflect_on_association(:recipients).macro.should  eq(:has_many)}
  it { Message.reflect_on_association(:message_copies).macro.should  eq(:has_many)}
  
  it "should have proper original message" do
    expect(message1.body).to eq "Body"
  end

  it "should have proper sender" do
    expect(message1.author).to eq entity1
  end

  it "should have proper recipients" do
    expect(message1.recipients).to include(entity2)
  end

  it "should be able to be marked as read" do
    message1.mark_as_read(entity2)
    expect(message1.message_copies.find_by(recipient_id: entity2.id).read).to be true
  end

  describe "Mailbox" do
    let(:participant) { FactoryGirl.create(:user) }
    let!(:inbox_conversation) { entity1.sent_messages.create(to: participant.id.to_s, body: "Body", subject: "Subject") }
    let!(:sentbox_conversation) { participant.received_messages }

    describe ".chats" do
      it "finds chats with receipts for participant" do
        expect(participant.received_messages.first.id).to be sentbox_conversation.first.id
      end
    end

    describe ".sentbox" do
      it "finds sentbox conversations with receipts for participant" do
        expect(entity1.sent_messages).to include inbox_conversation
      end
    end

    describe ".trash" do
      it "finds trash conversations with receipts for participant" do
      end
    end

    describe ".unread" do
      it "finds unread conversations using scope" do
        expect(User.unread_messages(participant).count).to eq 1

      end
    end
  end
end
