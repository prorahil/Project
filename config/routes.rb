Rails.application.routes.draw do
  resources :instructors
  resources :users
  resources :students
  resources :registrations
  resources :families
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
