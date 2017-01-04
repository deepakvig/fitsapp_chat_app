class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  rescue_from "AccessGranted::AccessDenied" do |exception|
    redirect_to root_path, alert: "You don't have permission to access this page."
  end
end
