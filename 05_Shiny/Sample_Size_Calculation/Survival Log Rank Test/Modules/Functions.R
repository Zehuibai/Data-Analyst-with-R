# <!-- ---------------------------------------------------------------------- -->
# <!--      load the required thema and functions used in KM Estimates        -->
# <!-- ---------------------------------------------------------------------- -->

# New theme for plot
newtheme<-theme_bw()+
  theme(panel.background = element_rect(color = "white"),
        plot.title = element_text(size = 15, hjust = 0.5),
        axis.title = element_text(size = 13),
        axis.text = element_text(size = 11),
        legend.text = element_text(size = 11),
        panel.grid = element_blank())

newtheme2<-theme_bw()+
  theme(panel.background = element_rect(color = "white"),
        plot.title = element_text(size = 13, hjust = 0.5),
        axis.title = element_text(size = 13),
        axis.text = element_text(size = 11),
        legend.text = element_text(size = 11),
        panel.grid = element_blank())

# New theme for table
table_theme <- theme_cleantable()+
  theme(text = element_text(size = 12, color = "#666666"))

# survminer package 
# surv_fit, Create Survival Curves
# ggsurvplot, Drawing Survival Curves Using ggplot2
surv_est<-function(data, Time, Event,
                   conf.int, conf.type = c("log", "log-log", "plain"), type,
                   isCumHaz, isContinuous, isRiskTbl, isCensPlot,
                   isStrat, varStrat = NULL, cutpoint = NULL){
  
  data$Surv_obj <- with(data, Surv(data[, Time], data[, Event]))
  
  ### Fleming-Harrington was not provided
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
      else {print("Enter cutoffs points for continious variable: ")}
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
                       title = "KM Survival Estimate")
  
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




# compare survival curves using comp from survMisc package
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
    else {print("Enter cutoffs points for continious variable: ")}
  }
  
  if(sum(as.numeric(testMethod)) != 0)
  {
    f.test <- as.formula(paste("Surv_obj ~ ", varStrat_test))
    
    fit <- do.call(survfit, args = list(
      formula = f.test, data = data))
    
    # compare survival curves using comp from survMisc package
    m <- capture.output(comp(ten(fit)))
    
    test <- read.table(textConnection(m[2:5]),
                       sep = "", header = FALSE, na.strings ="",
                       stringsAsFactors= FALSE, fill = TRUE,
                       col.names = c("test", "Q", "Var", "Z","pNorm"))%>%
            select(-pNorm, -test)
    test$Q <- round(test$Q,3)
    test$Var <- round(test$Var,3)
    test$Z <- round(test$Z,3)
    test$pValue <- round(2 * (1 - stats::pnorm(abs(test$Z))),3)
    
    rownames(test) <- c("log-rank",	
                        "Gehan-Breslow Generalized Wilcoxon",	
                        "Tarone-Ware",	
                        "Peto-Peto")
    test.output <- test[as.numeric(c(testMethod)), ]
  }
  else {test.output <- NULL}
  return(test.output)
}



### Cox Proportional Hazard Model
coxfit <- function(var_names, data, Time, Event, int_var = NULL)
{
  data$Surv_obj <- with(data, Surv(data[, Time], data[, Event]))
  formula<- as.formula(paste("Surv_obj ~", paste(var_names, collapse = "+")))
  
  fit <- coxph(formula, data = data, method = "breslow")
  fit.summ <- as.data.frame(summary(fit)$coef)
  
  if (!is.null(int_var))
  {
    formula_int<- as.formula(paste("Surv_obj ~",
                                   paste(var_names, collapse = "+"),
                                   paste0("+ ", Time, ":", int_var)))
    
    fit_int <- coxph(formula_int, data = data, method = "breslow")
    fit_int.summ <- as.data.frame(summary(fit_int)$coef)
  }
  else 
  {fit_int.summ <- NULL}
  
  loglik <- fit$loglik[2]
  df <- round(length(fit$coef))
  AIC <- -2*loglik + df * 2
  
  # AIC table
  aic_tb <- as.data.frame(matrix(c(loglik, df, AIC), nrow = 1, ncol = 3))
  colnames(aic_tb) <- c("Log Likelihood", "Number of Variables", "AIC")
  rownames(aic_tb) <- NULL
  
  
  return(list(summary = fit.summ, aic_tb = aic_tb,
              fit_int.summ = fit_int.summ))
}


