Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'bars#top'
  get 'bars/index' => 'bars#index'

end
