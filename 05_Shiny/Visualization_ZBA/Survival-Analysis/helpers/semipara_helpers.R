# read data
newtheme2<-theme_bw()+
  theme(panel.background = element_rect(color = "white"),
        plot.title = element_text(size = 13, hjust = 0.5),
        axis.title = element_text(size = 13),
        axis.text = element_text(size = 11),
        legend.text = element_text(size = 11),
        panel.grid = element_blank())


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
  
  # deviance residual
  dev_res<-residuals(fit, type = "deviance")
  p_deviance<-ggplot()+
    geom_point(aes(fit$linear.predictors, dev_res,
                   pch = as.factor(data[, Event]),
                   col = as.factor(data[, Event])), size = 0.8)+
    labs(x = "Linear Predictor", y = "Deviance Residuals",
         title = "Deviance Residuals vs. Fitted Values")+
    scale_shape_manual(breaks = levels(as.factor(data[, Event])),
                       values = c(3, 19), name = "Event")+
    scale_color_manual(breaks = levels(as.factor(data[, Event])),
                       values = c(1, 2), name = "Event")+
    newtheme
  
  # Schoenfeld Residual
  test.ph <- cox.zph(fit)
  p_schoenfeld <- ggcoxzph(test.ph, ggtheme = newtheme2, point.shape = 20)
  p_schoenfeld <- ggpar(p_schoenfeld,
                        font.main = c(15, "plain", "black"),
                        font.x = c(13, "plain", "black"),
                        font.y = c(13, "plain", "black"))
  
  return(list(summary = fit.summ, aic_tb = aic_tb,
              p_deviance = p_deviance, p_schoenfeld = p_schoenfeld,
              fit_int.summ = fit_int.summ))
}

