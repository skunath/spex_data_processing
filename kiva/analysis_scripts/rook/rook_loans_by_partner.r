

do_stuff <- function(req, res) {
  #m<-dbDriver("MySQL");
  con<-dbConnect(MYSQL,user='root',dbname='xdata_kiva');
  
  cbPalette <- c("#999999", "#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2", "#D55E00", "#CC79A7")
  
  partner_id <- req$GET()$partner_id
  query <- paste("SELECT 
  concat(extract(year from processed_date),'-', extract(month from processed_date), '-01') as timer, 
  b.partner_id, sum(a.amount) as paid,
  b.id as loan_id
  FROM xdata_kiva.loan_payments a
    left outer join loans b on b.id = a.loan_id
    where b.partner_id = ",partner_id,"
    group by b.id, extract(year_month from processed_date)", sep="")
  
  connector <- dbSendQuery(con, query)
  month_amounts <- fetch(connector, n = -1)
  
  dbDisconnect(con)
  
  
  t <- ggplot(month_amounts, aes(x = as.Date(timer), y= paid, group = loan_id, colour=factor(loan_id)))  
  #t <- t + scale_colour_manual(values=cbPalette)
  t <- t + geom_line(aes(group=loan_id, color = factor(loan_id)))
  
  #t <- t + geom_smooth(aes(group=loan_id))
  
 # t <- t + geom_point()
  #t <- t + scale_x_continuous(breaks=round(seq(min(slices$minutes), max(slices$minutes), by=2)))
  #t <- t + scale_y_continuous(limits=c(0,500))
#  t <- t + ggtitle("test")
 # t <- t + labs(x = "Month", y = "Average Visits per User") + scale_x_date(labels = date_format("%m-%Y"))
  
  #png(paste(PIC.DIR, "/testing.png", sep = ""), width=1200, height=500)
  #a <- plot(t)
  #dev.off()
  #ggsave(plot=t, file.path(getwd(), "tester.png"))
  
  ggsave(plot=t, paste(PIC.DIR, "/testing.png", sep = ""), width=12, height=8)
  


  return(1)
}

LoansByPartner.app <- function(env){
  req <- Rook::Request$new(env)
  res <- Rook::Response$new()
  
  
  do_stuff(req, res)
  res$write(paste("<img src='", 
                  R.server$full_url("pic"), 
                  "/testing.png'", 
                  "width='650 px' height='650 px' />", sep = ""))
  res$finish()
  
}