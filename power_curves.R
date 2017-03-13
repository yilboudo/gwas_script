#This script calculates the exact power from non centrality parameter
#and alpha threshold (significance) for a quantitative trait
#assuming an additive model and a chi-square distribution

rm(list =ls())
library(pwr)


power_curves <-function(N=NULL,alpha=NULL,af=NULL,beta=NULL, figure_name=NULL, print=TRUE) {
  # N: sample size
  # alpha: significance threshold
  # af : minor allele frequency
 if(is.null(N)){
    cat(" You need to provide the sample size\n")
    cat(" OPTIONS: \n")
    cat(" alpha: significance threshold \n")
    cat(" af: minor allele frequencies (provide three) in format c(0.1, 0.2, 0.4)\n")
    cat(" beta: effect size maximum value\n")
    return("NA")
 } 
  beta_power <- cbind(NULL,NULL,NULL,NULL,NULL)
  
  N_final = N * 2*af*(1-af)
  beta_power$effect_size = seq(0, beta, length.out = 200)
  
  beta_power$power <- sapply(seq(length(beta_power$effect_size)),
                             function(i) pwr.chisq.test(N = N_final[1] ,
                                                        sig.level = alpha,
                                                        w = beta_power$effect_size[i],
                                                        df = 1)$power)
  
  beta_power$power2 <- sapply(seq(length(beta_power$effect_size)),
                              function(i) pwr.chisq.test(N = N_final[2] ,
                                                         sig.level = alpha,
                                                         w = beta_power$effect_size[i],
                                                         df = 1)$power)
  
  beta_power$power3 <- sapply(seq(length(beta_power$effect_size)),
                              function(i) pwr.chisq.test(N = N_final[3] ,
                                                         sig.level = alpha,
                                                         w = beta_power$effect_size[i],
                                                         df = 1)$power)
  
  png(figure_name, units="in", width=8, height=8, res=350, pointsize = 9)
  plot(beta_power$effect_size,beta_power$power,type='l', xlab = 'Beta', ylab = 'Power', lwd = 2 ,col = 'blue')
  lines(beta_power$effect_size,beta_power$power2,lty=2,lwd = 2, col = 'red')
  lines(beta_power$effect_size,beta_power$power3,type='l',lty=3,lwd = 2, col = 'purple')
  legend("bottomright", cex = 1.3, 
         legend = c("Allele Frequency: 0.10", 
                    "Allele Frequency: 0.25", 
                    "Allele Frequency: 0.50"), 
         col = c("blue",
                 "red",
                 "purple"), lwd = 1, lty = c(1,2,3))
  
  dev.off()
}  
  