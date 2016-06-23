Getting started procedure :

1. Install Ruby 2.3.0
2. Install Redis database
3. Install Bundler

Steps to start the osm server

1. Clone the repository.
2. cd /bin
3. Execute <rake install> command (It takes some time based on network connection).
4. Add object properties in configuration file /bin/config/objects.yml.
5. Run redis server(Default location is 127.0.0.1:6397/2 ).
6. Run sinatra using command <ruby osm_server>.
7. Open another terminal and make sure you are using same gemset. Start sidekiq server using the command <sidekiq -r "full path to osm_worker.rb">.
8. Open url  http://localhost:4567/ in browser.
9. Now you can upload sample object log file and search the object states(You can find the sample file /bin/sample.csv).

Advantages :
1. We can configure the various object properties and Redis DB properties.

Future Scope :
1) I would like to publish it as Ruby gem to track the object states.
2) Should be able to integrate with Rails(Active Records).
3) Use Elastic Search to store multiple object log files and object states.

Limitations :
1) Only one log file data(less than 1GB ) can process and searchable.
I've plan to overcome this by integrating elastic search and indexing data so that data will be persistent and  we can have various search criteria.
