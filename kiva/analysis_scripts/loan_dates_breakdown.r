library(RMySQL)
library(ggplot2)
library(gridExtra)
library(scales)


m<-dbDriver("MySQL");
#con<-dbConnect(m,user='root',dbname='xdata_kiva', client.flag = CLIENT_MULTI_STATEMENTS);

con <- dbConnect(MySQL(),user='root',dbname='xdata_kiva', 
                    client.flag = CLIENT_MULTI_STATEMENTS)

cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

query1 <- "select country, sector, activity, date(posted_date) as dater, 
        count(*) as counter,
        avg(funded_amount) as avg_fund,
        (avg(funded_amount) + std(funded_amount)) as se_plus,
        (avg(funded_amount) - std(funded_amount)) as se_min
            from loans a
            where datediff(funded_date, posted_date) >= 0
            and (status = 'funded' or status = 'paid'  or status = 'in_repayment')
            group by activity, year(posted_date), month(posted_date)"

res<-dbSendQuery(con, query1)
loan_journals <- fetch(res, n = -1)
#t <- qplot(datediffer, data=loan_journals, geom="histogram", binwidth=1)
t <- ggplot(loan_journals, aes(x = as.Date(dater), y=counter, group=activity, color=activity))
#t <- t + scale_colour_manual(values=cbPalette)
t <- t + geom_line()
t <- t + scale_x_date()
#t <- t + geom_smooth(aes(ymin = se_min, ymax = se_plus, color=country), loan_journals=grid, stat="identity")
#t <- t + scale_fill_gradient("funded_amount", low = "green", high = "red")
#t <- t + scale_x_continuous(breaks=round(seq(min(slices$minutes), max(slices$minutes), by=2)))
#t <- t + scale_y_continuous(limits=c(0,500))
#t <- t + ggtitle("test")
#t <- t + labs(x = "Rank", y = "Journal Entries") #+ scale_x_date(labels = date_format("%m-%Y"))
#  png(paste("/R_Graphs/chat_timelines/",session$source_file,"_",session$treatment,".png",sep=""), width=1200, height=500)
plot(t)
# dev.off()


dbDisconnect(con)