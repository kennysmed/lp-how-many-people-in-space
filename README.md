# How Many People In Space

A Little Printer publication which prints a publication on any day when the number of people in space has changed.

See a sample at http://remote.bergcloud.com/publications/36

A Ruby + Sinatra app that uses the feedzirra gem to parse the Tumblr feed RSS from http://www.howmanypeopleareinspacerightnow.com/ Returns something only if the number of people has changed in the previous 24 hours, or this is the first time a user has received this publication.

Expects a `REDISTOGO_URL` in environment settings, pointing to a Redis
database.

----

BERG Cloud Developer documentation: http://remote.bergcloud.com/developers/

