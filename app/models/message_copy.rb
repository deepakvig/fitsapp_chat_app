class MessageCopy < ApplicationRecord
  belongs_to :message
  belongs_to :recipient, :class_name => "User"
  delegate  :author, :created_at, :subject, :body, :recipients, :to => :message
  
  validates_presence_of :recipient_id
  
  default_scope { order(created_at: :desc) }
  
end
