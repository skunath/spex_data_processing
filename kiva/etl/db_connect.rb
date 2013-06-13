require "active_record"

ActiveRecord::Base.establish_connection(
    :adapter => "mysql2",
    :host => "localhost",
    :username => "root",
    :database => "xdata_kiva",
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
end

class LoanBorrower < ActiveRecord::Base
end

class LoanDescription < ActiveRecord::Base
end

class LoanLocalPayment < ActiveRecord::Base
end

class LoanPayment < ActiveRecord::Base
end

class LoanScheduledPayment < ActiveRecord::Base
end

class LoanLender < ActiveRecord::Base
end

class LenderTeam < ActiveRecord::Base
end
