library(shiny)
library(survival)
patientdata<-read.csv(file="HNpatientdata.csv",header=TRUE)
shinyServer(
        function(input,output) {  
            output$newKM<-renderPlot({
                    if (input$Survival=="Overall survival"){
                            if (input$Stratification=="gender"){
                                    HN.surv <- survfit(Surv(survival_month, Overall_status) ~ gender, data = subset(patientdata,tumor_site==input$TumorSite))
                                    legend_IDs<-c("Female","Male")
                                    HN.surv.sig <- survdiff(Surv(survival_month, Overall_status) ~ gender, data = subset(patientdata,tumor_site==input$TumorSite))
                                    output$Significance<-renderPrint({HN.surv.sig})
                            } else if (input$Stratification=="race"){
                                    HN.surv <- survfit(Surv(survival_month, Overall_status) ~ race, data = subset(patientdata,tumor_site==input$TumorSite))
                                    legend_IDs<-c("Black or African American","White")
                                    HN.surv.sig <- survdiff(Surv(survival_month, Overall_status) ~ race, data = subset(patientdata,tumor_site==input$TumorSite))
                                    output$Significance<-renderPrint({HN.surv.sig})
                            } else if (input$Stratification=="ethnicity"){
                                    HN.surv <- survfit(Surv(survival_month, Overall_status) ~ ethnicity, data = subset(patientdata,tumor_site==input$TumorSite))
                                    legend_IDs<-c("Hispanic/Latino","non-Hispanic/Latino")
                                    HN.surv.sig <- survdiff(Surv(survival_month, Overall_status) ~ ethnicity, data = subset(patientdata,tumor_site==input$TumorSite))
                                    output$Significance<-renderPrint({HN.surv.sig})
                            } else if (input$Stratification=="current_smoker"){
                                    HN.surv <- survfit(Surv(survival_month, Overall_status) ~ current_smoker, data = subset(patientdata,tumor_site==input$TumorSite))
                                    legend_IDs<-c("No","Yes")
                                    HN.surv.sig <- survdiff(Surv(survival_month, Overall_status) ~ current_smoker, data = subset(patientdata,tumor_site==input$TumorSite))
                                    output$Significance<-renderPrint({HN.surv.sig})
                            } else if (input$Stratification=="current_drinker"){
                                    HN.surv <- survfit(Surv(survival_month, Overall_status) ~ current_drinker, data = subset(patientdata,tumor_site==input$TumorSite))
                                    legend_IDs<-c("No","Yes")
                                    HN.surv.sig <- survdiff(Surv(survival_month, Overall_status) ~ current_drinker, data = subset(patientdata,tumor_site==input$TumorSite))
                                    output$Significance<-renderPrint({HN.surv.sig})
                            } else {
                                    HN.surv <- survfit(Surv(survival_month, Overall_status) ~ node_status, data = subset(patientdata,tumor_site==input$TumorSite))
                                    legend_IDs<-c("Node-negative","Node-positive")
                                    HN.surv.sig <- survdiff(Surv(survival_month, Overall_status) ~ node_status, data = subset(patientdata,tumor_site==input$TumorSite))
                                    output$Significance<-renderPrint({HN.surv.sig})
                            }
                    } 
                    else {
                            if (input$Stratification=="gender"){
                                    HN.surv <- survfit(Surv(survival_month, DOD_status) ~ gender, data = subset(patientdata,tumor_site==input$TumorSite))
                                    legend_IDs<-c("Female","Male")
                                    HN.surv.sig <- survdiff(Surv(survival_month, DOD_status) ~ gender, data = subset(patientdata,tumor_site==input$TumorSite))
                                    output$Significance<-renderPrint({HN.surv.sig})
                            } else if (input$Stratification=="race"){
                                    HN.surv <- survfit(Surv(survival_month, DOD_status) ~ race, data = subset(patientdata,tumor_site==input$TumorSite))
                                    legend_IDs<-c("Black or African American","White")
                                    HN.surv.sig <- survdiff(Surv(survival_month, DOD_status) ~ race, data = subset(patientdata,tumor_site==input$TumorSite))
                                    output$Significance<-renderPrint({HN.surv.sig})
                            } else if (input$Stratification=="ethnicity"){
                                    HN.surv <- survfit(Surv(survival_month, DOD_status) ~ ethnicity, data = subset(patientdata,tumor_site==input$TumorSite))
                                    legend_IDs<-c("Hispanic/Latino","non-Hispanic/Latino")
                                    HN.surv.sig <- survdiff(Surv(survival_month, DOD_status) ~ ethnicity, data = subset(patientdata,tumor_site==input$TumorSite))
                                    output$Significance<-renderPrint({HN.surv.sig})
                            } else if (input$Stratification=="current_smoker"){
                                    HN.surv <- survfit(Surv(survival_month, DOD_status) ~ current_smoker, data = subset(patientdata,tumor_site==input$TumorSite))
                                    legend_IDs<-c("No","Yes")
                                    HN.surv.sig <- survdiff(Surv(survival_month, DOD_status) ~ current_smoker, data = subset(patientdata,tumor_site==input$TumorSite))
                                    output$Significance<-renderPrint({HN.surv.sig})
                            } else if (input$Stratification=="current_drinker"){
                                    HN.surv <- survfit(Surv(survival_month, DOD_status) ~ current_drinker, data = subset(patientdata,tumor_site==input$TumorSite))
                                    legend_IDs<-c("No","Yes")
                                    HN.surv.sig <- survdiff(Surv(survival_month, DOD_status) ~ current_drinker, data = subset(patientdata,tumor_site==input$TumorSite))
                                    output$Significance<-renderPrint({HN.surv.sig})
                            } else {
                                    HN.surv <- survfit(Surv(survival_month, DOD_status) ~ node_status, data = subset(patientdata,tumor_site==input$TumorSite))
                                    legend_IDs<-c("Node-negative","Node-positive")
                                    HN.surv.sig <- survdiff(Surv(survival_month, DOD_status) ~ node_status, data = subset(patientdata,tumor_site==input$TumorSite))
                                    output$Significance<-renderPrint({HN.surv.sig})
                            }
                    }
                    plot(HN.surv, lty = 1,xlab="Months after Diagnosis",ylab="Proportion survived",col=c(1,2),mark.time=TRUE,main="Plot of patient survival by stratification group")
                    legend("bottomleft", legend_IDs, pch=1.2, lty=1, col=c(1,2),title="Stratification")
                })
            output$MedianAge<-renderPrint({median(subset(patientdata,tumor_site==input$TumorSite)$age)})
            output$NumPatients<-renderPrint({nrow(subset(patientdata,tumor_site==input$TumorSite))})
            
}
)