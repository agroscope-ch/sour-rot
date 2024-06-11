## Import data sour rot
library(tidyverse)
library(readxl)
library(stringr)

LoadSourRot <- function(normalization = FALSE )
{
  
  # normalization: if TRUE, returns the proportion of species in each sample and not the absolute number of occurrences
  dfSourRot <- read_excel(path = "Data/data_sour_rot.xlsx", col_names = T, skip = 1)
  apply(dfSourRot, 2, function(z)all(is.na(z))) |> which()
  # dfSourRot <- dfSourRot |> 
  #   dplyr::rename(species = "genotype", order = "ordre")
  # We remove this problematic sample
  dfSourRot <- dfSourRot |> 
    select(-G4B1) 
  dfSourRot$family[is.na(dfSourRot$family)] <- "Incertae sedis"
  dfSourRot <- dfSourRot |> relocate(order, family, genus, species)

  dfSourRot <- dfSourRot |> 
    mutate(dplyr::across(.cols = -c(order, family, genus, species), .fns = ~replace_na(.,0))) 
  
  
  # removes the all 0 rows
  dfSourRot <- dfSourRot |> 
    filter(! if_all(-c(order, family, genus, species), ~. == 0))
  
  
  
  ids <- apply(dfSourRot[,1:4], 1, function(z)length(unique(z)) ) == 4
  dfSourRot <- dfSourRot[ids,]
  
  ## merge identical rows (identical means with same order, family, genus, species),
  ## by summing corresponding values of abundance
  dfSourRot <- dfSourRot |> 
    group_by(order, family, genus, species) |> 
    dplyr::summarise(across(everything(),  ~ sum(.x, na.rm = TRUE))) |> 
    ungroup()
  if(normalization)
  {
    dfSourRot <- dfSourRot |> 
      mutate(across(.cols = c(-order, -family, -genus, -species ),  ~ ./sum(.))) # use only proportion of species in samples
  }
  ## removing unwanted spaces at the beggining of a string
  dfSourRot[,1:4] <- apply(dfSourRot[,1:4], 2, function(z) stringr::str_replace(string = z, pattern = "^\\s+", replacement = ""))
  dfSourRot[,1:4] <- apply(dfSourRot[,1:4], 2, function(z) stringr::str_replace(string = z, pattern = "\\s+", replacement = " "))
  
  ## vars is the names of the samples. There are indicated as the columns of type "double"
  vars <- colnames(dfSourRot)[sapply(dfSourRot, typeof) =="double"]
  ## For each sample, we deduce from its name what is its type ("insect", "extern" or "sour rot")
  ## The patterns are provided as regular expressions
  types <- rep(NA,length(vars))
  pat <- c("male|female|other", 
           "[A-Z]\\d{2}C", # Maj-2digits-C
           "[A-Z]\\d+?B") # Maj-aussi peu de digits que possible-B
  typesNames <- c("insect", "extern", "sour rot")
  cbind(pat, typesNames)
  for(i in 1:length(pat))
  {
    ind <- grepl(pattern = pat[i], x = vars)
    types[ind] <- typesNames[i]
  }
  ## A list of three components is returned
  ## 1: the dataset itself
  ## 2: the name of the samples
  ## 3: the types corresponding to the samples
  return(list(dfSourRot = dfSourRot, vars = vars, types = types))
}




create_desMat <- function(level.work)
{
  
  dfSourRotSelect <- dfSourRot[,c(level.work, vars)] |> 
    group_by(pick({{level.work}})) |> 
    dplyr::summarise(across(.cols = {{vars}}, .fns = ~ sum(.x, na.rm = TRUE)))
  
  target <- dfSourRotSelect[[level.work]]
  
  ## creates the design matrix, essentially the transpose of the data frame
  desMatrix <- dfSourRotSelect[,vars] |> as.matrix() |> t() |> as.data.frame()
  ## rename the columns of the design matrix with the corresponding names
  names(desMatrix) <- target
  desMatrix
}


