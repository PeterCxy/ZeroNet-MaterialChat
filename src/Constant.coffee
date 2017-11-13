import MaterialChat from './MaterialChat.coffee'

export PATH_USER_CONTENT = "data/users/content.json"
export PATH_USER_INNER_DATA = "data/users/{{user}}/data.json"
export PATH_USER_INNER_CONTENT = "data/users/{{user}}/content.json"
export PATH_USER_UPLOADED_CONTENT = "data/users/{{user}}/content/"
export PATH_USER_UPLOADED_CONTENT_RELATIVE = "content/"

export ID_PROVIDERS = [] # we will load it later from content.json

export SQL_PAGE_LIMIT = 15
export SQL_GET_MESSAGE_COUNT = "SELECT COUNT(*) FROM message"
export SQL_GET_ALL_MESSAGES =
  "SELECT * FROM message LEFT JOIN json USING (json_id) LEFT JOIN " +
  "(SELECT value as avatar, json_id FROM keyvalue WHERE key = 'avatar') USING (json_id) " +
  "ORDER BY date_added ASC"
export SQL_GET_UPLOADED_AVATAR =
  "SELECT value FROM keyvalue LEFT JOIN json USING (json_id) " +
  "WHERE key = 'avatar' AND directory=\"users/{{user}}\""

export MSG_AVATAR_BORDERS = [
  'primary',
  'secondary',
  'success',
  'danger',
  'warning',
  'info'
]

export CONF_OPTIONAL_FILE_PATTERN = "content/.+\\.jpg"

export initialize = ->
  content = JSON.parse await MaterialChat.cmdp 'fileGet',
    inner_path: PATH_USER_CONTENT
    required: yes

  # Get ID_PROVIDERS from content.json
  Object.keys(content.user_contents.cert_signers).forEach (it) ->
    ID_PROVIDERS.push it