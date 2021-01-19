Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "welcome#index"

  get '/:short_key' => 'welcome#s_url', as: :s_url  
  get '/:short_key/admin'	=> 'welcome#admin', as: :admin
  get '/:short_key/block'	=> 'welcome#block', as: :block
  resources :welcome
end
