require("plyr")
require("dplyr")
require("ggplot2")
require("pwr")
require("shinyBS")

power.wrapper <- function(input){
  print("Power.wrapper")
  print(input$whichTest)
  # print(input$delta)
  switch(input$whichTest,
         "t.test"={
            print("In power.wrapper::t.test")
#             if(!is.na(input$delta) &
#                !is.na(input$stdDev) &
#                !is.na(input$alpha) &
#                !is.na(input$power) &
#                !is.na(input$n))
              # {
              if(input$solveFor=="Power"){
                out <- try(power.t.test(n=input$n, delta=input$delta, sd=input$stdDev,
                                    sig.level=min(1,max(input$alpha,1e-10,na.rm=T)),
                                    alternative=input$alternative))
                if(class(out) != "try-error")
                  return(out)
              }
              else{
                out <- try(power.t.test(delta=input$delta, sd=input$stdDev,
                                    sig.level=min(1,max(input$alpha,1e-10,na.rm=T)),
                                    power=min(1.0,max(input$power,0.1,na.rm=T)),
                                    alternative=input$alternative))
                if(class(out) != "try-error")
                  return(out)
              }
            # }
           return(input)
         },
         "prop.test"={
           print("In power.wrapper::prop.test")
#            if(!is.na(input$p1) &
#               !is.na(input$p2) &
#               !is.na(input$alpha) &
#               !is.na(input$power) &
#               !is.na(input$n))
#            {
             if(input$solveFor=="Power"){
               out <- try(power.prop.test(n=input$n, p1=input$p1, p2=input$p2,
                                   sig.level=min(1,max(input$alpha,1e-10,na.rm=T)),
                                   alternative=input$alternative))
               if(class(out) != "try-error")
                 return(out)
               }
             else{
               out <- try(power.prop.test(p1=input$p1, p2=input$p2,
                                      sig.level=min(1,max(input$alpha,1e-10,na.rm=T)),
                                      power=min(1.0,max(input$power,0.1,na.rm=T)),
                                      alternative=input$alternative))
               if(class(out) != "try-error")
                 return(out)
             }
           # }
           return(input)
         },
         {
           ## Default value: Do nothing
           ## Need this line to avoid errors while at About page
           print("Nothing to do here...")
           print(input$n)
           print(input$power)
           return(list(n=input$n, power=input$power))
         }
         )
}

#
# calc.power.n.curve <- function(input){
#   print("In calc.power.n.curve")
#   power <- seq(0.3, 0.99, 0.01)
#   n <- switch(input$whichTest,
#   "t.test" = apply(t(power), 2, function(p){
#     power.t.test(delta=input$delta, sd=input$stdDev,
#                  sig.level=input$alpha, power=p,
#                  alternative=input$alternative)$n}),
#   "prop.test" = apply(t(power), 2, function(p){
#     power.prop.test(p1=input$p1, p2=input$p2,
#                  sig.level=input$alpha, power=p,
#                  alternative=input$alternative)$n}),
#   default = NULL
#   )
#   return(data_frame(power=power, n=n))
# }

plot.power.n <- function(input){
  #print("In plot.power.n")
  minPower <- switch(input$whichTest,
              "t.test" =
                power.t.test(n = 2, delta=input$delta, sd=input$stdDev,
                             sig.level=input$alpha,
                             alternative=input$alternative)$power,
              "prop.test" =
                power.prop.test(n=2, p1=input$p1, p2=input$p2,
                                sig.level=input$alpha,
                                alternative=input$alternative)$power)
  if(input$power < 0.99)
    power <- seq(minPower, 0.99, 0.01)
  else
    power <- seq(minPower, min(input$power, 1-.Machine$double.eps), length=100)
  n <- switch(input$whichTest,
    "t.test" = apply(t(power), 2, function(p){
      power.t.test(delta=input$delta, sd=input$stdDev,
                   sig.level=input$alpha, power=p,
                   alternative=input$alternative)$n}),
    "prop.test" = apply(t(power), 2, function(p){
      power.prop.test(p1=input$p1, p2=input$p2,
                   sig.level=input$alpha, power=p,
                   alternative=input$alternative)$n})
  )
  power.n.curve.df <- data_frame(power=power, n=n)
  # power.n.curve.df <- calc.power.n.curve(input)
  pwrCurve <- ggplot(power.n.curve.df) +
    geom_line(aes(y=power, x=n)) +
    labs(y="Power", x="Number of observations per group") +
    ylim(c(0, 1)) +
    xlim(range(n))
  if(between(input$n, min(n), max(n)))
    pwrCurve <- pwrCurve +
    annotate("segment", x=input$n, xend=input$n,
             y=0, yend=1, col="red", linetype=2)
    pwrCurve <- pwrCurve +
    annotate("segment", x=min(n), xend=max(n),
             y=input$power, yend=input$power, col="red", linetype=2)
  return(pwrCurve)
}



#' Ref:
#' http://stackoverflow.com/questions/31051133/how-do-i-make-sure-that-a-shiny-reactive-plot-only-changes-once-all-other-reacti