# db/seeds.rb
users = [
  { names: 'Jon Doe', username: 'jondoe', email: 'jon@doe.com', password: 'abc'},
  { names: 'Jane Doe', username: 'janedoe', email: 'jane@doe.com', password: 'abc'},
  { names: 'Baby Doe', username: 'babydoe', email: 'baby@doe.com', password: 'abc'},
]

users.each do |u|
  User.create(u)
end