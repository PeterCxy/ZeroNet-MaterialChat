import "./Util.coffee"
import ZeroFrame from "./ZeroFrame.coffee"
import Message from "./Message.coffee"
import MessageList from "./MessageList.coffee"
import LoginDialog from "./LoginDialog.coffee"
import AvatarChooser from "./AvatarChooser.coffee"
import * as C from './Constant.coffee'
import $ from 'jquery'

class MaterialChatImpl extends ZeroFrame
  init: ->
    @site_info = null
    console.log "MaterialChat initialized."

  onOpenWebsocket: () =>
    C.initialize()
    @cmd "siteInfo", {}, @siteInfoChanged # Intialize siteInfo
    $('container-main').focus()
    $('#button-send').on 'click', @onSendMessage
    $('#switch-user').click LoginDialog.selectUser
    $('#set-avatar').click AvatarChooser.show
    $('#message-form').submit @onSendMessage

  onRequest: (cmd, msg) =>
    switch cmd
      when "setSiteInfo" then @siteInfoChanged msg
      else super.onRequest cmd, msg

  siteInfoChanged: (info) =>
    return if !info?
    #console.log info
    @site_info = info
    $('title').text @site_info.content.title
    $('#title').text @site_info.content.title
    if !@site_info.cert_user_id?
      LoginDialog.tryLogin()
    else
      LoginDialog.dismiss()
      $('#current-user').text "Current: " + @site_info.cert_user_id
      MessageList.loadMessages()

  onSendMessage: (ev) ->
    ev.preventDefault()
    msgInput = $('#message-input')
    message = msgInput.val().trim()
    msgInput.val ''
    if message isnt ''
      await MessageList.sendMessage message

  # Replace the placeholder '{{user}}' with the actual address
  replaceUserAuth: (str) => str.replace '{{user}}', @site_info.auth_address
  getUserFilePath: (file) => @replaceUserAuth file

  # Get content of file ({{user}} will be replaced by user's address)
  getUserFile: (file, required = no) =>
    @cmdp 'fileGet',
      inner_path: @getUserFilePath file
      required: required

  # Write base64-encoded data to file ({{user}} will be replaced by user's address)
  writeUserFile: (file, data) =>
    res = await @cmdp 'fileWrite', [@getUserFilePath(file), data]
    if res isnt 'ok'
      await @cmdp 'wrapperNotification', ["error", "File write error #{res.error}"]
    return res

  deleteUserFile: (file) =>
    res = await @cmdp 'fileDelete', [@getUserFilePath(file)]
    if res isnt 'ok'
      await @cmdp 'wrapperNotification', ["error", "File delete error #{res.error}"]
    return res

  getUserFileJSON: (file, required = no) =>
    try
      return JSON.parse await @getUserFile(file, required)
    catch e
      return null

  writeUserFileJSON: (file, obj) =>
    json_raw = unescape encodeURIComponent JSON.stringify(obj, undefined, '\t')
    @writeUserFile file, btoa(json_raw)

  # Shorthands for data.json
  getUserData: (required = no) => @getUserFileJSON C.PATH_USER_INNER_DATA, required
  writeUserData: (obj) => @writeUserFileJSON C.PATH_USER_INNER_DATA, obj

  # Shorthands for user's content.json
  getUserContent: (required = no) => @getUserFileJSON C.PATH_USER_INNER_CONTENT, required
  writeUserContent: (obj) => @writeUserFileJSON C.PATH_USER_INNER_CONTENT, obj

  publishUserContent: =>
    contentPath = @getUserFilePath C.PATH_USER_INNER_CONTENT
    await @cmdp 'siteSign', inner_path: contentPath
    await @cmdp 'sitePublish',
      inner_path: contentPath
      sign: no

MaterialChat = new MaterialChatImpl

export default MaterialChat