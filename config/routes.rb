Rails.application.routes.draw do
  devise_for :users, controllers: {   registrations: 'users/registrations',
    sessions: 'users/sessions', omniauth_callbacks: 'users/omniauth_callbacks' }

  mount_roboto
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/sitemap', to: redirect("https://#{ENV['S3_BUCKET_NAME']}.s3-ap-northeast-1.amazonaws.com/sitemap.xml.gz")
  root 'bars#top'
  get 'bars/index' => 'bars#index'
  get 'bars/getposition' => 'bars#getposition'
  resources :users, only: [:show, :edit, :update]
  resources :meetings
  
  get '*not_found' => 'application#routing_error'
  post '*not_found' => 'application#routing_error'
end