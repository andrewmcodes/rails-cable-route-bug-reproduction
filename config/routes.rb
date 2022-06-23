Rails.application.routes.draw do
  root "pages#index"

  get "/cable-hyphenated-slug", to: "pages#index"
  get "/cable_underscored_slug", to: "pages#index"
  get "/cable_mixed-slug", to: "pages#index"
end
