## Bayesian Logistic Regression

This repository contains a GUI written in Rshiny to perform Bayesian Logistic regression analysis in R. The interface is based on the MCMClogit function from the MCMCpack package.

Author: Nicola Voyle <nicola.voyle@kcl.ac.uk>  

Written and tested in R Version 3.2.2 using OS X El Capitan Version 10.11.1

### Quick Start

1. Open R
2. Install 'shiny' library
3. Place the three files from this repo (model.R, ui.R and server.R) in a folder called 'bayes-app'
4. Navigate to the parent directory of 'bayes-app'
5. In R, run runApp('bayes-app') to launch the application

```bash
# clone repo and name desitnation `bayes-app`
git clone https://github.com/KHP-Informatics/bayesian-logistic-regression-r-shiny-app.git bayes-app
cd bayes-app

# launch R
R

# run the application
library(shiny)
runApp('bayes-app')
```

## Dependencies

Install the following

- `R` 
- `RStudio`
- `shiny`

`R` pacakges:- 


```
install.packages("shiny", dependencies=TRUE);
install.packages("arm", dependencies=TRUE);
install.packages("MCMCpack", dependencies=TRUE);
install.packages("coda", dependencies=TRUE);
install.packages("fBasics", dependencies=TRUE);
install.packages("stats4", dependencies=TRUE);
install.packages("MASS", dependencies=TRUE);
install.packages("vcd", dependencies=TRUE);
install.packages("caret", dependencies=TRUE);
install.packages("pROC", dependencies=TRUE);
install.packages("ROCR", dependencies=TRUE);
install.packages("BoomSpikeSlab", dependencies=TRUE);
```

## Questions?** 
email: nicola.voyle@kcl.ac.uk

Please note, this application was not created in conjunction with the developers of MCMCpack.
Their package and documentation are fully acknowledged:

http://mcmcpack.berkeley.edu/index.html

https://cran.r-project.org/web/packages/MCMCpack/index.html

Andrew D. Martin, Kevin M. Quinn, Jong Hee Park (2011). MCMCpack: Markov Chain Monte Carlo in R. Journal of Statistical Software. 42(9): 1-21. URL http://www.jstatsoft.org/v42/i09/.

