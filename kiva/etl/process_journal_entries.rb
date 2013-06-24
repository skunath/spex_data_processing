require 'JSON'
require_relative 'db_connect'



def process_loan_file(file)
  read = File.open(file).read()
  full_json = JSON.parse(read)
  
  if full_json["paging"]["total"] == 0
    return 0
  end
  
  filename = file.split("/")[-1]
  loan_id = filename.split("_")[0]
  
  for entry in full_json["journal_entries"]
    
    new_journal = JournalComment.new()
    new_journal.kiva_id = entry["id"]
    new_journal.subject = entry["subject"]
    new_journal.body = entry["body"]
    new_journal.posted_date = entry["date"]
    new_journal.recommendation_count = entry["recommendation_count"]
    new_journal.comment_count = entry["comment_count"]
    new_journal.author = entry["author"]
    new_journal.kiva_loan_id = loan_id
    new_journal.save
      
  end
  
  return 1
  
end




#base_dir = "/data/kivafinal/kivafinal/KivaRaw_31May2013/RAW_kiva_ds_json_downloaded_31May2013/loans_lenders/"

base_dir = "/data/kivafinal/kivafinal/KivaRaw_31May2013/RAW_kiva_json_loan-journalentry-links_from9Feb2013_loan_list/"

dir_start = Dir.glob(base_dir + "**/**")
error_files = []
counter = 0
for file in dir_start
  if File.file?(file)
    begin
      temp = process_loan_file(file)
    rescue
      puts "another error"
      error_files << file
    end
    if (counter % 1000) == 0
      puts "At: #{counter}"
    end
    counter += temp
  end

end

puts "Errors:"
puts error_files.join(", ")
file_attempt = "1.json"

#read = File.open(base_dir + file_attempt).read()
#full_json = JSON.parse(read)
#loans = full_json["loans"]
#puts JSON.pretty_generate(lenders[1])

#listings = Dir[base_dir + "*.json"]

#for file in listings
#  process_loan_file(file)
#end
