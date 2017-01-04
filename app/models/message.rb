class Message < ApplicationRecord
  belongs_to :author, :class_name => "User"
  has_many :message_copies, dependent: :destroy
  has_many :recipients, :through => :message_copies, dependent: :destroy
  before_create :prepare_copies
  
  validates_presence_of :body
  
  validate :recipients_cannot_be_empty
  
  attr_accessor  :to
  
  def mark_as_read( user )
    msg = self.message_copies.find_by(recipient_id: user.id) 
    msg.read = true
    msg.save
  end
  
  def recipients_cannot_be_empty
    if to.blank?
      errors.add(:recipients, "can't be blank")
    end
  end
  
  def prepare_copies    
    [to].flatten.reject { |id| id.empty? }.each do |recipient|
      recipient = User.find(recipient) unless recipient.blank?
      message_copies.build(:recipient_id => recipient.id)
    end
  end
end
