configure :development do
  set :database, 'sqlite:///development.db'
end

configure :test do
  set :database, 'sqlite:///test.db'
end

configure :production do
  set :database, 'sqlite:///production.db'
end
