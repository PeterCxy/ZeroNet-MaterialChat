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

  sendMessage: (message) ->
    data = await MaterialChat.getUserData()
    if !data?
      data = { message: [] } # Initialize
    data.message.push
      body: message
      date_added: Date.now()
    await MaterialChat.writeUserData data
    @loadMessages()
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
    first = no
    if @offset is -1
      @offset = @count - C.SQL_PAGE_LIMIT
      first = yes
    else
      if @count isnt oldCount
        @offset = @offset - (@count - oldCount) + 1
    
    # If near the bottom, automatically scroll to bottom
    scroll =
      (@container[0].scrollHeight - @container.scrollTop()) < (1.1 * @container.outerHeight())
    # Load new messages after calculating scrollTop
    await @nextPage yes, Number.MAX_SAFE_INTEGER
    if first or scroll
      @container.animate { scrollTop: @elem.height() }, 'slow'
  
  onLoadMore: (ev) =>
    ev.preventDefault()
    oldOffset = @offset
    @offset = @offset - C.SQL_PAGE_LIMIT
    if @offset < 0
      @offset = 0
    @nextPage()
    
MessageList = new MessageListImpl
export default MessageList