desc "Fill the database tables with some sample data"
task({ :sample_data => :environment }) do
  if Rails.env.development?
    User.destroy_all
  end
  user = User.new(email: "alice@example.com", username: "alice", password: "password", password_confirmation: "password")
  user.save

  
end
