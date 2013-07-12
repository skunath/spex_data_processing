require 'java'
require 'JSON'
require_relative 'db_connect'

r_start_load_date = Loan.find(:first, :conditions => ["country = 'Bolivia' and funded_date is not null"], :order => "funded_date")
start_date = r_start_load_date.funded_date
end_date = start_date.next_year.next_year.next_year

training_loans = LoanDescription.find(:all, :conditions => ["language = ?","en"], :limit => 10000)
  
training_data = File.open("./data/lda_source.txt","w")
for loan in training_loans
  line = " | "
  #description = loan.loan_descriptions.find(:first, :conditions => ["language = 'en'"]) 
  description = loan.description.downcase.gsub(":","").gsub("\n"," ")
  line += description
  
  training_data.puts line
end
training_data.close()


