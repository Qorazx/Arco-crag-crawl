#load packages
library(dplyr)
library(rvest)
library(readxl)

#scrap data from 8a.nu from multiple pages and collecting it in a data frame

routes = data.frame()

for(page_result in seq(from = 1, to = 3, by = 1)){
  link = paste0("https://www.8a.nu/areas/italy/arco/sportclimbing?page=", page_result)
  page <- read_html(link)
  
  #grabing info from the page that lists all routes
  grade <- page %>% html_nodes(".grade") %>% html_text()
  name <- page %>% html_nodes(".name-link a") %>% html_text()
  sector <- page %>% html_nodes(".sub-link") %>% html_text()
  routes = rbind(routes, data.frame(name, sector, grade, stringsAsFactors = FALSE))
  print(paste("Page:", page_result))
}
#Clean data frame
#~ symbol is used to create an anonymous function that applies the gsub() 
#function to every column in the data frame. 
routes <- routes %>% mutate_all(~ gsub("\n","", .))

#remove duplicate rows
routes = distinct(routes)
#remove N.N. routes
routes = subset(routes, name != "N.N.")

print(routes)







