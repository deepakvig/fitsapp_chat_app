class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  ROLES = {
    0 => 'USER', 
    1 => 'TRAINER'
  }
  
  has_many :sent_messages, :class_name => "Message", :foreign_key => "author_id"
  has_many :received_messages, :class_name => "MessageCopy", :foreign_key => "recipient_id"
  
  scope :unread_messages, -> (user) { user.received_messages.where(read: false) }
  
  before_create :set_default_role
  
  def user_role
    is_admin? ? 'ADMIN' : User::ROLES[role]
  end
  
  private
  def set_default_role
    self.role ||= 0
  end
  
end
