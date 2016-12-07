Safecast::Application.configure do
  config.cache_classes = true

  config.consider_all_requests_local       = false

  config.action_controller.perform_caching = true

  config.serve_static_assets = true

  config.assets.compress = true
  config.assets.compile = false
  config.assets.digest = true

  config.logger = Logger.new(STDOUT)
  config.log_level = :info

  config.assets.precompile += %w(dobro.css worldmap.js prettify.css prettify/prettify.js api_docs.js)

  config.action_mailer.raise_delivery_errors = false

  config.i18n.fallbacks = true

  config.active_support.deprecation = :notify

  config.action_mailer.delivery_method = :ses
  config.action_mailer.default_url_options = {
    host: 'api.safecast.org',
    protocol: 'https'
  }

  config.log_tags = [:uuid, :remote_ip]

  config.eager_load = true
end
