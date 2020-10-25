Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :sesiones

  scope 'auth' do
    post 'login' => 'usuario_token#create'
  end

end
