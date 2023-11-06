require 'data_file'

desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
  if Rails.env.development?
    User.destroy_all
    Block.destroy_all
    Favorite.destroy_all
    Message.destroy_all
    Chat.destroy_all
  end

  if Rails.env.production?
    ActiveRecord::Base.connection.tables.each do |t|
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
  end

  i = 0
  j = 1
  states = ["Illinois", "Florida", "New York"]
  cities = ["Chicago", "Miami", "New York"]
  157.times do
    user = User.new
    user.email = "#{$female_names[i]}@example.com"
    user.password = "password"
    user.password_confirmation = "password"
    user.username = "#{$female_names[i]}"
    user.gender = "female"
    user.avatar = "females/#{j}.jpg"
    user.bio = Faker::ChuckNorris.fact
    user.country = "United States"
    user.state = states.sample
    user.city = cities.sample
    user.dob = Faker::Date.between(from: '1985-09-23', to: '1999-09-25')
    user.created_at = Faker::Date.between(from: '2022-03-05', to: '2023-10-22')
    user.updated_at = '2023-10-28'
    user.save
    i += 1
    j += 1
  end

  pp "created #{i} female profiles"
  i = 0
  j = 1

  116.times do
    user = User.new
    user.email = "#{$male_names[i]}@example.com"
    user.password = "password"
    user.password_confirmation = "password"
    user.username = "#{$male_names[i]}"
    user.gender = "male"
    user.avatar = "males/#{j}.jpg"
    user.bio = Faker::ChuckNorris.fact
    user.country = "United States"
    user.state = states.sample
    user.city = cities.sample
    user.dob = Faker::Date.between(from: '1985-09-23', to: '1999-09-25')
    user.created_at = Faker::Date.between(from: '2022-03-05', to: '2023-10-22')
    user.updated_at = '2023-10-29'
    user.save
    i += 1
    j += 1
  end

  pp "created #{i} male profiles"
end

task({ :create_data => :environment }) do
  if Rails.env.development?
    Chat.destroy_all
    Message.destroy_all
  end

  User.all.where(:gender => "female").each do |female|
    User.all.where(:gender => "male").each do |male|
      ch = Chat.new
      ch.receiver_id = female.id
      ch.sender_id = male.id
      ch.save

      20.times do
        m = Message.new
        m.author_id = female.id
        m.chat_id = ch.id
        m.content = "#{$conversational_phrases.sample}"
        m.save

        f = Message.new
        f.author_id = male.id
        f.chat_id = ch.id
        f.content = "#{$conversational_phrases.sample}"
        f.save
      end
    end
  end
end
