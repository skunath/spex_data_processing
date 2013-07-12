library(RMySQL)
library(ggplot2)
library(gridExtra)
library(scales)

m<-dbDriver("MySQL");
con<-dbConnect(m,user='root',dbname='xdata_kiva');

cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")


res<-dbSendQuery(con, "SELECT 
concat(extract(year from processed_date),'-', extract(month from processed_date), '-01') as timer, 
b.partner_id, sum(a.amount) as paid,
b.id as loan_id
FROM xdata_kiva.loan_payments a
  left outer join loans b on b.id = a.loan_id
  where b.partner_id = 249
  group by b.id, extract(year_month from processed_date)")
month_amounts <- fetch(res, n = -1)

t <- ggplot(month_amounts, aes(x = as.Date(timer), y= paid, group = loan_id, colour=factor(loan_id)))  
#t <- t + scale_colour_manual(values=cbPalette)
t <- t + geom_line(aes(group=loan_id, color = factor(loan_id)))

#t <- t + geom_smooth(aes(group=loan_id))

t <- t + geom_point()
#t <- t + scale_x_continuous(breaks=round(seq(min(slices$minutes), max(slices$minutes), by=2)))
#t <- t + scale_y_continuous(limits=c(0,500))
t <- t + ggtitle("test")
t <- t + labs(x = "Month", y = "Loans") + scale_x_date(labels = date_format("%m-%Y"))
#  png(paste("/R_Graphs/chat_timelines/",session$source_file,"_",session$treatment,".png",sep=""), width=1200, height=500)
plot(t)
# dev.off()


dbDisconnect(con)