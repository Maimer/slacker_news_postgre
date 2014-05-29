CREATE TABLE articles (
  id serial PRIMARY KEY,
  author varchar(63) NOT NULL,
  title varchar(127) NOT NULL,
  url varchar(255) NOT NULL,
  description varchar(1023) NOT NULL,
  created_at timestamp NOT NULL
);

CREATE TABLE comments (
  id serial PRIMARY KEY,
  articles_id INT REFERENCES articles(id) NOT NULL,
  author varchar(63) NOT NULL,
  comment varchar(1023) NOT NULL,
  created_at timestamp NOT NULL
);
