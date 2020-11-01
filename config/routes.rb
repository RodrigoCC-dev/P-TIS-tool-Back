Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :usuarios
  resources :secciones
  resources :estudiantes, only: [:index, :create]
  get 'estudiantes/sin_grupo', to: 'estudiantes#sin_grupo'

  resources :grupos, only: [:index]
  post 'grupos/por_jornada', to: 'grupos#por_jornada'

  resources :jornadas, only: [:index]

  get 'login/user', to: 'usuarios#user'

  scope 'auth' do
    post 'login' => 'usuario_token#create'
  end

end
