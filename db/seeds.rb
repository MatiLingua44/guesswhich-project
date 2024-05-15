# db/seeds.rb
users = [
  { names: 'Jon Doe', username: 'jondoe', email: 'jon@doe.com', password: 'abc'},
  { names: 'Jane Doe', username: 'janedoe', email: 'jane@doe.com', password: 'abc'},
  { names: 'Baby Doe', username: 'babydoe', email: 'baby@doe.com', password: 'abc'},
]

users.each do |u|
  User.create(u)
end

questions = [
  {description: '¿En qué año se desenvolvió la segunda guerra mundial?', difficulty: :medium},
  {description: '¿En qué año se desenvolvió la primera guerra mundial?', difficulty: :easy},
  {description: '¿En qué año se consagró campeón la seleccion argentina de futbol pro primera vez?', difficulty: :easy}
]

questions.each do |q|
  Question.create(q)
end