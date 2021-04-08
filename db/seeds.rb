# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.first
Contact.create([
              { name: "John Doe1", 
                born_date: "20121212",
                email: "jdoe1@gmail.com", 
                card_number: "4242424242424242", 
                phone: "(+57) 322-222-22-22",
                address: "Calle lagartos 75",
                user: user
              },
              { name: "John Doe2", 
                born_date: "20121212",
                email: "jdoe2@gmail.com", 
                card_number: "4242424242424242", 
                phone: "(+57) 322-222-22-22",
                address: "Calle lagartos 75",
                user: user
              },
              { name: "John Doe3", 
                born_date: "20121212",
                email: "jdoe3@gmail.com", 
                card_number: "4242424242424242", 
                phone: "(+57) 322-222-22-22",
                address: "Calle lagartos 75",
                user: user
              }])
