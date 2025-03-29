Rails.application.routes.draw do
  get "calendario/index"
  resource :session
  resources :passwords, param: :token
  
  # Ruta para verificar estado de la app
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Ruta para archivos PWA (si decides activarlo)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Ruta raíz y dashboard
  root "pages#home"
  get "dashboard" => "pages#dashboard"
  resources :pacientes do
    resources :medical_records
  end
  resources :sales


  # Nuevas rutas añadidas
  get "calendario" => "calendario#index", as: :calendario
  get "historial" => "pacientes#edit", as: :historial
  # Rutas para pacientes
  resources :pacientes
end
