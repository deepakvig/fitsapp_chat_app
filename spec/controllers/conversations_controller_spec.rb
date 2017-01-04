require 'rails_helper'

RSpec.describe ConversationsController, type: :controller do
  let!(:entity1)  { FactoryGirl.create(:user, email: 'anc@example.com') }
  let!(:entity2)  { FactoryGirl.create(:user, email: 'anc1@example.com') }
  let!(:message1) { entity1.sent_messages.create(body: "Body", to: entity2.id.to_s) }
  
  describe "GET #show" do
    before(:each) do
      login_with entity2
    end

    it "assigns the requested message to @conversation" do
      get :show, { id: message1.id }
      assigns(:conversation).should eq(message1)
    end
    it "renders the :show template" do
      get :show, { id: message1.id }
      expect( response ).to render_template( :show )
    end
  end
  
  describe "GET #new" do
    before(:each) do
      login_with entity2
    end
    
    it "assigns a new Contact to @contact" do
      get :new
      assigns(:conversation).should be_a(Message)
    end
    
    it "renders the :new template" do
      get :new, { id: message1.id }
      expect( response ).to render_template( :new )
    end
  end
end
