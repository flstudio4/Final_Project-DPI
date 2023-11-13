task copy_usernames_to_name: :environment do
  User.where(name: nil).find_each do |user|
    user.update(name: user.username, password: "password", password_confirmation: "password")
    puts "Updated user #{user.id}: name set to '#{user.username}'"
  end
  puts "All users updated."
end
