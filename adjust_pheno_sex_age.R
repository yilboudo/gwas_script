#This script allows you to inverse normal transform phenotypes
#Adjusting for any phenotype for age and sex covariates you would like
rm(list =ls())
library(data.table)

inv_norm_trans <- function(input_filename=NULL,output_filename=NULL, phenotype=NULL, Age=NULL, Sex=NULL, image_output_name=NULL, print=TRUE) {
  # input_filename: input file
  # output_filename: output file
  # phenotype: phenotype columname in input file
  # Age: Age columname in input file
  # Sex: Sex columnname in input file
  # image_output_name
  if(is.null(input_filename)){
    cat(" You need to provide the file with data\n")
    cat(" OPTIONS: \n")
    cat(" output_filename: output file \n")
    cat(" phenotype: phenotype columname in input file\n")
    cat(" Age: Age columname in input file\n")
    cat(" Sex: Sex columnname in input file\n")
    cat(" image name\n")
    return("NA")
  } 
  
  input_data<- fread(input_filename, h=T, sep="\t")
 
  input_data$lm_models_resid <- resid(lm(phenotype ~ Age + Sex ,data=input_data))
  
  input_data <- transform(input_data, phenotype_normalized = (input_data$lm_models_resid - mean(input_data$lm_models_resid))/ sd(input_data$lm_models_resid))
  
  input_data$phenotype_zscore <- qnorm((rank(input_data$phenotype_normalized,na.last="keep")-0.5)/sum(!is.na(input_data$phenotype_normalized)))
  
  write.table(input_data, file = output_filename, quote = FALSE, row.names = TRUE, col.names = FALSE,sep="\t")

  ma <- matrix(c(1,1,2,2), nrow = 1, ncol =4)
  layout(ma)
  
  png( image_output_name, units="in",units="in", width=8, height=8, res=350, pointsize = 11)
  
  hist(input_data$phenotype, col = "blue",main = "Before Tranformation", xlab="")
  rug(input_data$phenotype, col="blue")
  
  hist(input_data$phenotype_zscore, col = "red", main = "After Transformation",add=T)
  rug(input_data$phenotype_zscore, col="red")
  
  dev.off()
  
}
  