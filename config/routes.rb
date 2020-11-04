Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :usuarios
  resources :secciones
  resources :estudiantes, only: [:index, :create]
  get 'estudiantes/sin_grupo', to: 'estudiantes#sin_grupo'

  resources :grupos, only: [:index, :create, :show]
  post 'grupos/ultimo_grupo', to: 'grupos#ultimo_grupo'

  resources :jornadas, only: [:index]
  resources :tipo_minutas
  resources :tipo_asistencias

  get 'login/user', to: 'usuarios#user'

  scope 'auth' do
    post 'login' => 'usuario_token#create'
  end

end
