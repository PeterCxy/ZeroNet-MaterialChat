import MaterialChat from './MaterialChat.coffee'
import OptionalFileManager from './OptionalFileManager.coffee'
import * as C from './Constant.coffee'

class AvatarManagerImpl
  constructor: ->

  # Upload an avatar for current user
  uploadAvatar: (data) ->
    # `data` must be base64-encoded JPEG
    fileName = await OptionalFileManager.uploadPicture data
    
    # Register avatar in current user's data.json
    data = await MaterialChat.getUserData()
    if !data?
      data = {}
    data.avatar = fileName
    await MaterialChat.writeUserData data
    await MaterialChat.publishUserContent()
    return fileName

  # Remove the avatar of current user, if it exists
  removeAvatar: ->
    avatar = await @getMyAvatarFile()
    return if !avatar? or avatar is ''
    await OptionalFileManager.deleteFile avatar
    
    # Remove registry in user data
    data = await MaterialChat.getUserData()
    if data?
      data.avatar = ''
      await MaterialChat.writeUserData data
    await MaterialChat.publishUserContent()

  getAvatarFile: (address) ->
    result = await MaterialChat.cmdp 'dbQuery', [C.SQL_GET_UPLOADED_AVATAR.replace('{{user}}', address)]
    if result.length > 0
      return result[0].value
    else
      return null

  getMyAvatarFile: => @getAvatarFile MaterialChat.site_info.auth_address

AvatarManager = new AvatarManagerImpl
export default AvatarManager