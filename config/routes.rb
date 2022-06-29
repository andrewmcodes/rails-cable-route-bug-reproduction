Rails.application.routes.draw do
  root "test#index"

  get "/cable-hyphenated-slug", to: "test#index"
  get "/cable_underscored_slug", to: "test#index"
  get "/cable_mixed-slug", to: "test#index"
end
