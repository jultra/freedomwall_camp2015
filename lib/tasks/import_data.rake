require 'csv'



namespace :db do
  task :import_data => :environment do
    CSV.foreach("/home/jultra/hackathon2.csv", :headers => true) do |row|
      Message.create!(row.to_hash)
    end
  end
end
