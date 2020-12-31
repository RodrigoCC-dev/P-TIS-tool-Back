Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :usuarios, only: [:index]
  resources :secciones, only: [:index]
  resources :estudiantes, only: [:index, :create, :show]
  get 'estudiantes/asignacion/sin_grupo', to: 'estudiantes#sin_grupo'

  resources :stakeholders, only: [:index, :create, :show]
  resources :profesores, only: [:index, :create]

  resources :grupos, only: [:index, :create, :show]
  post 'grupos/ultimo_grupo', to: 'grupos#ultimo_grupo'

  resources :jornadas, only: [:index]
  resources :tipo_minutas, only: [:index]
  resources :tipo_asistencias, only: [:index]
  resources :tipo_items, only: [:index]
  resources :tipo_estados, only: [:index]
  resources :motivos, only: [:index]
  resources :semestres, only: [:index]
  resources :minutas, only: [:create, :show, :update]
  get 'minutas/correlativo/:id', to: 'minutas#correlativo'
  get 'minutas/grupo/:id', to: 'minutas#por_grupo'
  get 'minutas/revision/estados', to: 'minutas#por_estados'
  get 'minutas/revision/grupo', to: 'minutas#revision_grupo'
  get 'minutas/revision/cliente', to: 'minutas#revision_cliente'
  get 'minutas/revision/respondidas', to: 'minutas#por_respuestas'

  resources :comentarios, only: [:create, :show]
  resources :tipo_aprobaciones, only: [:index]
  resources :respuestas, only: [:create, :show]
  resources :aprobaciones, only: [:show, :update]
  resources :registros, only: [:show]

  resources :usuarios, only: [:update]
  get 'login/user', to: 'usuarios#user'

  scope 'auth' do
    post 'login' => 'usuario_token#create'
  end

end
