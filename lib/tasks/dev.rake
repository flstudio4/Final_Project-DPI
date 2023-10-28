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

  1.times do
    user = User.new
    user.email = "mary@example.com"
    user.password = "password"
    user.password_confirmation = "password"
    user.username = "mary"
    user.gender = "female"
    user.avatar = "females/1.jpg"
    user.bio = "I am sexy baby"
    user.country = "US"
    user.state = "IL"
    user.city = "Chicago"
    user.dob = "02/02/1995"
    user.save
  end
end
