Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :usuarios
  resources :secciones
  resources :estudiantes

  get 'login/user', to: 'usuarios#user'

  scope 'auth' do
    post 'login' => 'usuario_token#create'
  end

end
