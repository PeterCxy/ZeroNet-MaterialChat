import MaterialChat from './MaterialChat.coffee'
import $ from 'jquery'

class MessageListImpl
  constructor: ->
    @elem = $('.container-messages')

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

MessageList = new MessageListImpl
export default MessageList