class Message < ApplicationRecord
  belongs_to :author, :class_name => "User"
  has_many :message_copies, dependent: :destroy
  has_many :recipients, :through => :message_copies
  before_save :prepare_copies
  
  validates_presence_of :body
  
  validate :recipients_cannot_be_empty
  
  default_scope { order(updated_at: :desc) }
  
  attr_accessor  :to
  
  def mark_as_read( user )
    msg = self.message_copies.find_by(recipient_id: user.id) 
    if msg
      msg.read = true
      msg.save
    end
  end
  
  def recipients_cannot_be_empty
    if to.blank?
      errors.add(:recipients, "can't be blank")
    end
  end
  
  def prepare_copies
    if self.new_record?
      [to].flatten.reject { |id| id.empty? }.each do |recipient|
        recipient = User.find(recipient) unless recipient.blank?
        message_copies.build(:recipient_id => recipient.id)
      end
    else
      message_copies.delete_all
      [to].flatten.reject { |id| id.empty? }.each do |recipient|
        recipient = User.find(recipient) unless recipient.blank?
        message_copies.create(:recipient_id => recipient.id)
      end
    end
  end
end
