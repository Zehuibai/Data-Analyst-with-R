newtheme<-theme_bw()+
  theme(panel.background = element_rect(color = "white"),
        plot.title = element_text(size = 15, hjust = 0.5),
        axis.title = element_text(size = 13),
        axis.text = element_text(size = 11),
        legend.text = element_text(size = 11),
        panel.grid = element_blank())

table_theme <- theme_cleantable()+
  theme(text = element_text(size = 12, color = "#666666"))

surv_est<-function(data, Time, Event,
                   conf.int, conf.type = c("log", "log-log", "plain"), type,
                   isCumHaz, isContinuous, isRiskTbl, isCensPlot,
                   isStrat, varStrat = NULL, cutpoint = NULL){
  
  data$Surv_obj <- with(data, Surv(data[, Time], data[, Event]))
  
  stype <- switch(type, 
                  "Kaplan-Meier" = 1,
                  "Fleming-Harrington" = 2)
  
  fit1 <- surv_fit(Surv_obj ~ 1,
                   data = data, conf.type = conf.type,
                   ctype = 1, stype = stype)
  fit.summ <- summary(fit1)
  
  # Kaplan Meier Plot
  if(isStrat)
  {
    if(!isContinuous)
    {
      data[, varStrat] <- as.factor(data[, varStrat])
    }
    
    else
    {
      if(!is.null(cutpoint))
      {
        var_cont <- data[, varStrat]
        
        cutnum <- cutpoint %>% 
          strsplit(split = ",") %>%
          unlist()%>%
          as.numeric()%>%
          append(range(var_cont))%>%
          unique()
        
        cutnum <- cutnum[cutnum %between% range(var_cont)]
        
        data[, varStrat] <- cut(as.numeric(var_cont), cutnum)
      }
      else {print("Please enter cutoffs points: ")}
    }
  
    f <- as.formula(paste("Surv_obj ~ ", varStrat))
    
    fit2 <- do.call(survfit, args = list(
      formula = f,
      data = data, conf.type = conf.type,
      ctype = 1, stype = stype)
      )
      
    fit <- fit2
  }
  else {fit <- fit1}
  
  
  islegend <- ifelse((!isStrat)||isRiskTbl||isCensPlot, "none", "bottom")
  if(isStrat&&isCensPlot&&(!isRiskTbl)) {islegend = "bottom"}

  mycolor <- ifelse(isStrat, "strata", "salmon")
  
  # Survival Plot
  p_surv <- ggsurvplot(fit, data = data, legend = islegend,
                       xlab = "Time", conf.int = conf.int,
                       risk.table = isRiskTbl, ncensor.plot = isCensPlot,
                       ggtheme = newtheme, legend.title = "",
                       censor.size = 4, size  = 0.3,
                       color = mycolor,
                       surv.plot.height = 0.62,
                       risk.table.height = 0.17,
                       ncensor.plot.height = 0.21,
                       tables.theme =  theme_cleantable(),
                       title = "Survival Estimate")
  
  # Cumulative Hazard Plot
  p_cumhaz <- ggsurvplot(fit, data = data, legend = islegend,
                         legend.title = "",
                         xlab = "Time", conf.int = conf.int,
                         ggtheme = newtheme,
                         risk.table = isRiskTbl, ncensor.plot = isCensPlot,
                         fun = "cumhaz",
                         color = mycolor,
                         censor.size = 4, size  = 0.3,
                         surv.plot.height = 0.62,
                         risk.table.height = 0.17,
                         ncensor.plot.height = 0.21,
                         tables.theme =  theme_cleantable(),
                         title = "Cumulative Hazard Estimate")
  
  extcol <- c("time", "n.risk", "n.event", "n.censor", "surv")
  name <-c("time", "n.risk", "n.event", "n.censor", "Survival")
  
  if(isCumHaz){
    extcol <- c(extcol, "cumhaz")
    name <- c(name, "Cumulative Hazard")
  }
  
  if(conf.int){
    extcol <- c(extcol, "std.err", "lower", "upper")
    name <- c(name, "s.e.", "Lower 95% CI", "Upper 95% CI")
  }
  
  cols <- lapply(extcol, function(name) {fit.summ[name]})
  tbl <- do.call(data.frame, cols)
  colnames(tbl) <- name

  return(list(tbl = tbl, p_surv = p_surv, p_cumhaz = p_cumhaz))
}

surv_test <- function(data, Time, Event,
                      varStrat_test = NULL, testMethod = NULL,
                      isContinuous = FALSE, cutpoint = NULL)
{
  data$Surv_obj <- with(data, Surv(data[, Time], data[, Event]))
  
  if(!isContinuous)
  {data[, varStrat_test] <- as.factor(data[, varStrat_test])}
  
  else
  {
    if(!is.null(cutpoint))
    {
      var_cont <- data[, varStrat_test]
      
      cutnum <- cutpoint %>% 
        strsplit(split = ",") %>%
        unlist()%>%
        as.numeric()%>%
        append(range(var_cont))%>%
        unique()
      
      cutnum <- cutnum[cutnum %between% range(var_cont)]
      
      data[, varStrat_test] <- cut(as.numeric(var_cont), cutnum)
    }
    else {print("Please enter cutoffs points: ")}
  }
  
  if(sum(as.numeric(testMethod)) != 0)
  {
    f.test <- as.formula(paste("Surv_obj ~ ", varStrat_test))
    
    fit <- do.call(survfit, args = list(
      formula = f.test, data = data))
    
    m <- capture.output(comp(ten(fit)))
    
    test <- read.table(textConnection(m[2:7]),
                       sep = "", header = FALSE, na.strings ="",
                       stringsAsFactors= FALSE, fill = TRUE,
                       col.names = c("test", "Q", "Var", "Z", "pNorm", "signif"))%>%
            select(-signif, -test)
    
    rownames(test) <- c("log-rank",	
                        "Gehan-Breslow Generalized Wilcoxon",	
                        "Tarone-Ware",	
                        "Peto-Peto",
                        "Modified Peto-Peto (by Andersen)",
                        "Fleming-Harrington")
    test.output <- test[as.numeric(c(testMethod)), ]
  }
  else {test.output <- NULL}
  return(test.output)
}
