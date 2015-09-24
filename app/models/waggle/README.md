# Waggle

This is Honeycomb's search/indexing functionality

[Waggle dance is a term used in beekeeping and ethology for a particular figure-eight dance of the honey bee. By performing this dance, successful foragers can share, with other members of the colony, information about the direction and distance to patches of flowers yielding nectar and pollen, to water sources, or to new nest-site locations.](https://en.wikipedia.org/wiki/Waggle_dance)

## Examples

### Index all items

```ruby
Item.all.each { |item| ::Index::Item.index!(item) }
```

### Examine the raw response from the Solr adapter

```ruby
search = Waggle.search(q: "flower")
result = search.send(:adapter_result)
response = result.result
```


### Examine the raw spellcheck suggestions from Solr
Note: to build the spellcheck database you either need to run the optimize command on the Solr server, or enable the `buildOnCommit` option in `solrconfig.xml`.

```ruby
search = Waggle.search(q: "honeycreper brid")
result = search.send(:adapter_result)
response = result.result
spellcheck_suggestions = response["spellcheck"]["suggestions"]
```
