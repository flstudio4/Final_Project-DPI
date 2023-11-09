# lib/tasks/cloudinary.rake
require 'cloudinary'

namespace :cloudinary do
  desc 'Retrieve image URLs and write to a file'
  task :fetch_urls, [:folder_name, :file_name] => :environment do |_t, args|
    raise 'Folder name is required' unless args[:folder_name]
    file_name = args[:file_name] || 'image_urls.txt'

    Cloudinary.config do |config|
      config.cloud_name = ENV['CLOUDINARY_CLOUD_NAME']
      config.api_key = ENV['CLOUDINARY_API_KEY']
      config.api_secret = ENV['CLOUDINARY_API_SECRET']
      config.secure = true
    end

    begin
      result = Cloudinary::Api.resources(
        type: 'upload',
        prefix: args[:folder_name],
        max_results: 500
      )

      urls = result['resources'].map { |image| image['secure_url'] }

      # Write URLs to a text file, separated by commas
      File.open(file_name, 'w') do |file|
        file.puts urls.join("\n")
      end

      puts "URLs written to #{file_name}"
    rescue Cloudinary::Api::RateLimited => e
      puts "Rate limit exceeded: #{e.message}"
    rescue Cloudinary::Api::AuthorizationRequired => e
      puts "Authorization error: #{e.message}"
    rescue Cloudinary::Api::NotFound => e
      puts "Not found: #{e.message}"
    rescue => e
      puts "An error occurred: #{e.message}"
    end
  end
end
