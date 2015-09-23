ItemDataTablesIndexes =
  checkbox: 0
  image: 1
  name: 2
  status: 3
  published: 4
  updatedAt: 5
  updatedAtTimestamps: 6
  sortableName: 7
  originalFilename: 8

ExternalCollectionDataTablesIndexes =
  image: 0
  name: 1
  url: 2
  description: 3
  delete: 4

class ExternalCollectionDataTable
  constructor: (@tableElement) ->
    @filterDescriptions = []
    if @tableElement.length > 0
      @setupTable()
      @setupFilters()

  setupTable: ->
    object = @
    infoCallback = (settings, start, end, max, total, pre) ->
      object.infoCallback(settings, start, end, max, total, pre)

    @table = @tableElement.DataTable(
      language:
        emptyTable: "There are no external collections<br/><br/>Please click the add button to add a new external collection."
      dom: "ftlpi",
      lengthChange: false
      deferRender: true
      pageLength: 100
      processing: true
      order: [[ ExternalCollectionDataTablesIndexes['name'], "asc" ]]
      infoCallback: infoCallback
      columnDefs: [
        targets: ExternalCollectionDataTablesIndexes['image']
        sortable: false
        searchable: false
      ,
        targets: ExternalCollectionDataTablesIndexes['name']
        sortable: true
        searchable: true
      ,
        targets: ExternalCollectionDataTablesIndexes['url']
        sortable: true
        searchable: true
      ,
        targets: ExternalCollectionDataTablesIndexes['description']
        sortable: true
        searchable: true
      ,
        targets: ExternalCollectionDataTablesIndexes['delete']
        sortable: false
        searchable: false
      ]
    )

    @container = @tableElement.parent()
    @filterContainer = @container.find('.dataTables_filter')
    object.setupFilters()

  setupFilters: ->
    _this = @
    $('.external-collection-filter').keyup ->
      _this.table.search($(this).val()).draw()


  infoCallback: (settings, start, end, max, total, pre) ->
    if end == 0
      text = ""
    else
      text = "Showing #{@numberWithCommas(start)} to #{@numberWithCommas(end)} of #{@numberWithCommas(total)} items"
    if total < max
      text += " (filtered from #{@numberWithCommas(max)} total items)"
    text

  numberWithCommas: (x) ->
    x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")

class ItemDataTable
  constructor: (@tableElement) ->
    @filterDescriptions = []
    if @tableElement.length > 0
      @setupTable()
      @setupFilters()
      #@setupForm()

  setupTable: ->
    object = @
    infoCallback = (settings, start, end, max, total, pre) ->
      object.infoCallback(settings, start, end, max, total, pre)

    @table = @tableElement.DataTable(
      language:
        emptyTable: "There is nothing here!!  <br> Please consider creating new items or adjusting you search criteria."
      dom: "ftlpi",
      lengthChange: false
      deferRender: true
      pageLength: 100
      processing: true
      order: [[ ItemDataTablesIndexes['updatedAt'], "desc" ]]
      infoCallback: infoCallback
      columnDefs: [
        targets: ItemDataTablesIndexes['updatedAt']
        orderData: [ItemDataTablesIndexes['updatedAtTimestamps']]
      ,
        targets: ItemDataTablesIndexes['checkbox']
        sortable: false
        searchable: false
      ,
        targets: ItemDataTablesIndexes['status']
        sortable: true
        searchable: true
      ,
        targets: ItemDataTablesIndexes['published']
        sortable: true
        searchable: true
        visible: false
      ,
        targets: ItemDataTablesIndexes['updatedAtTimestamps']
        sortable: false
        searchable: false
        visible: false
      ,
        targets: ItemDataTablesIndexes['editFields']
        sortable: false
        searchable: false
      ,
        targets: ItemDataTablesIndexes['name']
        orderData: [ItemDataTablesIndexes['sortableName']]
      ,
        targets: ItemDataTablesIndexes['sortableName']
        visible: false
      ,
        targets: ItemDataTablesIndexes['image']
        sortable: false
        searchable: false
      ,
        targets: ItemDataTablesIndexes['originalFilename']
        sortable: false
        searchable: true
        visible: false
      ]
    )

    @container = @tableElement.parent()
    @filterContainer = @container.find('.dataTables_filter')
    object.setupFilters()

  setupFilters: ->
    _this = @
    $('.item-list-filter').keyup ->
      _this.table.search($(this).val()).draw()


  infoCallback: (settings, start, end, max, total, pre) ->
    if end == 0
      text = ""
    else
      text = "Showing #{@numberWithCommas(start)} to #{@numberWithCommas(end)} of #{@numberWithCommas(total)} items"
    if total < max
      text += " (filtered from #{@numberWithCommas(max)} total items)"
    text

  numberWithCommas: (x) ->
    x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")


jQuery ->

  setupItemDatatable = () ->
    table = $(".datatable.item-list")
    if table.size() > 0
      new ItemDataTable(table)

  setupExternalCollectionDatatable = () ->
    table = $("#external_collections_table")
    if table.size() > 0
      new ExternalCollectionDataTable(table)


  ready = ->
    setupItemDatatable()
    setupExternalCollectionDatatable()

  $(document).ready ->
    ready()
