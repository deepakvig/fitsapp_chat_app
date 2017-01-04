require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:entity1)  { FactoryGirl.create(:user) }
  let!(:entity2)  { FactoryGirl.create(:admin) }
  
  it "should validate presence of email" do
    user = build(:user, email: nil)
    
    expect(user).not_to be_valid
  end
  
  it "should error message of email" do
    user = build(:user, email: entity1.email)
    user.valid?
    expect(user.errors.full_messages[0]).to eq("Email has already been taken")
  end
  
  it {User.reflect_on_association(:sent_messages).macro.should  eq(:has_many)}
  it {User.reflect_on_association(:received_messages).macro.should  eq(:has_many)}
  
  it "should be able to have admin role" do
    expect(entity2.is_admin?).to eq(true)
  end
  
  it "should be able to have user role" do
    expect(entity1.user_role).to eq('USER')
  end
  
end
