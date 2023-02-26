#load packages
library(dplyr)
library(rvest)
library(readxl)

#scrap data from 8a.nu

link <- "https://www.8a.nu/areas/italy/arco/sportclimbing"
page <- read_html(link)

#grabing info from the page that lists all routes
grade <- page %>% html_nodes(".grade") %>% html_text()
name <- page %>% html_nodes(".name-link a") %>% html_text()
sector <- page %>% html_nodes(".sub-link") %>% html_text()

#grabbing info from each route on the list by going to the links of the routes and 
#extracting further information.

#generate list of links
route_links <- page %>% html_nodes(".name-link a") %>% 
  html_attr("href") %>% paste0("https://www.8a.nu",.) %>% paste0("?sortField=date&order=asc")

#create a logged in session to access route info
session_now <- session("https://vlatka.vertical-life.info/auth/realms/Vertical-Life/protocol/openid-connect/auth?client_id=8a-nu&scope=openid%20email%20profile&response_type=code&redirect_uri=https%3A%2F%2Fwww.8a.nu%2Fcallback&resource=https%3A%2F%2Fwww.8a.nu&code_challenge=X_FKD62HeQESVbcYJ_bSd9O8RfNnrc2GnTSG2oFkibw&code_challenge_method=S256")
# Find the login form on the page
log_in_form <- html_form(session_now)[[1]]
# Fill in the login form with your credentials, create a list to avoid check_form error.
vals <- list(username = "x",
             password = "x" 
             )
filled_form <- log_in_form %>% html_form_set(!!!vals, 
                           "username" = "x",
                           "password" = "x"
)
# Submit the form to log in
submitted <- html_form_submit(filled_form)

# check if log in worked.
profile_link <- submitted %>% session_follow_link("https://www.8a.nu/crags/sportclimbing/italy/massone/sectors/abissi-20c61/routes/aladin/?sortField=date&order=asc") %>% html_node(".user-links a")

if (!is.null(profile_link)) {
  print("You're logged in!")
} else {
  print("Login failed")
}


#get_route_details <- function(route_links) {
 route_links = "https://www.8a.nu/crags/sportclimbing/italy/massone/sectors/abissi-20c61/routes/aladin/?sortField=date&order=asc"
 route_page = read_html(route_links) 
 route_date = route_page %>% html_nodes(".user-name") %>% html_text()
#}
 print(route_date)
  


