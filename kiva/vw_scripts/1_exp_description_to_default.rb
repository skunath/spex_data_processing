require 'java'
require 'JSON'
require_relative 'db_connect'

r_start_load_date = Loan.find(:first, :conditions => ["country = 'Bolivia' and funded_date is not null"], :order => "funded_date")
start_date = r_start_load_date.funded_date
end_date = start_date.next_year.next_year.next_year

training_loans = Loan.find(:all, :conditions => ["country = 'Bolivia' and (status = 'paid' or status = 'defaulted') and funded_date >= ? and funded_date <= ?", start_date, end_date], :limit => 10000)
testing_loans = Loan.find(:all, :conditions => ["country = 'Bolivia' and (status = 'paid' or status = 'defaulted') and funded_date >= ?", end_date], :limit => 50000)
  
  
training_data = File.open("./data/training.txt","w")
for loan in training_loans
  line = ""
  #description = loan.loan_descriptions.find(:first, :conditions => ["language = 'en'"]) 
  use = loan.use.downcase.gsub(":","").gsub("\n"," ")
  activity = loan.activity.downcase.gsub(":","").gsub("\n"," ")
  sector = loan.sector.downcase.gsub(":","").gsub("\n"," ")
  status = loan.status.downcase.gsub(":","").gsub("\n"," ")
  
  funded_amount = loan.funded_amount
  country = loan.country_code
  journal_entries = loan.journal_entries
  
  i_status = -1
  i_status = 1 if status == "paid"
  
  line << i_status.to_s + " | " 
  #line << "sector " + sector + " | "
  line << "activity " + activity + " | "
  #line << "use " + use + " | " 
  
  line << "  funded " + funded_amount.to_s + " | " 
  line << " country " + country + " | " 
  line << "  journal_entries " + journal_entries.to_s + " | " 
        
  
  training_data.puts line
end
training_data.close()

testing_data = File.open("./data/testing.txt","w")
testing_data_id = File.open("./data/testing_id.txt","w")

for loan in testing_loans
  line = ""
  #description = loan.loan_descriptions.find(:first, :conditions => ["language = 'en'"]) 
  use = loan.use.downcase.gsub(":","").gsub("\n"," ")
  activity = loan.activity.downcase.gsub(":","").gsub("\n"," ")
  sector = loan.sector.downcase.gsub(":","").gsub("\n"," ")
  status = loan.status.downcase.gsub(":","").gsub("\n"," ")
  
  
  funded_amount = loan.funded_amount
  country = loan.country_code
  journal_entries = loan.journal_entries
  
  
  i_status = -1
  i_status = 1 if status == "paid"
  
  
  line << " | " 
  #line << "sector " + sector + " | "
  line << "activity " + activity + " | "
  #line << "use " + use + " | " 
  line << "  funded " + funded_amount.to_s + " | " 
  line << " country " + country + " | " 
  line << "  journal_entries " + journal_entries.to_s + " | " 
       
  
  testing_data.puts line
  
  eval_line = [loan.id, loan.status].join", "
  testing_data_id.puts eval_line

end
testing_data.close()
testing_data_id.close()
