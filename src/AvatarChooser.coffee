import $ from "jquery"
import "cropper"
import { readDataURL } from "./Util.coffee"

class AvatarChooserImpl
  constructor: ->
    @dialog = $('#modal-avatar-settings')
    @avatarUpload = $('#avatar-upload')
    @container = $('#avatar-preview-container')
    @avatarCropper = $('#avatar-cropper')
    @avatarResult = $('#avatar-result')
    @avatarResultContainer = $('#avatar-result-container')
    @avatarUpload.on 'change', @handleUpload
    @buttonOkay = $('#avatar-ok')
    @buttonOkay.click @handleSetAvatar
    $('#avatar-cancel').click => @dialog.modal 'hide'

  show: =>
    # Re-initialize the dialog content
    @hidePreview()
    @avatarUpload.val("")
    @dialog.modal 'show'

  hidePreview: =>
    @buttonOkay.addClass 'disabled'
    @avatarCropper.cropper 'destroy'
    @container.addClass 'invisible'
    @avatarCropper.attr 'src', ''
    @avatarResult.attr 'src', ''

  showPreview: (src) =>
    @buttonOkay.removeClass 'disabled'
    @avatarCropper.attr 'src', src
    @avatarResult.attr 'src', src
    @container.removeClass 'invisible'
    @avatarCropper.cropper
      aspectRatio: 1
      autoCropArea: 0.5
      viewMode: 1
      dragMode: 'move'
      #ready: => @avatarCropper.cropper 'zoom', 0.1
      crop: @handlePreview

  handleUpload: (ev) =>
    ev.preventDefault()
    @hidePreview()
    @showPreview await readDataURL ev.target.files[0]
    
  handlePreview: (ev) =>
    imageData = @avatarCropper.cropper('getImageData')

    # Calculate the image preview parameters based on cropping data
    # Literally, the scale and the position
    previewHeight = @avatarResultContainer.height()
    scale = ev.height / previewHeight
    @avatarResult.css
      width: imageData.naturalWidth / scale
      height: imageData.naturalHeight / scale
      marginLeft: -ev.x / scale
      marginTop: -ev.y / scale

  handleSetAvatar: (ev) =>
    ev.preventDefault()

    # Get base64 data based on dataURL
    dataURL = @avatarCropper.cropper('getCroppedCanvas').toDataURL 'image/jpeg', 0.9
    imgBase64 = dataURL.replace 'data:image/jpeg;base64,', ''
    console.log imgBase64 # TODO: Finish setting avatar

AvatarChooser = new AvatarChooserImpl
export default AvatarChooser