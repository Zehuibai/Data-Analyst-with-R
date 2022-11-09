#####################################################
### VENUS toric CSR additional plos
### 06/07/2021
### Zehui Bai
#####################################################

### Change the path corresponding 
path <- dirname(rstudioapi::getSourceEditorContext()$path)
library(ggplot2)



#####################################################
### Figure 2
### Baseline Subjective Refraction sphere
### Copy data from clipboard in excel
#####################################################

# copdat <- read.delim("clipboard")
# 
# Spheres <- t(copdat)
# names(Spheres) <- NULL
# Spheres2 <- Spheres[-1,]
# colnames(Spheres2) <- Spheres[1,]
# Spheres2 <- as.data.frame(Spheres2)
# Spheres2$treatment <- rep(c("LARA","TECN"),time=12)
# 
# level <- c("mITT", "PP", "SES", "CALLISTO eye","No CALLISTO eye", "CALLISTO eye V 3.6",
#            "CALLISTO eye V 3.5", "IOL Master 700", "IOL Master and TECNIS", "ZCALC", "ZCALC V1.5.1", "ZCALC V2.1.0")
# Spheres2$Subgroup <- factor(Spheres2$Subgroup, levels=level)
# Spheres2$Treatment <- factor(Spheres2$treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# 
# 
# ### converting multiple columns from character to numeric format
# str(Spheres2)
# library(dplyr)
# # solution
# Spheres3 <- Spheres2[,-11] %>% mutate_if(is.character,as.numeric)
# Spheres3$`P-Value` <- Spheres2$`P-Value`
# 
# str(Spheres3)
### saveRDS(Spheres3, file = file.path(path,"Sphere_Baseline.rds"))

## Subjective refraction Sphere at Baseline 
Spheres3 <- readRDS(file.path(path,"01_Datasets","Sphere_Baseline.rds"))
Spheres3$label_color <- rep("",nrow(Spheres3))
Spheres3$`P-Value` <- ifelse(Spheres3$`P-Value`== "",Spheres3$`P-Value`, paste("p =", Spheres3$`P-Value`)) 
Spheres3$label_color[5] <- "Red"

## Keep only main subgroups
Spheres3 <- Spheres3[1:6,]
## Remove the space
searchString <- ' '
replacementString <- '' 
Spheres3$`P-Value` <- sub(searchString,replacementString,Spheres3$`P-Value`)
Spheres3$`P-Value` <- sub(searchString,replacementString,Spheres3$`P-Value`)



ggplot(Spheres3,aes(x=Subgroup,fill=Treatment))+
  geom_boxplot(aes(lower=`  Mean`-`  SD`,
                   upper=`  Mean`+`  SD`,
                   middle=`  Mean`,
                   ymin=`  Min`,
                   ymax=`  Max`),
               width=0.7,
               stat="identity")+
  geom_text(aes(label=paste(`P-Value`),  colour=label_color, x=Subgroup, y=5.5),hjust=0.4, size=4.5, show.legend = F)+
  geom_text(aes(label=paste(`  Mean`,"(",`  SD`,")"), x=Subgroup, y=`  Mean`), color="white",
            position = position_dodge(0.7), size=4.5, show.legend = F)+
  scale_colour_manual(values=c("#000000", "#FF5733"))+
  scale_fill_brewer(palette="Paired")+
  coord_flip() +
  theme_bw() +
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 12),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12)) +
  labs(x = "Subgroups",
       y = "Sphere [D]",
       title = "",
       fill = "")




#####################################################
### Figure 3
### Baseline Subjective Refraction Cylinder
### Copy data from clipboard in excel
#####################################################

# copdat <- read.delim("clipboard")
# 
# Cylinder <- t(copdat)
# names(Cylinder) <- NULL
# Cylinder2 <- Cylinder[-1,]
# colnames(Cylinder2) <- Cylinder[1,]
# Cylinder2 <- as.data.frame(Cylinder2)
# Cylinder2$treatment <- rep(c("LARA","TECN"),time=12)
# 
# level <- c("mITT", "PP", "SES", "CALLISTO eye","No CALLISTO eye", "CALLISTO eye V 3.6",
#            "CALLISTO eye V 3.5", "IOL Master 700", "IOL Master and TECNIS", "ZCALC", "ZCALC V1.5.1", "ZCALC V2.1.0")
# Cylinder2$Subgroup <- factor(Cylinder2$Subgroup, levels=level)
# Cylinder2$Treatment <- factor(Cylinder2$treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# 
# 
# ### converting multiple columns from character to numeric format
# str(Cylinder2)
# library(dplyr)
# # solution
# Cylinder3 <- Cylinder2[,-11] %>% mutate_if(is.character,as.numeric)
# Cylinder3$`P-Value` <- Cylinder2$`P-Value`
# 
# str(Cylinder3)
### saveRDS(Cylinder3, file = file.path(path,"Cylinder_Baseline.rds"))

Cylinder3 <- readRDS(file.path(path,"01_Datasets","Cylinder_Baseline.rds"))
Cylinder3$label_color <- rep("",nrow(Cylinder3))
Cylinder3$label_color[c(1,3,7,17)] <- rep(c("Red"),4)
Cylinder3$`P-Value` <- ifelse(Cylinder3$`P-Value`== "",Cylinder3$`P-Value`, paste("p =", Cylinder3$`P-Value`)) 
## Keep only main subgroups
Cylinder3 <- Cylinder3[1:6,]
## Remove the space
searchString <- ' '
replacementString <- '' 
Cylinder3$`P-Value` <- sub(searchString,replacementString,Cylinder3$`P-Value`)
Cylinder3$`P-Value` <- sub(searchString,replacementString,Cylinder3$`P-Value`)

### Subjective refraction Cylinder at Baseline
ggplot(Cylinder3,aes(x=Subgroup,fill=Treatment))+
  geom_boxplot(aes(lower=-`  Mean`-`  SD`,
                   upper=-`  Mean`+`  SD`,
                   middle=-(`  Mean`),
                   ymin=-(`  Min`),
                   ymax=-(`  Max`)),
               width=0.7,
               stat="identity")+
  geom_text(aes(label=paste(`P-Value`),  colour=label_color, x=Subgroup, y=0.5),hjust=0.4, size=4.5, show.legend = F)+
  geom_text(aes(label=paste(-`  Mean`,"(",`  SD`,")"), x=Subgroup, y=-`  Mean`), color="white",
            position = position_dodge(0.7), size=4.5, show.legend = F)+
  scale_colour_manual(values=c("#000000", "#FF5733"))+
  scale_fill_brewer(palette="Paired")+
  coord_flip() +
  theme_bw() +
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 12),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12)) +
  labs(x = "Subgroups",
       y = "Cylinder [D]",
       title = "",
       fill = "")
 

 


########################################################################################
### Figure 4
### Superiority analysis in mean absolute rotation between Visit H0 (sitting) and H1
########################################################################################

PrimEnd <- data.frame('Primary Endpoint'=c("Primary Analysis", 
                                           "Sensitivity Analysis\nwith log-transformation",
                                           "Sensitivity Analysis\nwith t-test",
                                           "Primary Analysis\nafter imputation"),
                      mean=c(-0.2945, -0.08334, -0.2926, -0.2395),
                      LL=c(-0.9612, -0.2861, -0.9344, -0.7521),
                      UL=c(0.3722, 0.1194, 0.3491, 0.2730),
                      pvalue=c("p=0.313", "p=0.347", "p=0.304","p=0.359"))
level <- PrimEnd$Primary.Endpoint

PrimEnd$Primary.Endpoint <- factor(PrimEnd$Primary.Endpoint, levels=level)
 
ggplot(PrimEnd, aes(x=Primary.Endpoint, y=mean)) + 
  geom_line() +
  geom_point()+
  geom_text(aes(label=pvalue),hjust=-0.2, vjust=0, size=4.5) +
  geom_hline(aes(yintercept=0, color="black", linetype="dot")) + 
  geom_errorbar(aes(ymin=LL, ymax=UL), width = 0.2, size = 0.8)+
  theme_bw() +
  theme(legend.position = "none",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 12.5, face = "bold"),
        axis.text.y  = element_text(size = 12)) +
  labs(x = "",
       y = "Difference between the IOLs",
       title = "")


############################################################## 
### Figure 5
### Mean absolute rotation
############################################################## 

# copdat <- read.delim("clipboard")
# MeanRotation <- copdat 
# MeanRotation$Subgroup <- factor(MeanRotation$Subgroup,
#                                 levels = c("mITT", 
#                                            "Axial length: Short (< 22.5 mm)",
#                                            "Axial length: Normal (22.5 to 24.5 mm)",
#                                            "Axial length: Long (>24.5 mm)"))
# MeanRotation$Visit <- factor(MeanRotation$Visit,levels = c("H1","D1","W1","M1","M4-6"))
# MeanRotation$Treatment  <- factor(MeanRotation$Treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# str(MeanRotation)


### saveRDS(MeanRotation, file = file.path(path, "MeanRotation.rds" ))
MeanRotation <- readRDS(file = file.path(path,"01_Datasets","MeanRotation.rds" ))
MeanRotation$P <- tolower(MeanRotation$P)

ggplot(MeanRotation, aes(x=Visit,fill=Treatment))+
  geom_boxplot(aes(lower=mean-SD,
                   upper=mean+SD,
                   middle=mean,
                   ymin=min,
                   ymax=max),
               stat="identity")+
  geom_text(aes(label=mean, x=Visit, y=mean),  color="white",
            position = position_dodge(0.85), size=4.5)+
  geom_text(aes(label=P,colour=label_color, x=Visit, y=25),hjust=0.4, size=4.5,show.legend = FALSE)+
  scale_colour_manual(values=c("#000000", "#FF5733"))+
  scale_fill_brewer(palette="Paired")+
  facet_wrap(.~ Subgroup, nrow = 4)+
  theme_bw() +
  theme(legend.position = "bottom",
        strip.text.x = element_text(size = 12),
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 12),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12)) +
  labs(x = "",
       y = "Mean absolute rotation",
       title = "",
       fill="")


########################################################################################
### Figure 6
### Non-inferiority analysis in rotational stability between Visit H0 (sitting) and H1
########################################################################################
SecdEnd <- data.frame('Secondary Endpoint'=c("Non-Inferiority Analysis", 
                                           "Sensitivity Analysis\nwith Farrington and Manning test",
                                           "Non-Inferiority Analysis\nafter imputation"),
                      mean=c(-2.24, -2.21, -1.57)/100,
                      LL=c(-9.91, -10.28, -8.12)/100,
                      UL=c(5.43, 5.85, 4.98)/100,
                      pvalue=c("p=0.472", "p=0.469", "p=0.390"))
level <- SecdEnd$Secondary.Endpoint

SecdEnd$Secondary.Endpoint <- factor(SecdEnd$Secondary.Endpoint, levels=level)
 
ggplot(SecdEnd, aes(x=Secondary.Endpoint, y=mean)) + 
  geom_line() +
  geom_point()+
  geom_text(aes(label=pvalue),hjust=-0.2, vjust=0, size=4.5) +
  geom_hline(aes(yintercept=0, color="black", linetype="dot")) + 
  geom_errorbar(aes(ymin=LL, ymax=UL), width = 0.2, size = 0.7)+
  scale_y_continuous(labels = scales::percent) +
  theme_bw() +
  theme(legend.position = "none",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 12.5, face = "bold"),
        axis.text.y  = element_text(size = 12)) +
  labs(x = "",
       y = "Risk difference",
       title = "")
 



############################################################## 
### Figure 7
### Rotational stability within 5° from Visit H0 (sitting)
############################################################## 

### Copy data from clipboard in excel
# copdat <- read.delim("clipboard")
# Rotation_5 <- copdat 
# Rotation_5$Visit <- factor(Rotation_5$Visit,levels = c("H1","D1","W1","M1","M4-6"))
# Rotation_5$Treatment  <- factor(Rotation_5$Treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# Rotation_5$Percentage <- Rotation_5$Percentage/100 
# str(Rotation_5)
#  

 
### saveRDS(Rotation_5, file = file.path(path, "Rotation_5.rds" ))
Rotation_5 <- readRDS(file = file.path(path,"01_Datasets", "Rotation_5.rds" ))
Rotation_5$P <- tolower(Rotation_5$P)

ggplot(data = Rotation_5, aes(x = Visit, y= Percentage, fill=Treatment)) +
  geom_bar(stat="identity", width =0.6,
           position=position_dodge()) +
  geom_text(aes(label=paste("n =",N)), vjust=1.6, color="white",
            position = position_dodge(0.5), size=4.5)+
  geom_text(aes(label=P, x=Visit, y=1.05),hjust=0.4, size=4.5)+
  geom_text(aes(label = scales::percent(Percentage,accuracy=0.1), y=Percentage), position = position_dodge(0.5), vjust = -.5, size=4.5)+
  scale_fill_brewer(palette="Paired")+
  scale_y_continuous(labels = scales::percent, breaks=seq(0, 1, 0.1)) +
  theme_bw() +
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 12),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12)) +
  labs(x = "",
       y = "Responder rate",
       title = "",
       fill="")

 


 




############################################################## 
### Figure 8
### Absolute mean IOL axis misalignment at M4-6
############################################################## 

# 
# copdat <- read.delim("clipboard")
# Absmisalignment <- copdat
# Absmisalignment$Subgroup <- factor(Absmisalignment$Subgroup,
#                                    levels = c("mITT", "PP", "CALLISTO Eye",
#                                               "No CALLISTO Eye",
#                                               "CALLISTO V3.6", "CALLISTO V3.5"))
# Absmisalignment$Treatment  <- factor(Absmisalignment$Treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# str(Absmisalignment)

### saveRDS(Absmisalignment, file = file.path(path,"01_Datasets", "Absmisvalues.rds" ))
Absmisvalues <- readRDS(file = file.path(path,"01_Datasets","Absmisvalues.rds" ))

ggplot(Absmisvalues, aes(x=Subgroup,fill=Treatment))+
  geom_boxplot(aes(lower=mean-SD,
                   upper=mean+SD,
                   middle=mean,
                   ymin=min,
                   ymax=max),
               stat="identity")+
  geom_text(aes(label=P,colour=label_color, x=Subgroup, y=20),hjust=0.4, size=4.5,show.legend = FALSE)+
  geom_text(aes(label=paste(" ", mean,"\n","(",SD,")"), x=Subgroup, y=mean), color="white",
            position = position_dodge(0.9), size=4.5, show.legend = F)+
  scale_colour_manual(values=c("#000000", "#FF5733"))+
  scale_fill_brewer(palette="Paired")+
  theme_bw() +
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 12),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12)) +
  labs(x = "",
       y = "Absolute mean IOL axis misalignment",
       title = "",
       fill="")















############################################################## 
### Figure 9
### Categorization of IOL axis misalignment
### Categories by "< 3°","< 5°", "< 7°", "< 10°", "< 20°", "< 30°"
############################################################## 


# copdat <- read.delim("clipboard")
# AbsMisbyCate <- copdat
# AbsMisbyCate$Misalignment <- factor(AbsMisbyCate$Misalignment,levels = c("< 3°","< 5°", "< 7°", "< 10°", "< 20°", "< 30°"))
# AbsMisbyCate$Treatment  <- factor(AbsMisbyCate$Treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# AbsMisbyCate$percentage <- AbsMisbyCate$percentage/100
# str(AbsMisbyCate)
# 
# 
# saveRDS(AbsMisbyCate, file = file.path(path,"01_Datasets","AbsMisbyCate.rds" ))
AbsMisbyCate <- readRDS(file = file.path(path, "01_Datasets","AbsMisbyCate.rds" ))
AbsMisbyCate$P <- tolower(AbsMisbyCate$P)
AbsMisbyCate$P[11] <- "p=N/F"


### Categorization of IOL axis misalignment <= 3
ggplot(data = AbsMisbyCate, aes(x = Misalignment, y= percentage, fill=Treatment)) +
  geom_bar(stat="identity", width =0.7,
           position=position_dodge()) +
  geom_text(aes(label=paste("n =",n)), vjust=1.6, color="white",
            position = position_dodge(0.7), size=4.5)+
  geom_text(aes(label=P, x=Misalignment, y=1.1),hjust=0.5, size=4.5)+
  geom_text(aes(label = scales::percent(percentage, accuracy = 0.1), y=percentage), position = position_dodge(0.7), vjust = -.5, size=4.5)+
  scale_fill_brewer(palette="Paired")+
  scale_y_continuous(labels = scales::percent, breaks=seq(0, 1, 0.1)) +
  theme_bw() +
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 12),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12)) +
  labs(x = "",
       y = "Responder rate",
       title = "",
       fill="")



############################################################## 
### Figure 10
### Categorization of IOL axis misalignment
### Categories by 10°
############################################################## 


# copdat <- read.delim("clipboard")
# Absmisalignment10 <- copdat
# Absmisalignment10$Subgroup <- factor(Absmisalignment10$Subgroup,
#                                      levels = c("mITT", "PP", "CALLISTO Eye",
#                                                 "No CALLISTO Eye",
#                                                 "CALLISTO V3.6", "CALLISTO V3.5"))
# Absmisalignment10$Treatment  <- factor(Absmisalignment10$Treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# Absmisalignment10$percentage <- Absmisalignment10$percentage/100
# str(Absmisalignment10)


### saveRDS(Absmisalignment10, file = file.path(path,"01_Datasets","Absmisalignment10.rds" ))
Absmisalignment10 <- readRDS(file = file.path(path, "01_Datasets","Absmisalignment10.rds" ))

### Categorization of IOL axis misalignment <= 3
ggplot(data = Absmisalignment10, aes(x = Subgroup, y= percentage, fill=Treatment)) +
  geom_bar(stat="identity", width =0.7,
           position=position_dodge()) +
  geom_text(aes(label=paste("n =",n)), vjust=1.6, color="white",
            position = position_dodge(0.7), size=4.5)+
  geom_text(aes(label=P, x=Subgroup, y=1.1),hjust=0.5, size=4.5)+
  geom_text(aes(label = scales::percent(percentage,accuracy = 0.1), y=percentage), position = position_dodge(0.7), vjust = -.5, size=4.5)+
  scale_fill_brewer(palette="Paired")+
  scale_y_continuous(labels = scales::percent, breaks=seq(0, 1, 0.1)) +
  theme_bw() +
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 12),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12)) +
  labs(x = "",
       y = "Responder rate",
       title = "",
       fill="")



############################################################## 
### Figure 11
### UDVA Snell
### Frequency of different ranges of UDVA at preoperative and M4-6 visit (mITT)                                    
############################################################## 

# 
# copdat <- read.delim("clipboard")
# UDVA_Snell <- copdat
# UDVA_Snell$Visit <- factor(UDVA_Snell$Visit, labels = c("Preoperative Visit","4-6-Month Postoperative Visit"))
# UDVA_Snell$SnellCat <- factor(UDVA_Snell$SnellCat,levels = c("20/12.5 or better","20/16 or better",
#                                                              "20/20 or better", "20/25 or better",
#                                                              "20/32 or better", "20/40 or better","worse than 20/40"))
# UDVA_Snell$Treatment  <- factor(UDVA_Snell$Treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# UDVA_Snell$percentage <- UDVA_Snell$percentage/100
# str(UDVA_Snell)
# 
# 
# saveRDS(UDVA_Snell, file = file.path(path,"01_Datasets","UDVA_Snell.rds" ))
UDVA_Snell <- readRDS(file = file.path(path, "01_Datasets","UDVA_Snell.rds" ))

ggplot(data = UDVA_Snell, aes(x = SnellCat, y= percentage, fill=Treatment)) +
  geom_bar(stat="identity", width =0.7,
           position=position_dodge()) +
  geom_text(aes(label = scales::percent(percentage,accuracy=0.1), y=percentage-0.02), 
            position = position_dodge(0.7), vjust = -.5, size=4.5)+
  scale_fill_brewer(palette="Paired")+
  scale_y_continuous(labels = scales::percent, breaks=seq(0, 1, 0.1)) +
  theme_bw() +
  facet_grid(Visit~.)+
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 12),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12),
        strip.text.y = element_text(size = 12))+
  labs(x = "",
       y = "Percentage [%]",
       title = "",
       fill="")


 


############################################################## 
### Figure 12
### UDVA LogMAR
### Frequency of different ranges of UDVA by visit (mITT)                                    
############################################################## 



# copdat <- read.delim("clipboard")
# UDVA_LogMAR <- copdat
# UDVA_LogMAR$Visit <- factor(UDVA_LogMAR$Visit, labels = c("Preop","D1","W1","M1","M4-6"))
# UDVA_LogMAR$LogMARCat <- factor(UDVA_LogMAR$LogMARCat,levels = c("VA < 0.0 logMAR","0.0 <= VA < 0.1 logMAR",
#                                                                  "0.1 <= VA < 0.3 logMAR","VA >= 0.3 logMAR"))
# UDVA_LogMAR$Treatment  <- factor(UDVA_LogMAR$Treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# UDVA_LogMAR$percentage <- -UDVA_LogMAR$percentage/100
# str(UDVA_LogMAR)
# 
# 
# saveRDS(UDVA_LogMAR, file = file.path(path,"01_Datasets","UDVA_LogMAR.rds" ))
UDVA_LogMAR <- readRDS(file = file.path(path, "01_Datasets","UDVA_LogMAR.rds" ))

ggplot(data = UDVA_LogMAR, aes(x = Visit, y= percentage, fill=LogMARCat)) +
  geom_bar(stat="identity", width =0.8,
           position=position_dodge()) +
  geom_text(aes(label = scales::percent(percentage,accuracy=0.1), y=percentage+0.001), 
            position = position_dodge(0.8), vjust = -.45, size=4.1)+
  scale_fill_brewer(palette="Dark2")+
  scale_y_continuous(labels = scales::percent, breaks=seq(0, 1, 0.1)) +
  theme_bw() +
  facet_grid(Treatment~.)+
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 12),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12),
        strip.text.y = element_text(size = 12)) +
  labs(x = "",
       y = "Percentage [%]",
       title = "",
       fill = "")


############################################################## 
### Figure 13
### UDVA-CDVA 
### Categorization of differences in monocular preoperative CDVA 4-6-month postoperative UDVA (mITT)                             
############################################################## 

# copdat <- read.delim("clipboard")
# UDVA_CDVA <- copdat
# UDVA_CDVA$Cat <- factor(UDVA_CDVA$Cat,levels = c("3 or more worse", "2 worse", "1 worse", "Same", "1 or more better"))
# UDVA_CDVA$Treatment  <- factor(UDVA_CDVA$Treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# UDVA_CDVA$percentage <- UDVA_CDVA$percentage/100
# str(UDVA_CDVA)
# 
# saveRDS(UDVA_CDVA, file = file.path(path,"01_Datasets","UDVA_CDVA.rds" ))
UDVA_CDVA <- readRDS(file = file.path(path, "01_Datasets","UDVA_CDVA.rds" ))

ggplot(data = UDVA_CDVA, aes(x = Cat, y= percentage, fill=Treatment)) +
  geom_bar(stat="identity", width =0.7,
           position=position_dodge()) +
  geom_text(aes(label = scales::percent(percentage,accuracy=0.1), y=percentage), position = position_dodge(0.7), vjust = -.5, size=4.5)+
  scale_fill_brewer(palette="Paired")+
  scale_y_continuous(labels = scales::percent, breaks=seq(0, 1, 0.1)) +
  theme_bw() +
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 13),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12)) +
  labs(x = "",
       y = "Responder rate",
       title = "",
       fill = "")





############################################################## 
### Figure 14
### UIVA LogMAR
### Frequency of different ranges of UIVA by visit (mITT)                                    
############################################################## 



# copdat <- read.delim("clipboard")
# UIVA_LogMAR <- copdat
# UIVA_LogMAR$Visit <- factor(UIVA_LogMAR$Visit, labels = c("M1","M4-6"))
# UIVA_LogMAR$LogMARCat <- factor(UIVA_LogMAR$LogMARCat,levels = c("VA < 0.0 logMAR","0.0 <= VA < 0.1 logMAR",
#                                                                  "0.1 <= VA < 0.3 logMAR","VA >= 0.3 logMAR"))
# UIVA_LogMAR$Treatment  <- factor(UIVA_LogMAR$Treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# UIVA_LogMAR$percentage <- -UIVA_LogMAR$percentage/100
# str(UIVA_LogMAR)
# 
# 
# saveRDS(UIVA_LogMAR, file = file.path(path,"01_Datasets","UIVA_LogMAR.rds" ))
UIVA_LogMAR <- readRDS(file = file.path(path, "01_Datasets","UIVA_LogMAR.rds" ))

ggplot(data = UIVA_LogMAR, aes(x = Visit, y= percentage, fill=LogMARCat)) +
  geom_bar(stat="identity", width =0.7,
           position=position_dodge()) +
  geom_text(aes(label = scales::percent(percentage,accuracy=0.1), y=percentage+0.001), 
            position = position_dodge(0.7), vjust = -.4, size=4.5)+
  scale_fill_brewer(palette="Dark2")+
  scale_y_continuous(labels = scales::percent, breaks=seq(0, 1, 0.1)) +
  theme_bw() +
  facet_grid(.~Treatment)+
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 13),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12),
        strip.text.x = element_text(size = 12)) +
  labs(x = "",
       y = "Percentage [%]",
       title = "",
       fill = "")




############################################################## 
### Figure 15
### UNVA LogMAR
### Frequency of different ranges of UNVA by visit (mITT)                                    
############################################################## 



# copdat <- read.delim("clipboard")
# UNVA_LogMAR <- copdat
# UNVA_LogMAR$Visit <- factor(UNVA_LogMAR$Visit, labels = c("M1","M4-6"))
# UNVA_LogMAR$LogMARCat <- factor(UNVA_LogMAR$LogMARCat,levels = c("VA < 0.0 logMAR","0.0 <= VA < 0.1 logMAR",
#                                                                  "0.1 <= VA < 0.3 logMAR","VA >= 0.3 logMAR"))
# UNVA_LogMAR$Treatment  <- factor(UNVA_LogMAR$Treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# UNVA_LogMAR$percentage <- -UNVA_LogMAR$percentage/100
# str(UNVA_LogMAR)
# 
# 
# saveRDS(UNVA_LogMAR, file = file.path(path,"01_Datasets","UNVA_LogMAR.rds" ))
UNVA_LogMAR <- readRDS(file = file.path(path, "01_Datasets","UNVA_LogMAR.rds" ))

ggplot(data = UNVA_LogMAR, aes(x = Visit, y= percentage, fill=LogMARCat)) +
  geom_bar(stat="identity", width =0.7,
           position=position_dodge()) +
  geom_text(aes(label = scales::percent(percentage,accuracy=0.1), y=percentage+0.001), 
            position = position_dodge(0.7), vjust = -.4, size=4.5)+
  scale_fill_brewer(palette="Dark2")+
  scale_y_continuous(labels = scales::percent, breaks=seq(0, 1, 0.1)) +
  theme_bw() +
  facet_grid(.~Treatment)+
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 13),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12),
        strip.text.x = element_text(size = 12)) +
  labs(x = "",
       y = "Percentage [%]",
       title = "",
       fill = "")







############################################################## 
### Figure 16
### CDVA Snell
### Frequency of different ranges of CDVA at preoperative and M4-6 visit (mITT)                                    
############################################################## 


# copdat <- read.delim("clipboard")
# CDVA_Snell <- copdat
# CDVA_Snell$Visit <- factor(CDVA_Snell$Visit, labels = c("Preoperative Visit","4-6-Month Postoperative Visit"))
# CDVA_Snell$SnellCat <- factor(CDVA_Snell$SnellCat,levels = c("20/12.5 or better","20/16 or better",
#                                                              "20/20 or better", "20/25 or better",
#                                                              "20/32 or better", "20/40 or better","worse than 20/40"))
# CDVA_Snell$Treatment  <- factor(CDVA_Snell$Treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# CDVA_Snell$percentage <- CDVA_Snell$percentage/100
# str(CDVA_Snell)
# 
# 
# saveRDS(CDVA_Snell, file = file.path(path,"01_Datasets","CDVA_Snell.rds" ))
CDVA_Snell <- readRDS(file = file.path(path, "01_Datasets","CDVA_Snell.rds" ))

ggplot(data = CDVA_Snell, aes(x = SnellCat, y= percentage, fill=Treatment)) +
  geom_bar(stat="identity", width =0.7,
           position=position_dodge()) +
  geom_text(aes(label = scales::percent(percentage,accuracy=0.1), y=percentage-0.02), 
            position = position_dodge(0.7), vjust = -.5, size=4.5)+
  scale_fill_brewer(palette="Paired")+
  scale_y_continuous(labels = scales::percent, breaks=seq(0, 1, 0.1)) +
  theme_bw() +
  facet_grid(Visit~.)+
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 12),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12),
        strip.text.y = element_text(size = 12))+
  labs(x = "",
       y = "Percentage [%]",
       title = "",
       fill="")





############################################################## 
### Figure 17
### CDVA LogMAR
### Frequency of different ranges of CDVA by visit (mITT)                                    
############################################################## 
# 
# 
# 
# copdat <- read.delim("clipboard")
# CDVA_LogMAR <- copdat
# CDVA_LogMAR$Visit <- factor(CDVA_LogMAR$Visit, labels = c("Preop","W1","M1","M4-6"))
# CDVA_LogMAR$LogMARCat <- factor(CDVA_LogMAR$LogMARCat,levels = c("VA < 0.0 logMAR","0.0 <= VA < 0.1 logMAR",
#                                                                  "0.1 <= VA < 0.3 logMAR","VA >= 0.3 logMAR"))
# CDVA_LogMAR$Treatment  <- factor(CDVA_LogMAR$Treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# CDVA_LogMAR$percentage <- -CDVA_LogMAR$percentage/100
# str(CDVA_LogMAR)
# 
# 
# saveRDS(CDVA_LogMAR, file = file.path(path,"01_Datasets","CDVA_LogMAR.rds" ))
CDVA_LogMAR <- readRDS(file = file.path(path, "01_Datasets","CDVA_LogMAR.rds" ))

ggplot(data = CDVA_LogMAR, aes(x = Visit, y= percentage, fill=LogMARCat)) +
  geom_bar(stat="identity", width =0.8,
           position=position_dodge()) +
  geom_text(aes(label = scales::percent(percentage,accuracy=0.1), y=percentage+0.001), 
            position = position_dodge(0.8), vjust = -.4, size=4.1)+
  scale_fill_brewer(palette="Dark2")+
  scale_y_continuous(labels = scales::percent, breaks=seq(0, 1, 0.1)) +
  theme_bw() +
  facet_grid(Treatment~.)+
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 12),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12),
        strip.text.y = element_text(size = 12)) +
  labs(x = "",
       y = "Percentage [%]",
       title = "",
       fill = "")




############################################################## 
### Figure 18
### UDVA-CDVA 
### Categorization of differences in monocular preoperative CDVA 4-6-month postoperative UDVA (mITT)                             
############################################################## 

# copdat <- read.delim("clipboard")
# CDVA_CDVA <- copdat
# CDVA_CDVA$Cat <- factor(CDVA_CDVA$Cat,levels = c("3 or more worse", "2 worse", "1 worse", "Same", "1 or more better"))
# CDVA_CDVA$Treatment  <- factor(CDVA_CDVA$Treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# CDVA_CDVA$percentage <- CDVA_CDVA$percentage/100
# str(CDVA_CDVA)
# 
# saveRDS(CDVA_CDVA, file = file.path(path,"01_Datasets","CDVA_CDVA.rds" ))
CDVA_CDVA <- readRDS(file = file.path(path, "01_Datasets","CDVA_CDVA.rds" ))

ggplot(data = CDVA_CDVA, aes(x = Cat, y= percentage, fill=Treatment)) +
  geom_bar(stat="identity", width =0.7,
           position=position_dodge()) +
  geom_text(aes(label = scales::percent(percentage,accuracy=0.1), y=percentage), position = position_dodge(0.7), vjust = -.5, size=4.5)+
  scale_fill_brewer(palette="Paired")+
  scale_y_continuous(labels = scales::percent, breaks=seq(0, 1, 0.1)) +
  theme_bw() +
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 13),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12)) +
  labs(x = "",
       y = "Responder rate",
       title = "",
       fill = "")






############################################################## 
### Figure 19
### DCIVA LogMAR
### Frequency of different ranges of DCIVA by visit (mITT)                                    
############################################################## 



# copdat <- read.delim("clipboard")
# DCIVA_LogMAR <- copdat
# DCIVA_LogMAR$Visit <- factor(DCIVA_LogMAR$Visit, labels = c("M1","M4-6"))
# DCIVA_LogMAR$LogMARCat <- factor(DCIVA_LogMAR$LogMARCat,levels = c("VA < 0.0 logMAR","0.0 <= VA < 0.1 logMAR",
#                                                                  "0.1 <= VA < 0.3 logMAR","VA >= 0.3 logMAR"))
# DCIVA_LogMAR$Treatment  <- factor(DCIVA_LogMAR$Treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# DCIVA_LogMAR$percentage <- -DCIVA_LogMAR$percentage/100
# str(DCIVA_LogMAR)
# 
# 
# saveRDS(DCIVA_LogMAR, file = file.path(path,"01_Datasets","DCIVA_LogMAR.rds" ))
DCIVA_LogMAR <- readRDS(file = file.path(path, "01_Datasets","DCIVA_LogMAR.rds" ))

ggplot(data = DCIVA_LogMAR, aes(x = Visit, y= percentage, fill=LogMARCat)) +
  geom_bar(stat="identity", width =0.7,
           position=position_dodge()) +
  geom_text(aes(label = scales::percent(percentage,accuracy=0.1), y=percentage+0.001), 
            position = position_dodge(0.7), vjust = -.4, size=4.5)+
  scale_fill_brewer(palette="Dark2")+
  scale_y_continuous(labels = scales::percent, breaks=seq(0, 1, 0.1)) +
  theme_bw() +
  facet_grid(.~Treatment)+
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 13),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12),
        strip.text.x = element_text(size = 12)) +
  labs(x = "",
       y = "Percentage [%]",
       title = "",
       fill = "")




############################################################## 
### Figure 20
### DCNVA LogMAR
### Frequency of different ranges of DCNVA by visit (mITT)                                    
############################################################## 



# copdat <- read.delim("clipboard")
# DCNVA_LogMAR <- copdat
# DCNVA_LogMAR$Visit <- factor(DCNVA_LogMAR$Visit, labels = c("M1","M4-6"))
# DCNVA_LogMAR$LogMARCat <- factor(DCNVA_LogMAR$LogMARCat,levels = c("VA < 0.0 logMAR","0.0 <= VA < 0.1 logMAR",
#                                                                  "0.1 <= VA < 0.3 logMAR","VA >= 0.3 logMAR"))
# DCNVA_LogMAR$Treatment  <- factor(DCNVA_LogMAR$Treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# DCNVA_LogMAR$percentage <- -DCNVA_LogMAR$percentage/100
# str(DCNVA_LogMAR)
# 
# 
# saveRDS(DCNVA_LogMAR, file = file.path(path,"01_Datasets","DCNVA_LogMAR.rds" ))
DCNVA_LogMAR <- readRDS(file = file.path(path, "01_Datasets","DCNVA_LogMAR.rds" ))

ggplot(data = DCNVA_LogMAR, aes(x = Visit, y= percentage, fill=LogMARCat)) +
  geom_bar(stat="identity", width =0.7,
           position=position_dodge()) +
  geom_text(aes(label = scales::percent(percentage,accuracy=0.1), y=percentage+0.001), 
            position = position_dodge(0.7), vjust = -.4, size=4.5)+
  scale_fill_brewer(palette="Dark2")+
  scale_y_continuous(labels = scales::percent, breaks=seq(0, 1, 0.1)) +
  theme_bw() +
  facet_grid(.~Treatment)+
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 13),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12),
        strip.text.x = element_text(size = 12)) +
  labs(x = "",
       y = "Percentage [%]",
       title = "",
       fill = "")




#####################################################
### Figure 21
### SE
### Frequency of postoperative spherical equivalent (SE) at pre and 4-6 month postoperative (mITT)
#####################################################



# copdat <- read.delim("clipboard")
# SE_Cat <- copdat
# SE_Cat$Visit <- factor(SE_Cat$Visit, labels = c("Preoperative Visit","4-6-Month Postoperative Visit"))
# SE_Cat$Cat <- factor(SE_Cat$Cat,levels = c("<-1.00 D",">=-1.00 D to <-0.75 D",">=-0.75 D to <-0.50 D",
#                                            ">=-0.50 D to <-0.25 D",">=-0.25 D to <0.00 D",">=0.00 D to <0.25 D",
#                                            ">=0.25 D to <0.50 D",">=0.50 D to <0.75 D",">=0.75 D to <1.00 D",">=1.00 D"))
# SE_Cat$Treatment  <- factor(SE_Cat$Treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# SE_Cat$percentage <- SE_Cat$percentage/100
# str(SE_Cat)
# 
# saveRDS(SE_Cat, file = file.path(path,"01_Datasets","SE_Cat.rds" ))
SE_Cat <- readRDS(file = file.path(path, "01_Datasets","SE_Cat.rds" ))

ggplot(data = SE_Cat, aes(x = Cat, y= percentage, fill=Treatment)) +
  geom_bar(stat="identity", width =0.7,
           position=position_dodge()) +
  geom_text(aes(label = scales::percent(percentage,accuracy=0.1), y=percentage), 
            position = position_dodge(0.7), vjust = -.25, size=4.5)+
  scale_fill_brewer(palette="Paired")+
  scale_y_continuous(labels = scales::percent, breaks=seq(0, 1, 0.1)) +
  scale_x_discrete(labels = c("<-1.00 D",">=-1.00 D\nto <-0.75 D",">=-0.75 D\nto <-0.50 D",
                                ">=-0.50 D\nto <-0.25 D",">=-0.25 D\nto <0.00 D",">=0.00 D\nto <0.25 D",
                                ">=0.25 D\nto <0.50 D",">=0.50 D\nto <0.75 D",">=0.75 D\nto <1.00 D",">=1.00 D"))+
  theme_bw() +
  facet_grid(Visit~.)+
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 12),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12),
        strip.text.y = element_text(size = 12))+
  labs(x = "",
       y = "Percentage [%]",
       title = "",
       fill="")

 


#####################################################
### Figure 22
### SE Abs
### Absolute spherical equivalent at M4-6 Visit (mITT)
#####################################################


# copdat <- read.delim("clipboard")
# SE_AbsCat <- copdat
# 
# 
# SE_AbsCat$Visit <- factor(SE_AbsCat$Visit, labels = c("Pre-op", "M1", "M4-6"))
# SE_AbsCat$Cat <- factor(SE_AbsCat$Cat,levels = c("<= 0.25 D","<= 0.50 D","<= 0.75 D","<= 1.00 D", "> 1.00 D"))
# SE_AbsCat$Treatment  <- factor(SE_AbsCat$Treatment,labels = c("AT LARA toric 929MP","TECNIS Symfony toric"))
# SE_AbsCat$percentage <- -SE_AbsCat$percentage/100
# str(SE_AbsCat)
# 
# saveRDS(SE_AbsCat, file = file.path(path,"01_Datasets","SE_AbsCat.rds" ))
SE_AbsCat <- readRDS(file = file.path(path, "01_Datasets","SE_AbsCat.rds" ))

ggplot(data = SE_AbsCat, aes(x = Cat, y= percentage, fill=Treatment)) +
  geom_bar(stat="identity", width =0.7,
           position=position_dodge()) +
  geom_text(aes(label = scales::percent(percentage,accuracy=0.1), y=percentage-0.02), 
            position = position_dodge(0.7), vjust = -.35, size=4.5)+
  scale_fill_brewer(palette="Paired")+
  scale_y_continuous(labels = scales::percent, breaks=seq(0, 1, 0.1)) +
  theme_bw() +
  facet_grid(Visit~.)+
  theme(legend.position = "bottom",
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x  = element_text(size = 12),
        axis.text.y  = element_text(size = 12),
        legend.text = element_text(size = 12),
        strip.text.y = element_text(size = 12))+
  labs(x = "",
       y = "Percentage [%]",
       title = "",
       fill="")



