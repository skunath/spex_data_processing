require 'JSON'
require_relative 'db_connect'


#base_dir = "/data/kivafinal/kivafinal/KivaRaw_31May2013/RAW_kiva_ds_json_downloaded_31May2013/loans_lenders/"

base_dir = "/data/kivafinal/kivafinal/KivaRaw_31May2013/RAW_kiva_ds_json_downloaded_31May2013/lenders/"

file_attempt = "1.json"

def process_lender_file(file)
  read = File.open(file).read()
  full_json = JSON.parse(read)
  lenders = full_json["lenders"]
  
  for lender in lenders
   #pull into mysql...
   #begin 
     new_lender = Lender.new()
     new_lender.lender_id = lender["lender_id"]
     new_lender.name = lender["name"]
     new_lender.whereabouts = lender["whereabouts"]
     new_lender.country_code = lender["country_code"]
     new_lender.uid = lender["uid"]
     new_lender.member_since = lender["member_since"]
     new_lender.personal_url = lender["personal_url"]
     new_lender.occupation = lender["occupation"]
     new_lender.loan_because = lender["loan_because"]
     new_lender.occupational_info = lender["occupational_info"]
     new_lender.loan_count = lender["loan_count"]
     new_lender.invitee_count = lender["invitee_count"]
     new_lender.inviter_id = lender["inviter_id"] 
     new_lender.image_id = lender["image"]["id"]
     new_lender.image_template_id = lender["image"]["template_id"]
     new_lender.save()
   #rescue
   #  puts "error... in #{file}"
   #end
    
    
  end

end

listings = Dir[base_dir + "*.json"]

for file in listings
  process_lender_file(file)
end
