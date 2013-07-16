
target = "/data/xdata/allhydra_v1.csv"

file = File.open(target, "r").read().split("\n")

output = File.open("./output_for_lda.txt", "w")

for line in file
  message = ""
  split_line = line.split(",")
  message = split_line[-3].strip()
    
  if message != "" && split_line[4] == "N_TO_MS"
    source = split_line[-2].strip()
    called = split_line[-1].strip()
      
    puts "#{source} -> #{called} - #{message} "
    
    output_line = " | "
    output_line << message.downcase()
    output.puts output_line.gsub(":", "")
  end
end
output.close()