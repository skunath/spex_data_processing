require 'rubygems'
require 'rbhive'
t = nil
RBHive.connect('127.0.0.1','10001') do |connection|
  t = connection.fetch 'select year(posted_date) as year_p, ngrams(sentences(lower(loan_use)),1,30) as tester from default.loans group by year(posted_date)'
end

puts t