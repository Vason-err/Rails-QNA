Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://0.0.0.0:3000'
    resource(
      '*',
      headers: :any,
      methods: [:get, :patch, :put, :delete, :post, :options]
    )
  end
end