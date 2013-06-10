require 'JSON'
require_relative 'db_connect'


#base_dir = "/data/kivafinal/kivafinal/KivaRaw_31May2013/RAW_kiva_ds_json_downloaded_31May2013/loans_lenders/"

base_dir = "/data/kivafinal/kivafinal/KivaRaw_31May2013/RAW_kiva_ds_json_downloaded_31May2013/loans/"

file_attempt = "1.json"

def process_loan_file(file)
  read = File.open(file).read()
  full_json = JSON.parse(read)
  loans = full_json["loans"]
  
  for loan in loans
   #pull into mysql...
   #begin 
   new_loan = Loan.new()
   new_loan.kiva_id = loan["id"]
   new_loan.name = loan["name"]
   new_loan.status = loan["status"]
   new_loan.funded_amount = loan["funded_amount"]
    new_loan.basket_amount = loan["basket_amount"]
    new_loan.paid_amount = loan["paid_amount"]
    new_loan.video = loan["video"]
    new_loan.activity = loan["activity"]
    new_loan.sector = loan["sector"]
    new_loan.use = loan["use"]
    new_loan.delinquent = loan["delinquent"]
    
    new_loan.country_code = loan["location"]["country_code"]
    new_loan.country = loan["location"]["country"]
    new_loan.town = loan["location"]["town"]
    new_loan.level = loan["location"]["geo"]["level"]
    new_loan.pairs = loan["location"]["geo"]["pairs"]
    new_loan.pairs_type = loan["location"]["geo"]["type"]
    
    new_loan.partner_id = loan["partner_id"]
    new_loan.posted_date = loan["posted_date"]
    new_loan.planned_expiration_date = loan["planned_expiration_date"]
    new_loan.loan_amount = loan["loan_amount"]
    new_loan.currency_exchange_loss_amount = loan["currency_exchange_loss_amount"]
    new_loan.funded_date = loan["funded_date"]
    new_loan.paid_date = loan["paid_date"]
    new_loan.image_id = loan["image"]["id"]
    new_loan.image_template_id = loan["image"]["template_id"]
            
    new_loan.loss_liability_nonpayment = loan["terms"]["loss_liability"]["nonpayment"]
    new_loan.loss_liability_currency_exchange = loan["terms"]["loss_liability"]["currency_exchange"]
    new_loan.loss_liability_currency_exchange_coverage_rate = loan["terms"]["loss_liability"]["currency_exchange_coverage_rate"]
          
    new_loan.journal_entries = loan["journal_totals"]["entries"]
    new_loan.journal_bulkEntries = loan["journal_totals"]["bulkEntries"]
        
    new_loan.save
    
    
    for borrower in loan["borrowers"]
      new_loan_borrower = LoanBorrower.new()
      new_loan_borrower.loan_id = new_loan.id
      new_loan_borrower.first_name = borrower["first_name"]
      new_loan_borrower.last_name = borrower["last_name"]
      new_loan_borrower.gender = borrower["gender"]
      new_loan_borrower.pictured = borrower["pictured"]
      new_loan_borrower.save()
    end

    for loan_payment in loan["payments"]
      new_loan_payment = LoanPayment.new()
      new_loan_payment.loan_id = new_loan.id
      new_loan_payment.amount = loan_payment["amount"]
      new_loan_payment.local_amount = loan_payment["local_amount"]
      new_loan_payment.processed_date = loan_payment["processed_date"]
      new_loan_payment.settlement_date = loan_payment["settlement_date"]
      new_loan_payment.rounded_local_amount = loan_payment["rounded_local_amount"]
      new_loan_payment.currency_exchange_loss_amount = loan_payment["currency_exchange_loss_amount"]
      new_loan_payment.payment_id = loan_payment["payment_id"]
      new_loan_payment.comment = loan_payment["comment"]
      new_loan_payment.save  
    end
    
    for scheduled_payment in loan["terms"]["scheduled_payments"]
      new_scheduled_payment = LoanScheduledPayment.new()
      new_scheduled_payment.loan_id = new_loan.id
      new_scheduled_payment.amount = scheduled_payment["amount"]
      new_scheduled_payment.due_date = scheduled_payment["due_date"]
      new_scheduled_payment.save()
    end
  
    for local_payment in loan["terms"]["local_payments"]
      new_local_payment = LoanLocalPayment.new()
      new_local_payment.loan_id = new_loan.id
      new_local_payment.amount = local_payment["amount"]
      new_local_payment.due_date = local_payment["due_date"]
      new_local_payment.save()
    end
       
    for loan_description_language in loan["description"]["languages"]
      new_loan_description = LoanDescription.new()
      new_loan_description.loan_id = new_loan.id
      new_loan_description.language = loan_description_language
      new_loan_description.description = loan["description"]["texts"][loan_description_language]
      new_loan_description.save
      
    end
    
   #rescue
   #  puts "error... in #{file}"
   #end
    
    
  end

end

#read = File.open(base_dir + file_attempt).read()
#full_json = JSON.parse(read)
#loans = full_json["loans"]
#puts JSON.pretty_generate(lenders[1])

listings = Dir[base_dir + "*.json"]

for file in listings
  process_loan_file(file)
end
