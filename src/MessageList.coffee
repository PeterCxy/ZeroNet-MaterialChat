import MaterialChat from './MaterialChat.coffee'
import Message from './Message.coffee'
import $ from 'jquery'
import * as C from './Constant.coffee'

class MessageListImpl
  constructor: ->
    @elem = $('.container-messages')
    @container = $('.container-main')
    @count = 0
    @offset = -1
    @loadMore = null
    @loadMoreTemplate = $('#message-load-more-template').html()
    @firstLimit = C.SQL_PAGE_LIMIT

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

  nextPage: (clear = no, limit = C.SQL_PAGE_LIMIT) =>
    @loadMore?.remove()
    messages = await MaterialChat.cmdp 'dbQuery',
      [C.SQL_GET_ALL_MESSAGES + ' LIMIT ' + limit + ' OFFSET ' + @offset]
    messages = messages.reverse()
    @elem.html('') if clear
    messages.forEach (it) =>
      @elem.append new Message(it.cert_user_id, it.body, it.date_added).render()
    if @offset > 0
      @loadMore = $(@loadMoreTemplate)
      @loadMore.find('#load-more').click @onLoadMore
      @elem.append @loadMore

  loadMessages: =>
    resCount = await MaterialChat.cmdp 'dbQuery', [C.SQL_GET_MESSAGE_COUNT]
    oldCount = @count
    @count = resCount[0]['COUNT(*)']
    if @offset is -1
      @offset = @count - C.SQL_PAGE_LIMIT
    else
      if @count isnt oldCount
        @offset = @offset - (@count - oldCount) + 1
        @firstLimit = @firstLimit + (@count - oldCount)
    
    # TODO: Introduce OFFSET for scrolling up & down
    await @nextPage yes, @firstLimit
    @container.animate { scrollTop: @elem.height() }, 'slow'
  
  onLoadMore: (ev) =>
    ev.preventDefault()
    oldOffset = @offset
    @offset = @offset - C.SQL_PAGE_LIMIT
    if @offset < 0
      @offset = 0
    @firstLimit = @firstLimit + oldOffset - @offset
    @nextPage()
    
MessageList = new MessageListImpl
export default MessageList