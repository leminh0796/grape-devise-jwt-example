Rails.application.routes.draw do
  devise_for :users, skip: :all
  mount Root, at: '/'
  mount Rswag::Ui::Engine => '/api-docs' unless Rails.env.production?
end
