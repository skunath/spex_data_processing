library(RMySQL)
library(ggplot2)
library(gridExtra)
library(scales)

m<-dbDriver("MySQL");
#con<-dbConnect(m,user='root',dbname='xdata_kiva', client.flag = CLIENT_MULTI_STATEMENTS);

con <- dbConnect(MySQL(),user='root',dbname='xdata_kiva', 
                    client.flag = CLIENT_MULTI_STATEMENTS)

cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")

query1 <- "set @rank_counter := 0;"
query2 <- "set @sector := null;"

query3 <- "select kiva_id, counter, @rank_counter := if(@sector = sector, @rank_counter + 1, @rank_counter := 1) as rank, 
            @sector := sector as sector from (
            SELECT a.kiva_id, sector, count(*) as counter FROM loans a
            left outer join journal_comments b on b.kiva_loan_id = a.kiva_id
            where b.kiva_loan_id is not null
            group by a.kiva_id
            order by sector, counter desc
            ) f"

res<-dbSendQuery(con, query1)
res<-dbSendQuery(con, query2)
res<-dbSendQuery(con, query3)
loan_journals <- fetch(res, n = -1)

t <- ggplot(loan_journals, aes(x = rank, y= counter, group=sector, colour=sector))
#t <- t + scale_colour_manual(values=cbPalette)
t <- t + geom_line()

#t <- t + geom_smooth(aes(group=loan_id))

t <- t + geom_point()
#t <- t + scale_x_continuous(breaks=round(seq(min(slices$minutes), max(slices$minutes), by=2)))
#t <- t + scale_y_continuous(limits=c(0,500))
t <- t + ggtitle("test")
t <- t + labs(x = "Rank", y = "Journal Entries") #+ scale_x_date(labels = date_format("%m-%Y"))
#  png(paste("/R_Graphs/chat_timelines/",session$source_file,"_",session$treatment,".png",sep=""), width=1200, height=500)
plot(t)
# dev.off()


dbDisconnect(con)