Sunspot::Adapters::InstanceAdapter.register(
  Waggle::Sunspot::Adapters::InstanceAdapter,
  Waggle::Item
)
Sunspot::Adapters::DataAccessor.register(
  Waggle::Sunspot::Adapters::ItemDataAccessor,
  Waggle::Item
)

Waggle::Index::Item.setup
