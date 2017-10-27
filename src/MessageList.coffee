import MaterialChat from './MaterialChat.coffee'
import Message from './Message.coffee'
import $ from 'jquery'
import * as C from './Constant.coffee'

class MessageListImpl
  constructor: ->
    @elem = $('.container-messages')
    @container = $('.container-main')

  sendMessage: (message) ->
    data = await MaterialChat.getUserData()
    if !data?
      data = { message: [] } # Initialize
    else
      data = JSON.parse data
    data.message.push
      body: message
      date_added: Date.now()
    await MaterialChat.writeUserData data
    await MaterialChat.publishUserContent()

  loadMessages: =>
    messages = await MaterialChat.cmdp 'dbQuery', [C.SQL_GET_ALL_MESSAGES]
    @elem.html('') # Clear it
    messages.forEach (it) =>
      @elem.append new Message(it.cert_user_id, it.body, it.date_added).render()
    @container.animate { scrollTop: @container.height() }, 'slow'

MessageList = new MessageListImpl
export default MessageList