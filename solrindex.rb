reload!
# conf = HoneycombSolr.config
# solr = RSolr.connect(url: "http://#{conf.fetch('hostname')}:#{conf.fetch('port')}#{conf.fetch('path')}")
session = Waggle.adapter.session
i = Waggle::Item.from_item(Item.first)
session.index!(i)
search = Waggle.search(q: "flower")
result = search.send(:adapter_result)
response = result.result
response




reload!
Item.all.each { |item| ::Index::Item.index!(item) }
