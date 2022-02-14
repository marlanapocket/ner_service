# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

NerModel.create(title: '1st ner model',
                        description: 'This is a great model',
                        language: 'fr',
                        path: "#{Rails.root}/data/german_htr_train3_1T/model.pth",
                        public: true)
User.create(email: 'test@test.com', password: "password")