reload!
solr = RSolr.connect(url: 'http://localhost:8982/solr/blacklight-core')
i = Waggle::Item.from_item(Item.first)
solr.add(i.as_solr)
solr.commit
