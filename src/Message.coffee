import Avatar from "avatar-initials"
import $ from "jquery"

class Message
  constructor: (@username, @message) ->
    @elem = null

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
    # TODO: Cache result
    new Avatar @elem.find('#avatar')[0],
      useGravatar: no
      initials: @username[0...1].toUpperCase()

    return @elem

export default Message