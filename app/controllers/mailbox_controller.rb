class MailboxController < ApplicationController
  before_action :authenticate_user!

  def inbox
    @inbox = current_user.received_messages
    @unread_count = current_user.received_messages.reject(&:read?).count
    @active = :inbox
  end
  
  def sent
    @sent = current_user.sent_messages
    @unread_count = current_user.received_messages.reject(&:read?).count
    @active = :sent
  end
end