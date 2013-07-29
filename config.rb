configure :development do
  set :database, 'sqlite:///var/development.db'
end

configure :test do
  set :database, 'sqlite:///var/test.db'
end

configure :production do
  set :database, 'sqlite:///var/production.db'
end
