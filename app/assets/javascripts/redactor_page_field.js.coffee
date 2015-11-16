class RedactorPageField
  constructor: (@fieldElement) ->
    if @fieldElement.length > 0
      @setupField()

  setupField: ->
    @fieldElement.redactor({
      source: true
      focus: true
      formatting: ['p', 'blockquote', 'h3', 'h4', 'h5']
      imageUpload: '/image_upload'
      imageManagerJson: '/v1/collections/' + $("#image_collection_unique_id").val() + '/images'
      plugins: ['imagemanager']
    })


jQuery ->

  setupRedactor = () ->
    field = $(".honeycomb_image_redactor")
    if field.size() > 0
      new RedactorPageField(field)

  ready = ->
    setupRedactor()

  $(document).ready ->
    ready()
