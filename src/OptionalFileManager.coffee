import MaterialChat from './MaterialChat.coffee'
import * as C from './Constant.coffee'
import { randomStr } from './Util.coffee'

class OptionalFileManagerImpl
  constructor: ->

  assertOptionalPattern: ->
    content = await MaterialChat.getUserContent()
    if !content?
      content = {}
    if content.optional isnt C.CONF_OPTIONAL_FILE_PATTERN
      content.optional = C.CONF_OPTIONAL_FILE_PATTERN
      await MaterialChat.writeUserContent content
      # This does not sign the user content.json
      # Please sign it after uploading new content

  uploadPicture: (data) =>
    # ONLY base64-encoded JPEG allowed for this method.
    fileName = randomStr(10) + '.jpg'
    await MaterialChat.writeUserFile C.PATH_USER_UPLOADED_CONTENT + fileName, data
    await @assertOptionalPattern()
    # Please sign & publish when needed
    return fileName

  deleteFile: (fileName) =>
    # TODO: Add MaterialChat.deleteUserFile()

OptionalFileManager = new OptionalFileManagerImpl
export default OptionalFileManager