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

  157.times do
    user = User.new
    user.email = "#{$female_names[i]}@example.com"
    user.password = "password"
    user.password_confirmation = "password"
    user.username = "#{$female_names[i]}"
    user.gender = "female"
    user.avatar = "females/#{j}.jpg"
    user.bio = Faker::ChuckNorris.fact
    user.country = "US"
    user.state = "IL"
    user.city = "Chicago"
    user.dob = Faker::Date.between(from: '1985-09-23', to: '1999-09-25')
    user.save
    i += 1
    j += 1
  end

  pp "created #{i} female profiles"
end
