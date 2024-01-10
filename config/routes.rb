Rails.application.routes.draw do
  root 'home#index'

  mount ActionCable.server => '/cable'

  post 'email_validator/validate'
end
