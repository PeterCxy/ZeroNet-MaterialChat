import ZeroFrame from "./ZeroFrame.coffee"
import Message from "./Message.coffee"
import LoginDialog from "./LoginDialog.coffee"
import * as C from './Constant.coffee'

class MaterialChatImpl extends ZeroFrame
  init: ->
    @site_info = null
    console.log "MaterialChat initialized."

  onOpenWebsocket: () =>
    C.initialize()
    @cmd "siteInfo", {}, @siteInfoChanged # Intialize siteInfo
    #alert "Ready."
    #new Message "petercxy@zeroid.bit", "Test Message 1"
    #  .render()

  onRequest: (cmd, msg) =>
    switch cmd
      when "setSiteInfo" then @siteInfoChanged msg.params
      else super.onRequest cmd, msg

  siteInfoChanged: (info) =>
    @site_info = info
    if !@site_info.cert_user_id?
      LoginDialog.tryLogin()
    else
      LoginDialog.dismiss()
      # TODO: Complete login

MaterialChat = new MaterialChatImpl

export default MaterialChat