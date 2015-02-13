jQuery ->
  $("input[checkbox], .show-selected-menu").change ->
    $('.menu-bar.default').toggle()
    $('.menu-bar.selected').toggle()
