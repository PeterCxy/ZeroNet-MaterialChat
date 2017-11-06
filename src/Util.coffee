String::hashCode = ->
  hash = 0
  if @length is 0 then return hash
  for i in [0...@length]
    char = @charCodeAt i
    hash = ((hash << 5) - hash) + char
    hash = hash | 0
  return hash

RegExp.quote = (str) ->
  str.replace(/([.?*+^$[\]\\(){}|-])/g, "\\$1")

export readDataURL = (file) ->
  new Promise (resolve, reject) ->
    reader = new FileReader()
    reader.onload = (e) ->
      resolve e.target.result
    reader.readAsDataURL file

STR_DICTIONARY = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
export randomStr = (len) ->
  [1..len]
    .map ->
      STR_DICTIONARY.charAt Math.floor(Math.random() * STR_DICTIONARY.length)
    .join ''