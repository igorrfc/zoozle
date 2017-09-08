# ApplicationController - The application's main controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
end
