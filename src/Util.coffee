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