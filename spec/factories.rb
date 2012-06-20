Factory.define :user do |user|
  user.name { Factory.next :name }
  user.email { Factory.next :email }
  user.password "asdfasdfasdf"
  user.password_confirmation "asdfasdfasdf"
end # user

Factory.define :story do |story|
  include ActionDispatch::TestProcess
  story.association :author
  story.title "Alice in Testland"
  story.summary "Alice writes model, controller, and integration tests to make sure her code isn't crap when it goes to production"
  story.cover fixture_file_upload(Rails.root + 'spec/pics/pic0.png', "image/png")
end # story

Factory.define :chapter do |chapter|
  include ActionDispatch::TestProcess
  chapter.association :author
  chapter.association :story
  chapter.title { Factory.next(:name) }
  chapter.cover fixture_file_upload(Rails.root + 'spec/pics/pic0.png', "image/png")
end # chapter

Factory.define :scene do |scene|
  scene.association :author
  scene.association :chapter
  scene.texts { Factory.next(:random_string) }
  scene.number 0
  scene.fork_text { Factory.next( :random_string ) }
  scene.fork_number 0
end # scene

Factory.define :element do |element|
  include ActionDispatch::TestProcess
  element.metadata (0..30).map { |x| ("a".."z").map{ |y| y }[rand(26)] }.join
  element.picture fixture_file_upload(Rails.root + 'spec/pics/pic0.png', 'image/png')
end # element

Factory.define :layer do |layer|
  layer.width rand(256)
  layer.height rand(256)
  layer.x rand(256)
  layer.y rand(256)
  layer.association :scene
  layer.association :element
end # layer

Factory.sequence :email do |n|
  "testdrone#{n}@test.com"
end

Factory.sequence :name do |n|
  "Alice McTest#{n}"
end

Factory.sequence :random_string do |n|
  (0..55).map { |x| ("a".."z").map { |y| y }[rand(26)] }.join
end

