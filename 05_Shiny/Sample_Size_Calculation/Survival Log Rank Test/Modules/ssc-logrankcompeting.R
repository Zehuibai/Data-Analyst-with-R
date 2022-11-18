t <- 0.83
alpha <- 0.008333333
Power <- 0.9
HighRisk <- 0.527
LowRisk <- 0.85
CompetingRisk <- 0.05
S_cr <- 1-CompetingRisk
HighDist <- 0.9

 

# LogrankCR2(alpha=alpha, Power=Power, S_ev1 = HighRisk, S_ev2=LowRisk,
# S_cr=S_cr, P1=HighDist, P2=1-HighDist, T=5.0000000001, R=0.0000000001)[1:7]



LogrankCR2 <- function(alpha, Power, S_ev1, S_ev2, S_cr, P1, P2, T, R){
  
  
  # local <- alpha*log(1+(exp(1)-1)*t)
  design <- getDesignGroupSequential(sided = 1, alpha = alpha, 
                            informationRates = c(t, 1), typeOfDesign = "asP")
  # Calculate the local alpha at interim analysis and final alpha used
  # Alpha Spending Function that approximate Pocock Boundaries 
  local <- design$stageLevels[1]
  alpha_2 <- design$stageLevels[2]
  
  ## Quantile from standard normal distribution
  z_power <- qnorm(Power, mean = 0, sd = 1)
  z_local <- qnorm(1-local, mean = 0, sd = 1)
  
  ## Hazard Ratio
  H_ev1 <- -log(S_ev1)/T
  H_ev2 <- -log(S_ev2)/T
  H_cr <- -log(S_cr)/T
  HR <- H_ev2/H_ev1
  
  ## Probability of observing event of interest in the group
  P_ev1 <- (H_ev1/(H_ev1+H_cr))*(1-((exp(-(T-R)*(H_ev1+H_cr))-exp(-T*(H_ev1+H_cr)))/(R*(H_ev1+H_cr))))
  P_ev2 <- (H_ev2/(H_ev2+H_cr))*(1-((exp(-(T-R)*(H_ev2+H_cr))-exp(-T*(H_ev2+H_cr)))/(R*(H_ev2+H_cr))))
  P_ev <- P1*P_ev1+P2*P_ev2
  
  ## sample size without follow up lost
  N <- (1/(P1*P2*P_ev))*(((z_local+z_power)/log(HR))^2)
  
  N_Total <- N/t
  ## total number of events for the risk factor of interest
  E <- N_Total*P_ev
  Z_final_Power <- -sqrt(E*P1*(1-P1))*log(HR)-qnorm(1-alpha_2, mean = 0, sd = 1)
  final_Power <- pnorm(Z_final_Power, mean = 0, sd = 1)
  
  sample <- c(ceiling(N*P1*P_ev1), ceiling(N*P2*P_ev2),
              ceiling(N*P1), ceiling(N*P2),
              ceiling(N*P1)+ ceiling(N*P2), 
              ceiling((1-t)*N*P1/t)+ceiling((1-t)*N*P2/t),
              round(final_Power*100,2))
  return(sample)
}


# LogrankCR2(alpha=alpha, Power=Power, S_ev1 = HighRisk, S_ev2=LowRisk,
           # S_cr=0.95, P1=0.9, P2=0.1, T=5.0000000001, R=0.0000000001)[1:7]
