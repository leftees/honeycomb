reload!
# conf = HoneycombSolr.config
# solr = RSolr.connect(url: "http://#{conf.fetch('hostname')}:#{conf.fetch('port')}#{conf.fetch('path')}")
session = Waggle.adapter.session
solr = session.connection
i = Waggle::Item.from_item(Item.first)
solr.add(i.as_solr)
solr.commit
search = Waggle.search(q: "horse")
result = search.send(:adapter_result)
response = result.result
response
