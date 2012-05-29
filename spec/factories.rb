Factory.define :user do |user|
  user.name { Factory.next :name }
  user.email { Factory.next :email }
  user.password "asdfasdfasdf"
  user.password_confirmation "asdfasdfasdf"
end # user

Factory.define :story do |story|
  story.association :author
  story.title "Alice in Testland"
  story.summary "Alice writes model, controller, and integration tests to make sure her code isn't crap when it goes to production"
end # story

Factory.define :element do |element|
  include ActionDispatch::TestProcess
  element.metadata (0..30).map { |x| ("a".."z").map{ |y| y }[rand(26)] }.join
  element.picture fixture_file_upload(Rails.root + 'spec/pics/pic0.png', 'image/png')
end # element

Factory.sequence :email do |n|
  "testdrone#{n}@test.com"
end

Factory.sequence :name do |n|
  "Alice McTest#{n}"
end


