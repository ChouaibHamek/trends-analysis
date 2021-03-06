source("./Helpers/FunctionsStackOverflowApi.R")

get_stackOverFlowData = function(app_path, query_string, my_filename) {

  my_articles = get_stackoverflow_data(query_string)

  abstract = my_articles$Abstract
  abstract = gsub("<code.*/code>", "", abstract)
  abstract = gsub("<code.*<truncated>", "", abstract)
  abstract = gsub("<.*?>", "", abstract)
  abstract = gsub("//.*\n", " ", abstract)
  abstract = gsub("\\{\n.*\\}\n", " ", abstract)
  abstract = gsub("[\r\n]", " ", abstract)
  abstract = gsub("\"", "", abstract)
  abstract = gsub("[0-9]", "", abstract)

  #Add cleaned abstracts as a new column. 
  #We could also replace the existing but debugging is easier if we keep both. 
  my_articles$Abstract_clean = tolower(abstract)
  my_articles$Title = tolower(my_articles$Title)

  #Date is character covert to Date object
  my_articles$Date = as.Date(my_articles$Date)
  my_articles$CR_Date = as.Date(my_articles$CR_Date)
  my_articles$LA_Date = as.Date(my_articles$LA_Date)

  #Fixed filename: data/STO_<xxx>_data.RData
  my_file = app_path
  my_file = paste(my_file, "/data/", sep="", collapse=" ")
  dir.create(my_file, showWarnings = TRUE, recursive = TRUE, mode = "0777")
  my_file = paste(my_file, "STO_", sep="", collapse=" ")
  my_file = paste(my_file, my_filename, sep="", collapse=" ")
  my_file = paste(my_file, "_data.RData", sep="", collapse=" ")
  
  save(my_articles, file=my_file)
  
  my_file = paste(my_file, ".csv", sep="", collapse=" ")
  write.csv(my_articles,file = my_file)
  
  return(my_file)
}



