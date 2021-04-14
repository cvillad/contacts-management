# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

To run this project you'll need to have:
* Ruby-3.0.1
* Rails-6.1.3.1
* Redis-6.2.1
* PostgreSQL13

Steps:
  Change database settings on config/database.yml

  Open a terminal and run:
  * redis-server

  Open another terminal located on project folder and run:
  * bundle install
  * bundle exec sidekiq

  Open the last terminal and run:
  * rails db:create
  * rails db:migrate
  * rails s

Test csv files are located in spec/csv_files