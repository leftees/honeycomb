reload!
conf = HoneycombSolr.config
solr = RSolr.connect(url: "http://#{conf.fetch('hostname')}:#{conf.fetch('port')}#{conf.fetch('path')}")
i = Waggle::Item.from_item(Item.first)
solr.add(i.as_solr)
solr.commit
