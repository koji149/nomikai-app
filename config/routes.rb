Rails.application.routes.draw do
  mount_roboto
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/sitemap', to: redirect("https://#{ENV['S3_BUCKET_NAME']}.s3-ap-northeast-1.amazonaws.com/sitemap.xml.gz")
  root 'bars#top'
  get 'bars/index' => 'bars#index'
end