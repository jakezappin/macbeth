Rails.application.routes.draw do

  root to: 'static#index'

  get 'display', to: 'static#display'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
