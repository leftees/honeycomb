Dropzone.autoDiscover = false

class MultiNewDropzoneForm
  constructor: (@dropzoneForm) ->
    if @dropzoneForm.length > 0
      @setupDropzone()

  setupDropzone: ->
    formObject= @dropzoneForm
    @dropzoneForm.dropzone(
      paramName: "item[image]"
      acceptedFiles: "image/*"
      addRemoveLinks: true
      autoProcessQueue: false
      url: @dropzoneForm.attr("action")
      previewsContainer: ".dropzone-previews"
      clickable: ".dropzone"
      parallelUploads: 100
      maxFiles: 100
      dictRemoveFile: "Cancel Upload"

      # The setting up of the dropzone
      init: ->
        myDropzone = this
        # First change the button to actually tell Dropzone to process the queue.
        formObject.find('input[type="submit"]').get(0).addEventListener "click", (e) ->
          e.preventDefault()
          e.stopPropagation()

          # Make sure that the form isn't actually being sent.
          if myDropzone.getQueuedFiles().length
            myDropzone.processQueue()
          return

        @on "complete", (files, response) ->
          if myDropzone.getQueuedFiles().length == 0
            if window.location.href.search(/children/i) != -1
              window.location.replace(window.location + '/../../edit')
            else
              window.location.replace(window.location + '/../')

        @on "addedfile", (file) ->
          $('.edit-upload-button').removeAttr('disabled')
          this.element.classList.add("dz-started")
    )


class EditFormDropzone
  constructor: (@dropzoneForm) ->
    if @dropzoneForm.length > 0
      @setupDropzone()

  setupDropzone: ->
    formObject= @dropzoneForm
    @dropzoneForm.dropzone(
      method: "put"
      autoProcessQueue: true
      paramName: "item[image]"
      acceptedFiles: "image/*"
      addRemoveLinks: true
      url: @dropzoneForm.attr("action")
      previewsContainer: ".dropzone-previews"
      clickable: ".dropzone"
      dictRemoveFile: "Cancel Upload"
      maxFiles: 1

      # The setting up of the dropzone
      init: ->
        myDropzone = this

        # First change the button to actually tell Dropzone to process the queue.
        formObject.find("input[type=submit]").get(0).addEventListener "click", (e) ->

          # Make sure that the form isn't actually being sent.
          if myDropzone.getQueuedFiles().length
            e.preventDefault()
            e.stopPropagation()
            myDropzone.processQueue()
          return

        # Gets triggered when the form is actually being sent.
        # Hide the success button or the complete form.
        @on "complete", (files, response) ->
          window.location.reload()

        @on "addedfile", (file) ->
          $(this.element.children).children('.edit-upload-button').removeAttr('disabled')
          this.element.classList.add("dz-started")
    )


# Gets triggered when there was an error sending the files.
# Maybe show form again, and notify user of error

jQuery ($) ->

  setupEditDropzone = () ->
    dropzone = $(".edit-item-dropzone")
    if dropzone.size() > 0
      new EditFormDropzone(dropzone)

  setupNewDropzone = () ->
    dropzone = $(".new-item-dropzone")
    if dropzone.size() > 0
      new MultiNewDropzoneForm(dropzone)

  ready = ->
    setupEditDropzone()
    setupNewDropzone()

  $(document).ready(ready)

