Rails.application.routes.draw do
  get "static_pages/home"
  get "static_pages/help"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Khi chuyển route thì nội dung của trang web sẽ hiển thị theo default locale-> Để hiển thị theo nhiều ngôn ngữ ta cấu hình router như sau:
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    resources :home
    root 'static_pages#home'
  end
end


