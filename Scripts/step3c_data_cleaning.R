getwd()
setwd("~/git/LSHTM_Y1_PNCA/mcsm_complex1/Results")
getwd()

#=======================================================
#TASK: To tidy the columns so you can generate figures
#=======================================================
####################
#### read file #####: this will be the output from python script (csv file)
####################
data = read.csv("336_complex1_formatted_results.csv"
              , header = T
              , stringsAsFactors = FALSE)
dim(data)
#335, 10
str(data)

###########################
##### Data processing #####
###########################

# populate mutation information columns as currently it is empty
head(data$Mutationinformation)
tail(data$Mutationinformation)

# should not be blank: create muation information
data$Mutationinformation = paste0(data$Wild.type, data$Position, data$Mutant.type)

head(data$Mutationinformation)
tail(data$Mutationinformation)
#write.csv(data, 'test.csv')
##########################################
# Remove duplicate SNPs as a sanity check
##########################################
#very important
table(duplicated(data$Mutationinformation))
#FALSE   
#335

#extract duplicated entries
dups = data[duplicated(data$Mutationinformation),] #0

#No of dups should match with the no. of TRUE in the above table 
#u_dups = unique(dups$Mutationinformation) #10
sum( table(dups$Mutationinformation) ) #13

rm(dups)

#***************************************************************
#select non-duplicated SNPs and create a new df
df = data[!duplicated(data$Mutationinformation),] #309, 10
#***************************************************************
#sanity check
u = unique(df$Mutationinformation)
u2 = unique(data$Mutationinformation)
table(u%in%u2)
#TRUE 
#309 
#should all be 1, hence 309 1's
sum(table(df$Mutationinformation) == 1)

#sort df by Position
#MANUAL CHECKPOINT:  
#foo <- df[order(df$Position),]
#df <- df[order(df$Position),]

rm(u, u2, dups)

####################
#### give meaningful colnames to reflect units to enable correct data type
####################

#=======
#STEP 1
#========
#make a copy of the PredictedAffinityColumn and call it Lig_outcome
df$Lig_outcome = df$PredictedAffinityChange #335, 11

#make Predicted...column numeric and outcome column categorical
head(df$PredictedAffinityChange)
df$PredictedAffinityChange = gsub("log.*"
                                  , ""
                                  , df$PredictedAffinityChange)

#sanity checks
head(df$PredictedAffinityChange)

#should be numeric, check and if not make it numeric
is.numeric( df$PredictedAffinityChange )
#change to numeric
df$PredictedAffinityChange = as.numeric(df$PredictedAffinityChange)
#should be TRUE
is.numeric( df$PredictedAffinityChange )

#change the column name to indicate units
n = which(colnames(df) == "PredictedAffinityChange"); n
colnames(df)[n] = "PredAffLog"
colnames(df)[n]

#========
#STEP 2
#========
#make Lig_outcome column categorical showing effect of mutation
head(df$Lig_outcome)
df$Lig_outcome = gsub("^.*-"
                  , "",
                  df$Lig_outcome)
#sanity checks
head(df$Lig_outcome)
#should be factor, check and if not change it to factor
is.factor(df$Lig_outcome) 
#change to factor
df$Lig_outcome = as.factor(df$Lig_outcome)
#should be TRUE
is.factor(df$Lig_outcome) 

#========
#STEP 3
#========
#gsub
head(df$Distancetoligand)
df$Distancetoligand = gsub("&Aring;"
                           , ""
                           , df$Distancetoligand)
#sanity checks
head(df$Distancetoligand)
#should be numeric, check if not change it to numeric
is.numeric(df$Distancetoligand)
#change to numeric
df$Distancetoligand = as.numeric(df$Distancetoligand)
#should be TRUE
is.numeric(df$Distancetoligand)

#change the column name to indicate units
n = which(colnames(df) == "Distancetoligand")
colnames(df)[n] <- "Dis_lig_Ang"
colnames(df)[n]

#========
#STEP 4
#========
#gsub
head(df$DUETstabilitychange)
df$DUETstabilitychange = gsub("Kcal/mol"
                              , ""
                              , df$DUETstabilitychange)
#sanity checks
head(df$DUETstabilitychange)
#should be numeric, check if not change it to numeric
is.numeric(df$DUETstabilitychange)
#change to numeric 
df$DUETstabilitychange = as.numeric(df$DUETstabilitychange)
#should be TRUE
is.numeric(df$DUETstabilitychange)

#change the column name to indicate units
n = which(colnames(df) == "DUETstabilitychange"); n
colnames(df)[n] = "DUETStability_Kcalpermol"
colnames(df)[n]

#========
#STEP 5
#========
#create yet another extra column: classification of DUET stability only
df$DUET_outcome = ifelse(df$DUETStability_Kcalpermol >=0
                         , "Stabilizing"
                         , "Destabilizing")  #335, 12

table(df$Lig_outcome)
#Destabilizing   Stabilizing 
#281             54 

table(df$DUET_outcome)
#Destabilizing   Stabilizing 
#288             47 
#==============================
#FIXME
#Insert a venn diagram

#================================


#========
#STEP 6
#========
# assign wild and mutant colnames correctly

wt = which(colnames(df) == "Wild.type"); wt
colnames(df)[wt] <- "Wild_type"
colnames(df[wt])

mut = which(colnames(df) == "Mutant.type"); mut
colnames(df)[mut] <- "Mutant_type"
colnames(df[mut])

#========
#STEP 7
#========
#create an extra column: maybe useful for some plots
df$WildPos = paste0(df$Wild_type, df$Position) #335, 13

#clear variables
rm(n, wt, mut)

################ end of data cleaning
