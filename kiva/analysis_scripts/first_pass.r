library(RMySQL)
library(ggplot2)
library(gridExtra)
library(scales)

m<-dbDriver("MySQL");
con<-dbConnect(m,user='root',dbname='xdata_kiva');

res<-dbSendQuery(con, "SELECT 
concat(extract(year from due_date),'-', extract(month from due_date), '-01') as timer, 
b.partner_id, sum(a.amount) as paid FROM xdata_kiva.loan_local_payments a
  left outer join loans b on b.id = a.loan_id
 
  group by b.partner_id, extract(year_month from due_date)")
month_amounts <- fetch(res, n = -1)

  t <- ggplot(month_amounts, aes(x = as.Date(timer), y= paid, group=partner_id, color=factor(partner_id)))  
  t <- t + geom_line(aes(colour=factor(partner_id)))
  #t <- t + geom_smooth(aes(group=factor(partner_id)))

  t <- t + geom_point()
  #t <- t + scale_x_continuous(breaks=round(seq(min(slices$minutes), max(slices$minutes), by=2)))
  #t <- t + scale_y_continuous(limits=c(0,500))
  t <- t + ggtitle("test")
  t <- t + labs(x = "Month", y = "Average Visits per User") + scale_x_date(labels = date_format("%m-%Y"))
#  png(paste("/R_Graphs/chat_timelines/",session$source_file,"_",session$treatment,".png",sep=""), width=1200, height=500)
  plot(t)
 # dev.off()


dbDisconnect(con)