getwd()
setwd("~/git/LSHTM_Y1_PNCA/mcsm_complex1/Results")
getwd()

#=======================================================
#TASK:read cleaned data and perform rescaling
  # of DUET stability scores
  # of Pred affinity
#compare scaling methods with plots
#output normalised file
#=======================================================

####################
#### read file #####: this will be the output of my R script that cleans the data columns
####################
source("../Scripts/step3c_data_cleaning.R")
##This will outut two dataframes:
##data: unclean data: 335, 10
##df : cleaned df 335, 13
## you can remove data if you want as you will not need it
rm(data)

colnames(df)

#===================
#3a: PredAffLog
#===================
n = which(colnames(df) == "PredAffLog"); n
group = which(colnames(df) == "Lig_outcome"); group 

#===================================================
# order according to PredAffLog values
#===================================================
# This is because this makes it easier to see the results of rescaling for debugging
head(df$PredAffLog)

#ORDER BY PredAff scrores: negative  values at the top and positive at the bottoom
df = df[order(df$PredAffLog),] 
head(df$PredAffLog)

#sanity checks
head(df[,n]) #all negatives
tail(df[,n]) #all positives

#sanity checks
mean(df[,n])
#-0.9526746

tapply(df[,n], df[,group], mean)
#Destabilizing   Stabilizing 
#-1.2112100      0.3926667 
#===========================
#Same as above: in 2 steps
#===========================

#find range of your data
my_min = min(df[,n]); my_min #-3.948
my_max = max(df[,n]); my_max #2.23

#===============================================
# WITHIN GROUP rescaling 2: method "ratio"
# create column to store the rescaled values
# Rescaling separately (Less dangerous) 
#       =====> chosen one:as Nick prefers
#===============================================
df$ratioPredAff = ifelse(df[,n] < 0
                      , df[,n]/abs(my_min)
                      , df[,n]/my_max
                      )#335 14
#sanity checks
head(df$ratioPredAff)
tail(df$ratioPredAff)

min(df$ratioPredAff); max(df$ratioPredAff)

tapply(df$ratioPredAff, df$Lig_outcome, min)
#Destabilizing   Stabilizing 
#-1.000000000   0.005381166 

tapply(df$ratioPredAff, df$Lig_outcome, max)
#Destabilizing   Stabilizing 
#-0.001266464   1.000000000

#should be the same as below (281 and 54)
sum(df$ratioPredAff < 0); sum(df$ratioPredAff > 0)

table(df$Lig_outcome)
#Destabilizing   Stabilizing 
#281              54

#===============================================
# Hist and density plots to compare the rescaling 
# methods: Base R
#===============================================
#uncomment as necessary
my_title = "Ligand_stability"
#my_title = colnames(df[n])

# Set the margin on all sides
par(oma = c(3,2,3,0)
    , mar = c(1,3,5,2)
    , mfrow = c(2,2))

hist(df[,n]
     , xlab = ""
     , main = "Raw values"
)

hist(df$ratioPredAff
     , xlab = ""
     , main = "ratio rescaling"
)

# Plot density plots underneath
plot(density( df[,n] )
     , main = "Raw values"
)

plot(density( df$ratioPredAff )
     , main = "ratio rescaling"
)

# titles
mtext(text = "Frequency"
       , side = 2
       , line = 0
       , outer = TRUE)

mtext(text = my_title
      , side = 3
      , line = 0
      , outer = TRUE)


#clear variables 
rm(my_min, my_max, my_title, n, group)

#===================
# 3b: DUET stability
#===================
dim(df) #335, 14

n = which(colnames(df) == "DUETStability_Kcalpermol"); n # 10
group = which(colnames(df) == "DUET_outcome"); group #12

#===================================================
# order according to DUET scores
#===================================================
# This is because this makes it easier to see the results of rescaling for debugging
head(df$DUETStability_Kcalpermol)

#ORDER BY DUET scores: negative values at the top and positive at the bottom
df = df[order(df$DUETStability_Kcalpermol),] 

#sanity checks
head(df[,n]) #negatives
tail(df[,n]) #positives

#sanity checks
mean(df[,n])
#[1] -1.173316

tapply(df[,n], df[,group], mean)
#Destabilizing   Stabilizing 
#-1.4297257     0.3978723

#===============================================
# WITHIN GROUP rescaling 2: method "ratio"
# create column to store the rescaled values
# Rescaling separately (Less dangerous) 
#       =====> chosen one:as Nick prefers
#===============================================
#find range of your data
my_min = min(df[,n]); my_min #-3.87
my_max = max(df[,n]); my_max #1.689

df$ratioDUET = ifelse(df[,n] < 0
                      , df[,n]/abs(my_min)
                      , df[,n]/my_max
                    ) #335, 15
#sanity check
head(df$ratioDUET)
tail(df$ratioDUET)

min(df$ratioDUET); max(df$ratioDUET)

#sanity checks
tapply(df$ratioDUET, df$DUET_outcome, min)
#Destabilizing   Stabilizing 
#-1.00000000    0.01065719

tapply(df$ratioDUET, df$DUET_outcome, max)
#Destabilizing   Stabilizing 
#-0.003875969   1.000000000 

#should be the same as below (267 and 42)
sum(df$ratioDUET < 0); sum(df$ratioDUET > 0)

table(df$DUET_outcome)
#Destabilizing   Stabilizing 
#288             47

#===============================================
# Hist and density plots to compare the rescaling 
# methods: Base R
#===============================================
#uncomment as necessary

my_title = "DUET_stability"
#my_title = colnames(df[n])

# Set the margin on all sides
par(oma = c(3,2,3,0)
    , mar = c(1,3,5,2)
    , mfrow = c(2,2))

hist(df[,n]
     , xlab = ""
     , main = "Raw values"
)

hist(df$ratioDUET
     , xlab = ""
     , main = "ratio rescaling"
)

# Plot density plots underneath
plot(density( df[,n] )
     , main = "Raw values"
)

plot(density( df$ratioDUET )
     , main = "ratio rescaling"
)

# graph titles
mtext(text = "Frequency"
      , side = 2
      , line = 0
      , outer = TRUE)

mtext(text = my_title
      , side = 3
      , line = 0
      , outer = TRUE)

#===================
# write output as csv file
#===================
write.csv(df, "../Data/mcsm_complex1_normalised.csv", row.names = FALSE) #335, 15
