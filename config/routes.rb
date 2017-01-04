Rails.application.routes.draw do

  root 'home#index'
  devise_for :users
  
  get "mailbox/inbox" => "mailbox#inbox", as: :mailbox_inbox
  get "mailbox/sent" => "mailbox#sent", as: :mailbox_sent
  
  resources :conversations do
    member do
      post :reply
    end
  end

end
