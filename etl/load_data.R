pacman::p_load(tidyverse, janitor, dataverse)

# Install from GitHub
# install.packages("remotes")
# remotes::install_github("iqss/dataverse-client-r")
library(dataverse)

Sys.setenv("DATAVERSE_SERVER" = "dataverse.unc.edu")



download.file("https://dataverse.unc.edu/api/access/datafile/7526756", destfile  = here::here("data","source","incumbents_data.xlsx"))

incumbents<- readxl::read_xlsx(here::here("data","source","incumbents_data.xlsx"))

download.file("https://dataverse.unc.edu/api/access/datafile/7526755", destfile = here::here("data","source","non_incumbents_data.xlsx"))

non_incumbents<- readxl::read_xlsx(here::here("data","source","non_incumbents_data.xlsx"))



# USED TO CREATE THE DATAVERSE XLSX FILES FROM MULTIPLE SPREADSHEETS. NO LONGER NEEDED.
#
#non_incumbent_files <- list.files(pattern = ".NON.xlsx$")
#
#ninc_df_names <- str_sub(non_incumbent_files,1,-6)
#
#for(i in 1:length(non_incumbent_files)) {
#  dfname <- ninc_df_names[i]
#  cont_str_end <- unlist(gregexpr("\\.", non_incumbent_files[i]))[2]-1
#  state<- str_sub(non_incumbent_files,1,2)
#  assign(dfname, read_xlsx(non_incumbent_files[i],
#                           na = c("N/A","NA"),
#                           col_types = c(rep("text",2),
#                                         "date",
#                                         rep("text",6),
#                                         "numeric",
#                                         rep("text",5)
#                           )
#  )
#  %>%
#    clean_names() %>%
#    mutate(state=state[i],
#           contest= str_sub(non_incumbent_files[i],4,cont_str_end)
#    ))
#
#}
#
#
#
# FOR CREATING INCUMBENTS_DATA.XLSX
#
#incumbent_files <- list.files(pattern = ".IN.xlsx$")
# #
# # inc_df_names <- str_sub(incumbent_files,1,-6)
# #
# for(i in 1:length(incumbent_files)) {
#   dfname <- inc_df_names[i]
#   cont_str_end <- unlist(gregexpr("\\.", incumbent_files[i]))[2]-1
#   state<- str_sub(incumbent_files,1,2)
#   assign(dfname, read_xlsx(incumbent_files[i],
#                            na = "N/A",
#                            col_types = c(rep("text",2),
#                                          "date",
#                                          rep("text",6),
#                                          "numeric",
#                                          rep("text",10)
#                            )
#   )
#   %>%
#     clean_names() %>%
#     mutate(state=state[i],
#            contest= str_sub(incumbent_files[i],4,cont_str_end)
#     ))
#
# }


##Error: Sheet 1 has 26 columns, but `col_types` has length 20.
# Solution: Ryan deleted columns U-Z in NY.Erie.Flynn.IN on /Users/thornbur/Documents/prosproj/data/source

##In addition: Warning messages:
##1: Expecting numeric in J40 / R40C10: got 'Not listed'
# Solution: Ryan deleted "Not listed" from cell J40 -- the length of article column -- in NY.Albany.Soares.IN on /Users/thornbur/Documents/prosproj/data/source. See 10/28/22 email

##2: Expecting date in C184 / R184C3: got '6/1/12020'
# Solution: In row 184 I changed the date to “6/1/20”, based on what I see at https://www.timesunion.com/news/article/Legislature-to-convene-next-week-to-dismantle-law-15307957.php See 10/28/22 email

##3: Expecting date in C275 / R275C3: got '2/6/220'
# Solution: In row 275 I changed the date to “2/6/20” (It is marked as a duplicate of another article dated 2/4/20) See 10/28/22 email



# JOIN AND CLEAN UP INCUMBENTS DF
# incumbents<- tibble()
# for(x in ls()){
#   if(str_detect(x, "\\.IN")){
#
#     incumbents<- bind_rows(incumbents,get(x))
#   }
# }
#
# incumbents <- clean_names(incumbents)
#
#
#NEXT LINES BECAUSE DEVINNEY HAD NO STORIES
#devinney <- c(NA, "Devinney", rep(NA,18),"KS","Butler",NA)
#incumbents<- rbind(incumbents, devinney)

# JOIN AND CLEAN UP NON-INCUMBENTS DF
#
# non_incumbents <- tibble()
# for(x in ls()){
#   if(str_detect(x, "\\.NON")){
#     non_incumbents<- bind_rows(non_incumbents,get(x))
#   }
#
# }

#Removing articles not in 2020
incumbents<- incumbents %>% filter(lubridate::year(date_of_article) == 2020 | #need next line for devinney
is.na(date_of_article))

non_incumbents<- non_incumbents %>% filter(lubridate::year(date_of_article) == 2020)

source(here::here("etl","competitive_seats.R"))
source(here::here("etl", "binding_incumbents_challengers.R"))

save.image(file=here::here("data","processed/etl.Rdata"))

