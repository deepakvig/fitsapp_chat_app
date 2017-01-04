require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:entity1)  { FactoryGirl.create(:user) }
  
  it "should validate presence of email" do
    user = build(:user, email: nil)
    
    expect(user).not_to be_valid
  end
  
  it "should validate presence of email" do
    user = build(:user, email: entity1.email)
    user.valid?
    expect(user.errors.full_messages[0]).to eq("Email has already been taken")
  end
  
  it {User.reflect_on_association(:sent_messages).macro.should  eq(:has_many)}
  it {User.reflect_on_association(:received_messages).macro.should  eq(:has_many)}
  
end
