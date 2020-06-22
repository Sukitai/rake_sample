require 'csv'
namespace :import_csv do
  desc "CSVファイルをインポートするタスク"

  task import: :environment do

    path = File.join Rails.root, "db/csv_data/csv_data.csv"
    list = []
    CSV.foreach(path, headers: true) do |row|
      list << {
        name: row["name"],
        age: row["age"],
        address: row[:address]
      }
    end

    puts "インポート処理を開始".white

    begin
      User.transaction do
        puts "インポート施行中…".yellow
        User.create!(list)
      end
      puts "インポート成功".green

    rescue ActiveModel::UnknownAttributeError => invalid
    puts "お気の毒ですが、インポートに失敗しましたUnknownAttributeError".red
    end
  end
end
