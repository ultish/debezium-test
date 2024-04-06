create database bookstore;

CREATE TABLE book (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  author VARCHAR(255) NOT NULL
);

-- this allows full logging of the table
alter table book REPLICA IDENTITY FULL;