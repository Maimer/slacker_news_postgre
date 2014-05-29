require 'net/http'
require 'time'
require 'uri'
require 'json'
require 'pg'

def db_connection
  begin
    connection = PG.connect(dbname: 'slacker')

    yield(connection)

  ensure
    connection.close
  end
end

def find_articles
  db_connection do |conn|
    query = "SELECT articles.id, articles.author, articles.title, articles.url,
              articles.description, articles.created_at, count(comments.articles_id)
              FROM articles
              LEFT JOIN comments ON articles.id = comments.articles_id
            GROUP BY articles.id
            ORDER BY articles.created_at DESC"
    conn.exec(query)
  end
end

def save_article(author, url, title, description)
  db_connection do |conn|
    query = "INSERT INTO articles (author, title, url, description, created_at)
              VALUES ($1, $2, $3, $4, now())"
    conn.exec_params(query, [author, title, url, description])
  end
end

def find_article(id)
  db_connection do |conn|
    query = "SELECT articles.id, articles.author, articles.title, articles.url,
              articles.description FROM articles
            WHERE articles.id = #{id}"
    conn.exec(query)
  end
end

def find_comments(id)
  db_connection do |conn|
    query = "SELECT comments.author AS cauth, comments.comment, comments.created_at FROM comments
            WHERE comments.articles_id = #{id}
            ORDER BY comments.created_at DESC"
    conn.exec(query)
  end
end

def save_comments(id, author, comment)
  db_connection do |conn|
    query = "INSERT INTO comments (articles_id, author, comment, created_at)
              VALUES ($1, $2, $3, now())"
    conn.exec_params(query, [id, author, comment])
  end
end

def check_blanks(author, title, url, desc)
  if author == "" || title == "" || url == "" || desc == ""
    return true
  end
  false
end

def check_author(author)
  if author == ""
    return true
  end
  false
end

def check_url(url)
  begin
    if Net::HTTP.get_response(URI.parse(url)).code != "200"
      return true
    end
  rescue
    return true
  end
  false
end

def check_dupurl(url, articles)
  articles.each do |line|
    if url == line[:url]
      return true
    end
  end
  false
end

def check_desc(desc)
  if desc.length < 20
    return true
  end
  false
end

def make_time(time)
  if time < 60
    return time.to_s + " minutes ago"
  elsif time >= 60 && time < 1440
    return (time/60).round.to_s + " hours ago"
  elsif time >= 1440 && time < 10080
    return (time/1440).round.to_s + " days ago"
  elsif time >= 10080 && time < 43200
    return (time/10080).round.to_s + " weeks ago"
  elsif time > 43200
    return (time/518400).round.to_s + " years ago"
  end
end

def strip_url(url)
  url = url.split(".")
  url[-2] + "." + url[-1]
end
