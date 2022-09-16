
parafit <- function(var_names = 1, data, Time, Event,
                    dist = c("exponential", "weibull"))
  {
  data$Surv_obj <- with(data, Surv(data[, Time], data[, Event]))
  formula<- as.formula(paste("Surv_obj ~", paste(var_names, collapse = "+")))
  
  # Model
  fit <- survreg(formula, data = data, dist = dist)
  fit.summ <- summary(fit)
  coef_tbl <- fit.summ$table
  
  se = coef_tbl[1:length(fit$coef), 2]
  
  # Acceleration Factor
  acc_factor <- cbind(exp(fit$coef),
                      exp(fit$coef - qnorm(0.975)*se),
                      exp(fit$coef + qnorm(0.975)*se))
  
  colnames(acc_factor) <- c("Acceleration Factor", "Lower CI (2.5 %)", "Upper CI (97.5 %)")
  
  # HR
  HR_tbl <- cbind(exp(-fit$coef),
                  exp(-(fit$coef + qnorm(0.975)*se)/fit$scale),
                  exp(-(fit$coef - qnorm(0.975)*se)/fit$scale))
  
  colnames(HR_tbl) <- c("Hazard Ratio", "Lower CI (2.5 %)", "Upper CI (97.5 %)")
  
  # AIC & LRT
  loglik <- fit$loglik[2]
  loglik_intcpt <- fit$loglik[1]
  df <- fit.summ$df
  
  Chi_sq <- fit.summ$chi
  p_LRT <- 1 - pchisq(Chi_sq, df - 1) # df include intercept
  
  AIC <- -2*loglik + (df - 1)* 2
  
  # AIC table
  aic_tb <- as.data.frame(matrix(c(loglik, loglik_intcpt,
                                   Chi_sq, (df-1), p_LRT, AIC),
                                   nrow = 1, ncol = 6))
  colnames(aic_tb) <- c("Log Likelihood",
                        "Log Likelihood (Null Model)",
                        "Chi-sq",
                        "# Parameters",
                        "LRT p-value (vs. Null Model)",
                        "AIC")
  rownames(aic_tb) <- NULL
  
  
  # Diagnosis Plot
  surv.fit <- survfit(Surv_obj ~ 1, data = data)
  p_exp<- ggplot()+
    geom_point(aes(surv.fit$time, -log(surv.fit$surv)))+
    labs(x = "Time", y = expression(hat(Lambda)(t)),
         title = "Cumulative Hazard vs. t")+
    newtheme + theme()
    
  p_weibull<- ggplot()+
    geom_point(aes(log(surv.fit$time), log(-log(surv.fit$surv))))+
    labs(x = "Log Time", y = expression(log(hat(Lambda)(t))),
         title = "Log Cumulative Hazard vs. log(t)")+
    newtheme2
  
  return(list(summary = coef_tbl, aic_tb = aic_tb,
              acc_factor = acc_factor,
              HR_tbl = HR_tbl,
              p_exp = p_exp, p_weibull = p_weibull))
  }
