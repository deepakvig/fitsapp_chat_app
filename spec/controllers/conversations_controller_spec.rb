require 'rails_helper'

RSpec.describe ConversationsController, type: :controller do
  let!(:entity1)  { FactoryGirl.create(:user, email: 'anc@example.com') }
  let!(:entity2)  { FactoryGirl.create(:user, email: 'anc1@example.com') }
  let!(:entity3)  { FactoryGirl.create(:user, email: 'anc2@example.com', is_admin: true) }
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
  
  describe "POST #create" do
    it "requires login" do
      message_attributes = FactoryGirl.attributes_for(:message)
      
      expect {
            post :create, { message: message_attributes }
          }.to_not change(Message, :count)
      
      
      expect(response).to redirect_to '/users/sign_in'
    end
    
    it "doesnot create Conversation with invalid parameters" do
      login_with entity2
      
      message_attributes = FactoryGirl.attributes_for(:message)
      
      expect {
            post :create, { message: message_attributes }
          }.to_not change(Message, :count)
          
      expect( response ).to  render_template :new
    end
    
    it "accepts valid parameters" do
      login_with entity2
      
      message_attributes = FactoryGirl.attributes_for(:message, to: entity1.id.to_s)
      
      expect {
            post :create, { message: message_attributes }
          }.to change(Message, :count).by(1)
          
      expect( response ).to redirect_to mailbox_inbox_path    
    end
  end
  
  describe "PUT #update" do
    it "requires login" do
      message_attributes = FactoryGirl.attributes_for(:message)
      
      expect {
            put :update, id: message1.id, message: message_attributes 
          }.to_not change(Message, :count)
      
      
      expect(response).to redirect_to '/users/sign_in'
    end
    
    it "doesnot create Conversation with invalid parameters" do
      login_with entity2
      
      message_attributes = FactoryGirl.attributes_for(:message)
      
      expect {
        put :update, id: message1.id, message: message_attributes 
      }.to_not change(Message, :count)
    end
    
    it "doesnot accepts valid parameters for normal user" do
      login_with entity2
      
      message_attributes = FactoryGirl.attributes_for(:message, body: 'SomeBody', to: entity1.id.to_s)
      
      put :update, id: message1.id, message: message_attributes 
      
      expect(message1.reload.body).not_to eql 'SomeBody'
      
    end
    
    it "accepts valid parameters for admin user" do
      login_with entity3
      
      message_attributes = FactoryGirl.attributes_for(:message, body: 'SomeBody', to: entity1.id.to_s)
      
      put :update, id: message1.id, message: message_attributes 
      
      expect(message1.reload.body).to eql 'SomeBody'
          
      expect( response ).to redirect_to mailbox_inbox_path     
    end
  end
end
