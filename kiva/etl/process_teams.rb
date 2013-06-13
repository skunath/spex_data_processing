require 'JSON'
require_relative 'db_connect'


#base_dir = "/data/kivafinal/kivafinal/KivaRaw_31May2013/RAW_kiva_ds_json_downloaded_31May2013/loans_lenders/"

base_dir = "/data/kivafinal/kivafinal/KivaRaw_31May2013/RAW_kiva_json_teams_9Feb2013/"

file_attempt = "pg1191_received_2013_02_19_15_03.json"

def process_team_file(file)
  read = File.open(file).read()
  full_json = JSON.parse(read)
  teams = full_json["teams"]
  
  for team in teams
    new_team = LenderTeam.new()
    new_team.kiva_id = team["id"]
    new_team.shortname = team["shortname"]
    new_team.name = team["name"]
    new_team.category = team["category"]
    new_team.image_id = team["image"]["id"] if team.has_key?("image")
    new_team.image_template_id = team["image"]["image_template_id"]  if team.has_key?("image")
    new_team.whereabouts = team["whereabouts"]
    new_team.loan_because = team["loan_because"]
    new_team.description = team["description"]
    new_team.website_url = team["website_url"]
    new_team.team_since = team["team_since"]
    new_team.membership_type = team["membership_type"]
    new_team.member_count = team["member_count"]
    new_team.loan_count = team["loan_count"]
    new_team.loaned_amount = team["loaned_amount"]
    new_team.save
  end
end

#process_team_file(base_dir + file_attempt)

#read = File.open(base_dir + file_attempt).read()
#full_json = JSON.parse(read)
#loans = full_json["loans"]
#puts JSON.pretty_generate(lenders[1])

listings = Dir[base_dir + "*.json"]

for file in listings
  process_team_file(file)
end
