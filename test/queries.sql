-- name: count_examples
SELECT COUNT(*) FROM examples;

-- name: get_example_by_id
SELECT * FROM examples where id = :id limit 1;

-- name: get_examples_by_id
SELECT * FROM examples where id in :ids;
