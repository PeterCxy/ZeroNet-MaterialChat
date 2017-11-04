import Avatar from "avatar-initials"
import timeago from "timeago.js"
import linkifyHtml from "linkifyjs/html"
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
    elemMsg.html @renderMessageContent elemMsg.html()
    @fixLinks elemMsg

    # Render time
    @elem.find('#timestamp').text timeago().format @timestamp

    # Render avatar
    @elemAvatar = @elem.find('#avatar')
    @initial = @username[0...1].toUpperCase()
    @renderAvatar()

    # Bind click-to-reply
    @elem.find('#username').click @clickToReply

    return @elem

  renderMessageContent: (html) ->
    selfMentionRegex = new RegExp RegExp.quote(MaterialChat.site_info.cert_user_id), 'g'
    html = html.replace /\n/g, '<br>'
      # Highlight mentions
      .replace /(\S+)@(\S+)\.bit( |:|)/g, "<span class=\"mention-other\">$&</span>"
      .replace selfMentionRegex, "<span class=\"mention\">#{MaterialChat.site_info.cert_user_id}</span>"

    # Auto-linkify
    linkifyHtml html,
      format: (url, type) ->
        if type is 'url'
          url.replace 'http://127.0.0.1:43110/', '0net://' # ZeroNet links
        else
          url
      formatHref: (href, type) ->
        if type is 'url'
          href.replace 'http://127.0.0.1:43110/', '/' # ZeroNet links
        else
          href

  renderAvatar: ->
    # TODO: Load custom avatar if available
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

  fixLinks: (elem) ->
    # Opening new window from iframe is highly restricted.
    # Call the wrapper for this purpose.
    # TODO: DO NOT apply this for links that are not target="_blank"
    elem.find('a').click (ev) ->
      ev.preventDefault()
      MaterialChat.cmd 'wrapperOpenWindow', [$(@).attr('href'), '_blank']

export default Message