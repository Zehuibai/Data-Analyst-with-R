
alpha <- 0.05
k <- 1
Power <- 0.8
S1 <- 0.75
S2 <- 0.85
Ratio_N2_N1 <- 2
Lost2Follow <- 0



alpha <- 0.05
k <- 2
Power <- 0.81
S1 <- 0.5
S2 <- 0.7
Ratio_N2_N1 <- 1
Lost2Follow <- 0

# https://www.ncss.com/wp-content/themes/ncss/pdf/Procedures/PASS/Logrank_Tests-Freedman.pdf

# LogrankCR2(alpha=alpha, Power=Power, S_ev1 = HighRisk, S_ev2=LowRisk,
# S_cr=S_cr, P1=HighDist, P2=1-HighDist, T=5.0000000001, R=0.0000000001)[1:7]



LogrankCR2 <- function(alpha, k, Power, S1, S2, Ratio_N2_N1, Lost2Follow){
  
  
  ## Quantile from standard normal distribution
  z_power <- qnorm(Power, mean = 0, sd = 1)
  z_alpha <- qnorm(1-alpha/k, mean = 0, sd = 1)
  HR <- log(S2)/log(S1)
  Temp <- (z_power+z_alpha)*(1+Ratio_N2_N1*HR)/(abs(HR-1))
  Temp2 <- Ratio_N2_N1*(1-S1+Ratio_N2_N1*(1-S2))/(1+Ratio_N2_N1)
  N <- Temp^2/((1-Lost2Follow)*Temp2)
  N1 <- ceiling(N/(1+Ratio_N2_N1))
  N2 <- ceiling(N*Ratio_N2_N1/(1+Ratio_N2_N1))
  N <- N1 + N2
  paste0("Overall = ", N)
  paste0("Treatment Group 1 = ", N1)
  paste0("Treatment Group 2 = ", N2)
  
  E1 <-  -log(S1)*N1
 
  
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
