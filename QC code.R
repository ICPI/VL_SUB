#Load Packages
library(tidyverse)
library(readxl)


#set working directory to find data (Mac Computer)
#setwd("~/Desktop/R/VL/Clean")

#set working directory to find data (Windows)
setwd("C:/Users/nmaina/Documents/Data")

# Load datasets
Mozambique_data <-read_tsv("test_MER_Structured_Datasets_PSNU_IM_FY20-23_20221216_Mozambique.txt") %>% 
  # mutate(pre_rgnlztn_hq_mech_code = as.character(pre_rgnlztn_hq_mech_code)) %>% 
  mutate(mech_code = as.character(mech_code)) 

Eswatini_data <-read_tsv("test_MER_Structured_Datasets_Site_IM_FY20-23_20221216_Eswatini.txt")%>% 
  #mutate(pre_rgnlztn_hq_mech_code = as.character(pre_rgnlztn_hq_mech_code))%>% 
  mutate(mech_code = as.character(mech_code)) 



#View your datasets
glimpse(Eswatini_data)
glimpse(Mozambique_data)


#Combine the 2 datasets
Eswa_Moz <-bind_rows(Eswatini_data, Mozambique_data)


#subset Indicators of interest from combined dataset
txcurr <- Eswa_Moz %>% 
  filter(indicator == "TX_CURR") %>% 
  filter(standardizeddisaggregate %in% c("Age/Sex/HIVStatus","Age Aggregated/Sex/HIVStatus",
                                         "KeyPop/HIVStatus", "Total Numerator"))

txpvls <- Eswa_Moz %>% 
  filter(indicator == "TX_PVLS")


pmtctart <- Eswa_Moz %>%
  filter(indicator == "PMTCT_ART") %>% 
  filter(otherdisaggregate %in% "Life-long ART, Already")



netnew <-Eswa_Moz %>% 
  filter(indicator== "TX_NET_NEW")


lab <- Eswa_Moz %>% 
  filter(indicator == "LAB_PTCQI")

#Quick QC on subsets  
unique(txcurr$standardizeddisaggregate)
unique(txcurr$sex)
unique(txpvls$standardizeddisaggregate)
unique(txpvls$otherdisaggregate)
unique(pmtctart$standardizeddisaggregate)
unique(pmtctart$otherdisaggregate)
unique(pmtctart$fiscal_year)
unique(netnew$standardizeddisaggregate)


# Combine all subset datasets
Final_data <-bind_rows(txcurr, txpvls, pmtctart, netnew, lab)


# Export combined datasets as txt
write_tsv(Final_data, "EswaMoszambique_FY22Q4_clean.txt", na = " ")


# Export combined datasets as csv
write.csv(Final_data, "EswaMoszambique_FY22Q4clean.csv")
