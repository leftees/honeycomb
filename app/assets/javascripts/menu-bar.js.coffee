jQuery ->
  $("input[checkbox], .show-selected-menu").change ->
    $('.menu-bar.default').toggle()
    $('.menu-bar.selected').toggle()
jQuery ->
	$('#trig').on 'click', ->
		$('#col1').toggleClass 'col-md-0 col-md-1'
		$('#col2').toggleClass 'col-md-11 col-md-10'
		$('#switch').toggleClass 'glyphicon-chevron-left glyphicon-chevron-right'
