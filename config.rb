configure :development do
  set :database, 'sqlite://development.db'
end

configure :test do
  set :database, 'sqlite://test.db'
end

configure :production do
  set :database, 'sqlite://production.db'
end

configure do
  db = URI.parse(ENV['DATABASE_URL'] || get(:database))

  ActiveRecord::Base.establish_connection(
    :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
    :host     => db.host,
    :username => db.user,
    :password => db.password,
    :database => db.path[1..-1],
    :encoding => 'utf8'
  )
end
