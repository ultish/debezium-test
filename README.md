# Description

This is a basic test of Debezium with a postgres connector. The compose file sets up:

- Kafka (KRaft)
- Kafka UI
- Schema Registry
- Postgres
- Debezium Connect

# What it does

- Debezium Connect connects to Kafka
- Post a database connector to Debezium Connect like so:
  ```bash
  curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d '{
  "name": "bookstore-connector",
  "config": {
  "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
  "tasks.max": "1",
  "database.hostname": "postgres",
  "database.port": "5432",
  "database.user": "postgres",
  "database.password": "postgres",
  "database.dbname" : "bookstore",
  "database.server.name": "localhost",
  "topic.prefix": "jxhui-test",
  "tombstones.on.delete" : "false",
  "table.whitelist" : "store.outboxevent",
  "plugin.name": "pgoutput"
  }
  }'
  ```
- insert a new value into the bookstore database
  ```bash
  docker exec -it postgres /bin/bash
  INSERT INTO book (id, name, author) VALUES ('B001', 'The Great Gatsby', 'F. Scott Fitzgerald');
  ```
- update the database
  ```bash
  update book set name = 'JIMMY' where id = 'B002';
  ```
- look at the messages generated on the topic and you'll see payloads with the changes

# Example Payload

```
"payload": {
  "before": {
    "id": "B002",
    "name": "JIMMY",
    "author": "F. Scott Fitzgerald"
  },
  "after": {
    "id": "B002",
    "name": "JIMMY HUI",
    "author": "F. Scott Fitzgerald"
  },
  "source": {
    "version": "2.5.0.Final",
    "connector": "postgresql",
    "name": "jxhui-test",
    "ts_ms": 1712378261034,
    "snapshot": "false",
    "db": "bookstore",
    "sequence": "[\"23480472\",\"23480528\"]",
    "schema": "public",
    "table": "book",
    "txId": 497,
    "lsn": 23480528,
    "xmin": null
  },
  "op": "u",
  "ts_ms": 1712378261312,
  "transaction": null
}
```

# Postgres

Note: need to use wal_level=logical in postgres (set in the compose file)

# Reading

- https://thorben-janssen.com/outbox-pattern-with-cdc-and-debezium/#setting-up-debezium
- https://debezium.io/documentation/reference/stable/transformations/index.html
