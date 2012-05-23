Factory.define :user do |user|
  user.name "Alice McTest"
  user.email "test@alice.test"
  user.password "asdfasdfasdf"
  user.password_confirmation "asdfasdfasdf"
end # user

Factory.define :story do |story|
  story.association :author
  story.title "Alice in Testland"
  story.summary "Alice writes model, controller, and integration tests to make sure her code isn't crap when it goes to production"
end # story
