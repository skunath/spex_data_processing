require 'JSON'
require_relative 'db_connect'


#base_dir = "/data/kivafinal/kivafinal/KivaRaw_31May2013/RAW_kiva_ds_json_downloaded_31May2013/loans_lenders/"

base_dir = "/data/kivafinal/kivafinal/KivaRaw_31May2013/RAW_kiva_ds_json_downloaded_31May2013/loans_lenders/"

file_attempt = "1.json"

def process_loan_lender_file(file)
  read = File.open(file).read()
  full_json = JSON.parse(read)
  loans = full_json["loans_lenders"]
  
  for loan in loans
   #pull into mysql...
   #begin 
    if !loan["lender_ids"].nil?
      for lender in loan["lender_ids"]
       new_lender = LoanLender.new()
       new_lender.loan_id = loan["id"]
       new_lender.lender_id = lender  
       new_lender.save()
      end
    else
      new_lender = LoanLender.new()
      new_lender.loan_id = loan["id"]
      #new_lender.lender_id = lender  
      new_lender.save()
    end
      
   #rescue
   #  puts "error... in #{file}"
   #end
    
    
  end

end

listings = Dir[base_dir + "*.json"]

for file in listings
  process_loan_lender_file(file)
end
