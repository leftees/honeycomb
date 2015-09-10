SELECT *
FROM honeycomb_development.sections
WHERE
  honeycomb_development.sections.item_id NOT IN (SELECT id FROM honeycomb_development.items);

DELETE
FROM honeycomb_development.sections
WHERE
  honeycomb_development.sections.item_id NOT IN (SELECT id FROM honeycomb_development.items);

SELECT *
FROM honeycomb_development.sections
WHERE
  honeycomb_development.sections.showcase_id NOT IN (SELECT id FROM honeycomb_development.showcases);

DELETE
FROM honeycomb_development.sections
WHERE
  honeycomb_development.sections.showcase_id NOT IN (SELECT id FROM honeycomb_development.showcases);

# honeycomb_development.items without collection
SELECT *
FROM honeycomb_development.items
WHERE honeycomb_development.items.collection_id NOT IN (SELECT id FROM honeycomb_development.collections);

DELETE
FROM honeycomb_development.items
WHERE honeycomb_development.items.collection_id NOT IN (SELECT id FROM honeycomb_development.collections);

# honeycomb_development.items without a parent
SELECT *
FROM honeycomb_development.items
WHERE
  honeycomb_development.items.parent_id IS NOT NULL AND
  honeycomb_development.items.parent_id NOT IN (SELECT id FROM honeycomb_development.items);

DELETE
FROM honeycomb_development.items
WHERE
  honeycomb_development.items.parent_id IS NOT NULL AND
  honeycomb_development.items.parent_id NOT IN (SELECT id FROM (SELECT id FROM honeycomb_development.items as itemids) as ids);

# honeycomb_development.showcases without an exhibit
SELECT *
FROM honeycomb_development.showcases
WHERE honeycomb_development.showcases.exhibit_id NOT IN (SELECT id FROM honeycomb_development.exhibits);

DELETE
FROM honeycomb_development.showcases
WHERE honeycomb_development.showcases.exhibit_id NOT IN (SELECT id FROM honeycomb_development.exhibits);

# honeycomb_development.exhibits without a collection
SELECT *
FROM honeycomb_development.exhibits
WHERE honeycomb_development.exhibits.collection_id NOT IN (SELECT id FROM honeycomb_development.collections);

DELETE
FROM honeycomb_development.exhibits
WHERE honeycomb_development.exhibits.collection_id NOT IN (SELECT id FROM honeycomb_development.collections);

# CollectionUsers without a collection or user
SELECT *
FROM honeycomb_development.collection_users
WHERE
  honeycomb_development.collection_users.collection_id NOT IN (SELECT id FROM honeycomb_development.collections) OR
  honeycomb_development.collection_users.user_id NOT IN (SELECT id FROM users);

DELETE
FROM honeycomb_development.collection_users
WHERE
  honeycomb_development.collection_users.collection_id NOT IN (SELECT id FROM honeycomb_development.collections) OR
  honeycomb_development.collection_users.user_id NOT IN (SELECT id FROM users);
