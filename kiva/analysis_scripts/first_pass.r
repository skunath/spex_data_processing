library(RMySQL)
library(ggplot2)
library(gridExtra)

m<-dbDriver("MySQL");
con<-dbConnect(m,user='root',dbname='xdata_kiva');

res<-dbSendQuery(con, "SELECT extract(year_month from processed_date) as timer, b.partner_id, sum(a.amount) as paid FROM xdata_kiva.loan_payments a
  left outer join loans b on b.id = a.loan_id
  where b.partner_id = 248
  group by b.partner_id, extract(year_month from processed_date)")
month_amounts <- fetch(res, n = -1)

  t <- ggplot(month_amounts, aes(timer, paid)) + geom_line() 
  #t <- t + scale_x_continuous(breaks=round(seq(min(slices$minutes), max(slices$minutes), by=2)))
  #t <- t + scale_y_continuous(limits=c(0,32))
  t <- t + ggtitle("test")
#  png(paste("/R_Graphs/chat_timelines/",session$source_file,"_",session$treatment,".png",sep=""), width=1200, height=500)
  plot(t)
 # dev.off()


dbDisconnect(con)