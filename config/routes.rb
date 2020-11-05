Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :usuarios
  resources :secciones
  resources :estudiantes, only: [:index, :create, :show]
  get 'estudiantes/sin_grupo', to: 'estudiantes#sin_grupo'

  resources :grupos, only: [:index, :create, :show]
  post 'grupos/ultimo_grupo', to: 'grupos#ultimo_grupo'

  resources :jornadas, only: [:index]
  resources :tipo_minutas, only: [:index]
  resources :tipo_asistencias, only: [:index]
  resources :tipo_items, only: [:index]
  resources :tipo_estados, only: [:index]
  resources :motivos, only: [:index]
  resources :semestres, only: [:index]
  resources :minutas, only: [:create]
  get 'minutas/correlativo/:id', to: 'minutas#correlativo'

  get 'login/user', to: 'usuarios#user'

  scope 'auth' do
    post 'login' => 'usuario_token#create'
  end

end
