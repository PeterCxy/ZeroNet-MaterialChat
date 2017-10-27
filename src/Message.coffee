import Avatar from "avatar-initials"
import timeago from "timeago.js"
import $ from "jquery"
import MaterialChat from "./MaterialChat.coffee"
import * as C from "./Constant.coffee"

AVATAR_CACHE = {}

class Message
  constructor: (@username, @message, @timestamp) ->
    @elem = null
    @elemAvatar = null
    @initial = null

  getAvatarBorder: ->
    C.MSG_AVATAR_BORDERS[@username.hashCode() % C.MSG_AVATAR_BORDERS.length]

  render: ->
    template = $('#message-template').html()

    # Replace avatar border
    template = template.replace '{{border}}', @getAvatarBorder()

    # Create element
    @elem = $(template)

    # Render username
    @elem.find('#username').text @username

    # Render Message and keep new lines
    elemMsg = @elem.find '#message'
    elemMsg.text @message
    html = elemMsg.html().replace /\n/g, '<br>'

    # Highlight mentions
    html = html.replace /(\S+)@(\S+)\.bit( |:|)/g, "<span class=\"mention-other\">$1@$2.bit$3</span>"
    regex = new RegExp RegExp.quote(MaterialChat.site_info.cert_user_id), 'g'
    html = html.replace regex, "<span class=\"mention\">#{MaterialChat.site_info.cert_user_id}</span>"
    elemMsg.html html

    # Render time
    @elem.find('#timestamp').text timeago().format @timestamp

    # Render avatar
    @elemAvatar = @elem.find('#avatar')
    @initial = @username[0...1].toUpperCase()
    @renderAvatar()

    # Bind click-to-reply
    @elem.find('#username').click @clickToReply

    return @elem

  renderAvatar: ->
    if AVATAR_CACHE[@initial]?
      @elemAvatar.attr 'src', AVATAR_CACHE[@initial]
    else
      new Avatar @elemAvatar[0],
        useGravatar: no
        initials: @initial
      AVATAR_CACHE[@initial] = @elemAvatar.attr 'src'

  clickToReply: (ev) =>
    ev.preventDefault()
    input = $('#message-input')
    if input.val().trim() is ''
      input.val @username + ': '
      input.focus()

export default Message