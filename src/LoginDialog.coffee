import $ from 'jquery'
import MaterialChat from './MaterialChat.coffee'
import * as C from './Constant.coffee'

class LoginDialogImpl
  constructor: ->
    @elem = $('#modal-choose-user')
    @elem.find('#choose-user').click @selectUser

  tryLogin: ->
    $ => @elem.modal
      show: yes
      backdrop: 'static'
      focus: yes

  dismiss: ->
    @elem.modal 'hide'

  selectUser: (ev) ->
    ev.preventDefault()
    MaterialChat.cmd 'certSelect', { accepted_domains: C.ID_PROVIDERS }

LoginDialog = new LoginDialogImpl

export default LoginDialog