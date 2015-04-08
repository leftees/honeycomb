jQuery ->

  window.onload = ->
    $(".form-group > input").each ->
      this_value = if typeof $(this).val() isnt "undefined" then $(this).val() else ""
      $(this).data "initialValue", this_value

    $(".form-group > textarea").each ->
      $(this).data "initialValue", $(this).val()

    $(".redactor-editor").each ->
      $(this).data "initialValue", $(this).html()


  save_clicked = "false"
  $("input[name='commit']").click ->
    save_clicked = "true"

  window.onbeforeunload = ->
    msg = "You haven't saved your changes."
    isDirty = false
    $(".form-group > input").each ->
      if $(this).data("initialValue") isnt $(this).val() and 
        typeof $(this).val() isnt "undefined" and
        save_clicked is "false"
          isDirty = true 
    $(".form-group > textarea").each ->
      if $(this).data("initialValue") isnt $(this).val() and 
        typeof $(this).val() isnt "undefined" and
        save_clicked is "false"
          isDirty = true 
    $(".redactor-editor").each ->
      if $(this).data("initialValue") isnt $(this).html() and 
        typeof $(this).html() isnt "undefined" and
        save_clicked is "false"
          isDirty = true 


    msg  if isDirty is true