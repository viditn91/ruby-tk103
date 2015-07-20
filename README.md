# ruby-tk103
Server for listening to GPS data pushed using the TK103 protocol

## running
Setup the environment.

    bundle install
    rake db:create
    rake db:migrate

Run server and client.

    ruby app/server.rb
    ruby app/client.rb