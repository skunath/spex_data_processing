#!/usr/bin/Rscript
library(Rook)
library(RMySQL)
library(ggplot2)
library(gridExtra)
library(scales)
PIC.DIR = paste(getwd(), 'pic', sep='/')
MYSQL<-dbDriver("MySQL");

R.server <- Rhttpd$new()

# add an app
#source('hello_word.r')
#R.server$add(app = Rook.app, name = "hello_world")

source('rook_loans_by_partner.r')
R.server$add(name="loans_by_partner", app=LoansByPartner.app)

R.server$add(app = File$new(PIC.DIR), name = "pic")


cat("Type:", typeof(R.server), "Class:", class(R.server))

R.server$start(listen="0.0.0.0",port="20000")
print(R.server)

print(R.server)
#R.server$add(app = File$new(getwd()), name = "hello_world")
while (TRUE) Sys.sleep(24 * 60 * 60)