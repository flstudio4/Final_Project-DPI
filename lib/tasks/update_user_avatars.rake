# lib/tasks/update_user_avatars.rake
namespace :user do
  desc "Update user avatars based on gender from a text file"
  task :update_avatars, [:gender, :file_name] => :environment do |_t, args|
    raise "You must specify a gender (male or female)" unless args[:gender]
    raise "You must specify a file name" unless args[:file_name]

    file_path = Rails.root.join(args[:file_name])
    raise "File not found: #{file_path}" unless File.exist?(file_path)

    # Read the file, strip whitespace, and reject blank lines
    urls = File.readlines(file_path).map(&:strip).reject(&:empty?)
    users = User.where(gender: args[:gender].downcase)

    updated_count = 0
    users.find_each.with_index do |user, index|
      if index >= urls.length
        puts "Not enough URLs for all users. Stopped at user ##{user.id}."
        break
      end

      user.assign_attributes(avatar: urls[index])
      if user.changed?
        if user.save
          puts "User ##{user.id} avatar updated to: #{urls[index]}"
          updated_count += 1
        else
          puts "Failed to update User ##{user.id}: #{user.errors.full_messages.join(", ")}"
        end
      else
        puts "No changes for User ##{user.id}, avatar URL was already: #{urls[index]}"
      end
    end

    puts "Updated avatars for #{updated_count} out of #{users.count} users with gender #{args[:gender]}."
  end
end
