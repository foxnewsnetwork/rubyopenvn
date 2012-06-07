# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
users = User.create(
  [ :name => "foxnewsnetwork", :email => "foxnewsnetwork@gmail.com", :password => "1234567"] ,
  [ :name => "maaya", :email => "mmnashi90@gmail.com", :password => "1234567"] ,
  [ :name => "alice", :email => "alice@wonder.land", :password => "1234567"]
) # users

story = users[1].stories.create( :title => "Demo story", :summary => "Not much to say about this one; made exclusively with the intent of testing")
chapter = story.chapters.create( :title => "ruby.js integration", :number => 0)
scenes = [
  chapter.scenes.create
]
dscenes = [
  scenes[0].scene_data.create({})
]

##!! NOTE: IMPORTANT: Seeds are not complete yet so do not seed!
