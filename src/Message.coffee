import Avatar from "avatar-initials"
import $ from "jquery"

AVATAR_CACHE = {}

class Message
  constructor: (@username, @message) ->
    @elem = null
    @elemAvatar = null
    @initial = null

  render: ->
    template = $('#message-template').html()

    # Create element
    @elem = $(template)

    # Render username
    @elem.find('#username').text @username

    # Render Message and keep new lines
    elemMsg = @elem.find '#message'
    elemMsg.text @message
    elemMsg.html elemMsg.html().replace /\n/g, '<br>'

    # Render avatar
    @elemAvatar = @elem.find('#avatar')
    @initial = @username[0...1].toUpperCase()
    @renderAvatar()

    return @elem

  renderAvatar: ->
    if AVATAR_CACHE[@initial]?
      @elemAvatar.attr 'src', AVATAR_CACHE[@initial]
    else
      new Avatar @elemAvatar[0],
        useGravatar: no
        initials: @initial
      AVATAR_CACHE[@initial] = @elemAvatar.attr 'src'

export default Message