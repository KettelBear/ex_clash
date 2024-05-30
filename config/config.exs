import Config

secrets_path = Path.join(__DIR__, "#{config_env()}.secret.exs")
if File.exists?(secrets_path) do
  import_config(secrets_path)
end
