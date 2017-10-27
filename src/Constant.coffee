import MaterialChat from './MaterialChat.coffee'

export PATH_USER_CONTENT = "data/users/content.json"

export ID_PROVIDERS = [] # we will load it later from content.json

export initialize = ->
  content = JSON.parse await MaterialChat.cmdp 'fileGet',
    inner_path: PATH_USER_CONTENT
    required: yes

  # Get ID_PROVIDERS from content.json
  Object.keys(content.user_contents.cert_signers).forEach (it) ->
    ID_PROVIDERS.push it