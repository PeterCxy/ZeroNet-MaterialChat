import ZeroFrame from "./ZeroFrame.coffee"
import Message from "./Message.coffee"

class MaterialChat extends ZeroFrame
  init: ->
    console.log "MaterialChat initialized."

  onOpenWebsocket: () ->
    #alert "Ready."
    new Message "petercxy@zeroid.bit", "Test Message 1"
      .render()
    new Message "petercxy@zeroid.bit", "Test Message 2 \n Very \n Very \n Long \n Message"
      .render()
    new Message "petercxy@zeroid.bit", "Test Message 3 \n Very \n Very \n Very \n Very \n Very Very \n Long \n Message"
      .render()
    new Message "petercxy@zeroid.bit", "Test Message 4 \n Very \n Very \n Very \n Very \n Very Very \n Long \n Message"
      .render()

export MC = new MaterialChat