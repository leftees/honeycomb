class RedactorPageField
  constructor: (@fieldElement) ->
    if @fieldElement.length > 0
      @setupField()

  setupField: ->
    @fieldElement.redactor({
      source: true
      focus: true
      formatting: ['p', 'blockquote', 'h3', 'h4', 'h5']
      imageUpload: '/collections/' + $("#image_collection_unique_id").val() + '/image_upload'
      imageUploadParam: 'uploaded_image'
      uploadImageFields: {
        'authenticity_token': '#image_upload_auth_token'
      }
      imageUploadCallback: (image, json) ->
        $(image).attr 'alt', json.title
        $(image).attr 'title', json.title
        $(image).attr 'width', '300px'
        $(image).attr 'height', 'auto'
        $(image).attr 'style', 'width: 300px; height: auto; float: left; margin: 0px 10px 10px 0px;'
        $(image).attr 'rel', 'width: 300px; height: auto; float: left; margin: 0px 10px 10px 0px;'
      imageManagerJson: '/v1/collections/' + $("#image_collection_unique_id").val() + '/images'
      plugins: ['imagemanager']
    })


jQuery ->

  setupRedactor = ->
    field = $(".honeycomb_image_redactor")
    if field.size() > 0
      new RedactorPageField(field)

  ready = ->
    setupRedactor()

  $(document).ready ->
    ready()
