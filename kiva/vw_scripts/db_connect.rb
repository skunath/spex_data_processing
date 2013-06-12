require "activerecord-jdbc-adapter"
#require "activerecord-jdbcmysql-adapter"
#require 'jdbc-mysql'

ActiveRecord::Base.establish_connection(
    :adapter => "jdbcmysql",
    :driver => "com.mysql.jdbc.Driver",
    :host => "localhost",
    :username => "root",
    :url  => "jdbc:mysql://localhost:3306/xdata_kiva",
    :encoding => "utf8"
)

class Lender < ActiveRecord::Base
end

# partner stuff

class Partner < ActiveRecord::Base
end

class PartnerCountry < ActiveRecord::Base
end

# loan stuff

class Loan < ActiveRecord::Base
  has_many :loan_descriptions
end

class LoanBorrower < ActiveRecord::Base
end

class LoanDescription < ActiveRecord::Base
  belongs_to :loan
end

class LoanLocalPayment < ActiveRecord::Base
end

class LoanPayment < ActiveRecord::Base
end

class LoanScheduledPayment < ActiveRecord::Base
end

class LoanLender < ActiveRecord::Base
end
