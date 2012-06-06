Some Notes
=
1. The function login_user is defined in ./support/controller_macros.rb
2. instructions such as "render @story" does not work and should instead be replaced with specifics like "render_template 'stories/show'"
2.5. assigns(:story) or other such uses of assigns also doesn't work. Work around it, please.
3. Integration tests will be implemented in the nearby future
4. Helper tests and views tests will not be implemented
5. Be sure to occasionally purge ./public/images/elements/ otherwise that folder is going to overflow

Suggestions
=
Periodically run the following command to purge the folders:
$ bundle exec rake db:test:prepare && rm public/images/elements/* -r && rm public/images/stories/* -r && rm public/images/chapters/* -r
