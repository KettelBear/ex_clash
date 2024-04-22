import Config

#TODO: Get the secret loaded in a secret env.
# Read the article on how to test REQ without
# actually hitting the API
import_config("#{config_env()}.secret.exs")
