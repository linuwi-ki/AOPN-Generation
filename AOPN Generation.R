#
# /***************************************/
# /  AOPWiki v2.5 data processing         /
# /  for AOP network generation           /
# /                                       /
# /                                       /
# /  Linus Wiklund                        /
# /  Institute of Environmental Medicine  /
# /  Karolinska Institutet, Sweden        /
# /                                       /
# /  Last updated: March 2023             /
# /***************************************/
# 
# This project is licensed under the terms of the
# Creative Commons Attribution 4.0 International license.
# 
#
#
# (Install and) load packages needed for data processing
# install.packages("dplyr")
# install.packages("writexl")
# install.packages("magrittr")
# install.packages("readxl")
library(dplyr)
library(writexl)
library(magrittr)
library(readxl)


# Import data from the folder "data" located in the working directory
# and rename columns to something easier to read
aop_ke_ec<-read.delim(file="./data/aop_ke_ec.tsv", header = FALSE,
                      col.names = c("AOP", "Event", "Direction", "Object_Source",
                                    "Object_Ontology_ID", "Object_Term", "Process_Source",
                                    "Process_Ontology_ID", "Process_Term"))
aop_ke_ker<-read.delim(file="./data/aop_ke_ker.tsv", header = FALSE,
                      col.names = c("AOP", "Event", "Target", "Relationship",
                                     "Adjacency", "Evidence", "Quantitative"))
aop_ke_mie_ao<-read.delim(file="./data/aop_ke_mie_ao.tsv", header = FALSE,
                      col.names = c("AOP", "Event", "Event_Type", "Description"))

# Change certain column data type to character, to convert integer values for
# evidence and quantitative knowledge into high/moderate/low later on:
aop_ke_ker$Evidence = as.character(as.integer(aop_ke_ker$Evidence))
aop_ke_ker$Quantitative = as.character(as.integer(aop_ke_ker$Quantitative))

# Loop through each row in specific columns to delete letters, but keep numbers.
# E.g. turn AOP IDs from "AOP:31" to "31", then insert the result into the data frame.
for (row in 1:nrow(aop_ke_ker)) {
  a<-aop_ke_ker[row,1]
  a<-gsub("^.*?:", "", a)
  aop_ke_ker[row,1]<-as.integer(a)
  
  a<-aop_ke_ker[row,2]
  a<-gsub("^.*?:", "", a)
  aop_ke_ker[row,2]<-as.integer(a)
  
  a<-aop_ke_ker[row,3]
  a<-gsub("^.*?:", "", a)
  aop_ke_ker[row,3]<-as.integer(a)
  
  a<-aop_ke_ker[row,4]
  a<-gsub("^.*?:", "", a)
  aop_ke_ker[row,4]<-as.integer(a)
  
# Change integer values to categories for the evidence and quantitative columns (KER)
  if(is.na(aop_ke_ker[row,6])) {
    evi<-"NA"
    aop_ke_ker[row,6]<-as.character(evi)
  } else if(aop_ke_ker[row,6]=="1") {
    evi<-"High"
    aop_ke_ker[row,6]<-as.character(evi)
  } else if(aop_ke_ker[row,6]=="2") {
    evi<-"Moderate"
    aop_ke_ker[row,6]<-as.character(evi)
  } else if(aop_ke_ker[row,6]=="3") {
    evi<-"Low"
    aop_ke_ker[row,6]<-as.character(evi)
  } else if(aop_ke_ker[row,6]=="5") {
    evi<-"Not Specified"
    aop_ke_ker[row,6]<-as.character(evi)
  }
  
  if(is.na(aop_ke_ker[row,7])) {
    quant<-"NA"
    aop_ke_ker[row,7]<-as.character(quant)
  } else if(aop_ke_ker[row,7]=="1") {
    quant<-"High"
    aop_ke_ker[row,7]<-as.character(quant)
  } else if(aop_ke_ker[row,7]=="2") {
    quant<-"Moderate"
    aop_ke_ker[row,7]<-as.character(quant)
  } else if(aop_ke_ker[row,7]=="3") {
    quant<-"Low"
    aop_ke_ker[row,7]<-as.character(quant)
  } else if(aop_ke_ker[row,7]=="5") {
    quant<-"Not Specified"
    aop_ke_ker[row,7]<-as.character(quant)
  }
}

# Loop through the AOP and Event columns and remove the letters, but keep numbers (KE_MIE_AO)
for (row in 1:nrow(aop_ke_mie_ao)) {
  a<-aop_ke_mie_ao[row,1]
  a<-gsub("^.*?:", "", a)
  aop_ke_mie_ao[row,1]<-as.integer(a)
  
  a<-aop_ke_mie_ao[row,2]
  a<-gsub("^.*?:", "", a)
  aop_ke_mie_ao[row,2]<-as.integer(a)
  
# Also shorten the Event type into MIE, KE or AO.
  if(aop_ke_mie_ao[row,"Event_Type"]=="AdverseOutcome") {
    i<-"AO"
    aop_ke_mie_ao[row,"Event_Type"]<-as.character(i)
  } else if(aop_ke_mie_ao[row,"Event_Type"]=="KeyEvent") {
    i<-"KE"
    aop_ke_mie_ao[row,"Event_Type"]<-as.character(i)
  } else if(aop_ke_mie_ao[row,"Event_Type"]=="MolecularInitiatingEvent") {
    i<-"MIE"
    aop_ke_mie_ao[row,"Event_Type"]<-as.character(i)
  }
}

# Loop through the AOP and Event columns and remove the letters, but keep numbers (KE_EC)
for (row in 1:nrow(aop_ke_ec)) {
  a<-aop_ke_ec[row,1]
  a<-gsub("^.*?:", "", a)
  aop_ke_ec[row,1]<-as.integer(a)
  
  a<-aop_ke_ec[row,2]
  a<-gsub("^.*?:", "", a)
  aop_ke_ec[row,2]<-as.integer(a)
}

# Clean up some temporary variables
rm(a, i, quant, evi, row)

# Change column data type to numeric instead of character.
aop_ke_mie_ao$Event = as.numeric(as.character(aop_ke_mie_ao$Event))
aop_ke_mie_ao$AOP = as.numeric(as.character(aop_ke_mie_ao$AOP))
aop_ke_ker$AOP = as.numeric(as.character(aop_ke_ker$AOP))
aop_ke_ker$Event = as.numeric(as.character(aop_ke_ker$Event))
aop_ke_ker$Target = as.numeric(as.character(aop_ke_ker$Target))
aop_ke_ker$Relationship = as.numeric(as.character(aop_ke_ker$Relationship))
aop_ke_ec$AOP = as.numeric(as.character(aop_ke_ec$AOP))
aop_ke_ec$Event = as.numeric(as.character(aop_ke_ec$Event))

# Keeping the old data frames and creating new ones to modify and filter further.
# The old data frames can be used if an AOPN of the entire AOP-Wiki is needed
# or to make sure that filtering was done properly.
df_mie_ao<-aop_ke_mie_ao
df_ker<-aop_ke_ker
df_kec<-aop_ke_ec


# *** Filtration of AOPs ***
# To keep only the AOPs of interest for the network generation using an excel file
# "AOPs_To_Export.xlsx" with a list of AOP IDs to be kept.
# Sheet name must be "sheet1" in this case, but this can easily be modified by 
# changing the parameter in sheet = "X". Also, the column title in this case is 
# "EATS", but the AOPFilter$VARIABLE can be changed to the column name in the excel file.
# Another example is provided below for the T-modality. Note which variables have been changed.


# EATS
AOPFilter<-read_excel("AOPs_To_Export.xlsx", sheet = "sheet1")
df_kec<-subset(aop_ke_ec, aop_ke_ec$AOP %in% AOPFilter$EATS)
df_ker<-subset(aop_ke_ker, aop_ke_ker$AOP %in% AOPFilter$EATS)
df_mie_ao<-subset(aop_ke_mie_ao, aop_ke_mie_ao$AOP %in% AOPFilter$EATS)


# Thyroid
# AOPFilter<-read_excel("AOPs_To_Export.xlsx", sheet = "sheet1")
# df_kec<-subset(aop_ke_ec, aop_ke_ec$AOP %in% AOPFilter$Thyroid)
# df_ker<-subset(aop_ke_ker, aop_ke_ker$AOP %in% AOPFilter$Thyroid)
# df_mie_ao<-subset(aop_ke_mie_ao, aop_ke_mie_ao$AOP %in% AOPFilter$Thyroid)


# Combine Object/Process Source, Ontology ID and Term in the KEC table for each
# event so that there are no duplicate values.
df_kec<-df_kec %>%
  group_by(Event) %>%
  mutate(Object_Source=paste(unique(Object_Source), collapse='; ')) %>%
  mutate(Object_Ontology_ID=paste(unique(Object_Ontology_ID), collapse='; ')) %>%
  mutate(Object_Term=paste(unique(Object_Term), collapse='; ')) %>%
  ungroup()
df_kec<-df_kec[!duplicated(df_kec), ]

df_kec<-df_kec %>%
  group_by(Event) %>%
  mutate(Process_Source=paste(unique(Process_Source), collapse='; ')) %>%
  mutate(Process_Ontology_ID=paste(unique(Process_Ontology_ID), collapse='; ')) %>%
  mutate(Process_Term=paste(unique(Process_Term), collapse='; ')) %>%
  ungroup()
df_kec<-df_kec[!duplicated(df_kec), ]

df_kec<-df_kec %>%
  group_by(Event) %>%
  mutate(Direction=paste(unique(Direction), collapse=', ')) %>%
  ungroup()
df_kec<-df_kec[!duplicated(df_kec), ]

# Merge processed tables in two steps, based on the shared 'Event' and 'AOP' columns.
# Some data for each event will be duplicated on each row because the source event
# has relationships with other target events.
joined_table<-merge(data.frame(df_mie_ao, row.names=NULL), data.frame(df_ker[
                    c("AOP", "Event", "Target", "Relationship", "Adjacency", "Evidence", "Quantitative")],
                    row.names=NULL), by = c("Event", "AOP"), all = TRUE)

joined_table<-merge(data.frame(joined_table, row.names=NULL), data.frame(df_kec[
                    c("Event", "Direction", "Object_Source", "Object_Ontology_ID", "Object_Term", 
                    "Process_Source","Process_Ontology_ID", "Process_Term")], row.names=NULL), 
                    by = "Event", all = TRUE)

# Remove duplicates
joined_table<-joined_table[!duplicated(joined_table), ]


# Save the joined table as a semicolon (;) separated file that can be imported into Cytoscape!
write.table(joined_table, file = "Table.csv", row.names = FALSE, sep = ";", quote = FALSE)

# Or save the joined table as an excel file that can be imported into Cytoscape!
#write_xlsx(joined_table, "./Table.xlsx")

# In the Cytoscape software, after choosing "Import->Network from file" make sure
# to enter the advanced options and set the delimiter to semicolon (;) ONLY.
# The "Event" Column is the Source node and the "Target" column is the Target node.
# Adjacency is the interaction type. 