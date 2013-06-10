require 'JSON'
require_relative 'db_connect'


#base_dir = "/data/kivafinal/kivafinal/KivaRaw_31May2013/RAW_kiva_ds_json_downloaded_31May2013/loans_lenders/"

base_dir = "/data/kivafinal/kivafinal/KivaRaw_31May2013/"

file = "partners.json"

read = File.open(base_dir + file).read()
full_json = JSON.parse(read)
partners = full_json["partners"]

for partner in partners
  new_partner = Partner.new()
  new_partner.kiva_id = partner["id"]
  new_partner.name = partner["name"]
  new_partner.status = partner["status"]
  new_partner.rating = partner["rating"]  
  new_partner.due_diligence_type = partner["due_diligence_type"]
  new_partner.image_id = partner["image"]["id"]
  new_partner.image_template_id = partner["image"]["template_id"]  
  new_partner.start_date = partner["start_date"]  
  new_partner.delinquency_rate = partner["delinquency_rate"]  
  new_partner.default_rate = partner["default_rate"]
  new_partner.total_amount_raised = partner["total_amount_raised"]
  new_partner.loans_posted = partner["loans_posted"]
  new_partner.save()
  
  for country in partner["countries"]
    new_partner_country = PartnerCountry.new()
    new_partner_country.partner_id = new_partner.id
    new_partner_country.iso_code = country["iso_code"]
    new_partner_country.region = country["region"]
    new_partner_country.name = country["name"]    
    new_partner_country.location_geo_level = country["location"]["geo"]["level"]
    new_partner_country.location_geo_pairs = country["location"]["geo"]["pairs"]
    new_partner_country.location_geo_type = country["location"]["geo"]["type"]      
    new_partner_country.save
  end
    
  #puts JSON.pretty_generate(partner)
  
end
  


