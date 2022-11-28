library(survival)
library(grid)

gbg.kaplan.meier.plot.v1 <- function(
  endpoint.time, endpoint.event, group,
  bw = F, groups.col, groups.lty,
  atrisk.shown = T, atrisk.colored = T, legend.colored = T,
  xlab = "time (months)", xlab.in = T, ylab = "event free survival", lab.cex = 1.2,
  xlim, xticks, yticks = seq(from = 0, to = 100, by = 20),
  title, title.cex = 1.2,
  fontsize = 12, fontfamily = NULL, lineheight = 1.2,
  censor.pch = 18, censor.cex = 0.8,
  curves.lwd = 1, axes.lwd = 1,
  median.shown = F, median.col, median.lty, median.lwd = curves.lwd,
  block.features, block.cex = 1.0, block.lineheight = 1.0, block.colored = T,
  block.just = c(0, 0), block.x = unit(0.02, "npc"), block.y = unit(1.2 * lab.cex, "lines")) {



  ###### helper functions

  # check color specifications
  check.col.specification <- function(col) {
    if (is.character(col)) {
      stopifnot(col %in% colors() | grepl("^#[0-9A-F]{6}$", col))
    } else if (is.numeric(col)) {
      stopifnot(col > 0)
      stopifnot(col == as.integer(col))
    } else {
      stop("invalid color specification")
    }
  }

  # check line type specifications
  check.lty.specification <- function(lty) {
    if (is.character(lty)) {
      stopifnot(lty %in% c("solid", "dashed", "dotted", "dotdash", "longdash", "twodash"))
    } else if (is.numeric(lty)) {
      stopifnot(lty >= 1 & lty <= 6)
      stopifnot(lty == as.integer(lty))
    } else {
      stop("invalid line type specification")
    }
  }

  # create grobs for median survival lines
  create.median.grobs <- function(df, median.lwd, endpoint, group, xlim, vCurves) {
    # calculate median follow-up times
    df$qt <- NA_real_
    for(i in seq(along = df$groups)) {
      qt <- quantile(survfit(y ~ 1, data = data.frame(y = endpoint[group == groups[i]])), 0.5)$quantile
      stopifnot(length(qt) == 1) # internal
      stopifnot(is.numeric(qt) || is.na(qt)) # internal
      df$qt[i] <- ifelse(is.na(qt), Inf, qt)
    }

    # sort by median follow-up time (determine color/type of overlapping lines)
    df <- df[order(df$qt), ]

    # create grobs for lines
    grobs <- gList()
    x <- 0
    for(i in seq(along = df$groups)) {
      if (is.finite(df$qt[i])) {
        grobs <- gList(grobs, linesGrob(
          x = unit(c(x, df$qt[i], df$qt[i]), "native"), y = unit(c(50, 50, 0), "native"),
          gp = gpar(col = df$median.col[i], lty = df$median.lty[i], lwd = median.lwd),
          vp = vCurves))
        x <- df$qt[i]
      } else {
        grobs <- gList(grobs, linesGrob(
          x = unit(c(x, xlim), "native"), y = unit(c(50, 50), "native"),
          gp = gpar(col = df$median.col[i], lty = df$median.lty[i], lwd = median.lwd),
          vp = vCurves))
        break
      }
    }
    return(grobs)
  }

  # block creation including parameter checks
  create.block.grob <- function(
      block.features, block.cex, block.lineheight, block.colored, block.just, block.x, block.y,
      groups, endpoint, group, valid.samples, groups.col, censor.pch, censor.cex, lineheight, vCurves) {

    # check parameters
    stopifnot(is.numeric(block.cex) && length(block.cex) == 1)
    stopifnot(block.cex > 0)
    stopifnot(is.numeric(block.lineheight) && length(block.lineheight) == 1)
    stopifnot(block.lineheight > 0)
    stopifnot(is.logical(block.colored) && length(block.colored) == 1)
    stopifnot(!is.na(block.colored))
    stopifnot(is.numeric(block.just) && length(block.just) == 2)
    stopifnot(block.just >= 0 & block.just <= 1)
    stopifnot(is.unit(block.x) && length(block.x) == 1)
    stopifnot(is.finite(block.x))
    stopifnot(is.unit(block.y) && length(block.y) == 1)
    stopifnot(is.finite(block.y))

    # count number of lines
    stopifnot(is.list(block.features))

    # perform two parsing runs:
    # run 0: count number of block text lines to generate
    # run 1: create block grobs
    for(k in 0:1) {

      # inits for run 1
      if (k == 1) {

        # save total number of block text lines
        n.lines <- line.counter
        if (n.lines == 0) return(NULL)

        # create grob for text lines
        vp0 <- viewport(x = block.x, y = block.y,
                        width = unit(1, "npc"), height = unit(n.lines * block.cex * block.lineheight / lineheight, "lines"),
                        just = block.just, gp = gpar(cex = block.cex, lineheight = block.lineheight))
        vp <- viewport(x = 0, y = 0, width = 1, height = 1, just = c(0, 0), default.units = "npc")
        grobs <- gList()
      }

      # init block text line counter
      line.counter <- 0

      # parse/process block feature list
      for(i in seq(along = block.features)) {

        # get feature name and value
        feature.name <- names(block.features)[i]
        feature.value <- block.features[[i]]
        if (is.null(feature.name) || feature.name == "" || is.na(feature.name)) {
          feature.name <- feature.value
          stopifnot(is.character(feature.name) && length(feature.name) == 1)
          stopifnot(!is.na(feature.name))

          # set defaults
          if (feature.name == "median") feature.value <- "months"
          if (feature.name == "user") feature.value <- ""
        }

        # distinguish and process features
        # censored symbol block feature
        if (feature.name == "censored") {
          line.counter <- line.counter + 1 # create one block text line
          if (k == 1) {
            stopifnot(identical(feature.value, "censored"))
            stopifnot(!is.null(censor.pch)) # block legend "censored" not allowed if censored not shown in KM-curves
            u1 <- unit(censor.cex / block.cex, "strwidth", ifelse(is.character(censor.pch), censor.pch, "m"))
            h1 <- unit(1, "strheight", ifelse(is.character(censor.pch), censor.pch, "m"))
            u2 <- unit(1, "strwidth", " censored")
            col <- NULL
            if (block.colored && length(groups) == 1) col <- groups.col
            grobs <- gList(
              grobs,
              pointsGrob(x = unit(block.just[1], "npc") + block.cex / censor.cex * (-block.just[1] * (u1 + u2) + 0.5 * u1),
                         y = block.cex / censor.cex * (unit(n.lines - line.counter, "lines") + 0.4 * h1),
                         pch = censor.pch, gp = gpar(cex = censor.cex / block.cex, col = col),
                         vp = vp),
              textGrob(" censored",
                       unit(block.just[1], "npc") - block.just[1] * (u1 + u2) + u1,
                       unit(n.lines - line.counter, "lines"), gp = gpar(col = col),
                       c(0, 0), vp=vp))
            rm(u1, h1, u2, col)
          }

        # user text block feature
        } else if (feature.name == "user") {
          line.counter <- line.counter + 1 # create one block text line
          if (k == 1) {
            stopifnot(is.character(feature.value) && length(feature.value) == 1)
            stopifnot(!is.na(feature.value))
            grobs <- gList(grobs, textGrob(
              feature.value,
              unit(block.just[1], "npc"),
              unit(n.lines - line.counter, "lines"),
              c(block.just[1], 0), vp=vp))
          }

        # hazard ratio block feature
        } else if (feature.name == "HR") {
          stopifnot(length(groups) == 2)
          line.counter <- line.counter + 1 # create one block text line
          if (k == 1) {
            # set list default
            if (identical(feature.value, "HR")) feature.value <- list("CI")

            # init subfeatures with defaults
            HR.ratio <- F
            HR.CI <- F
            HR.level <- 0.95
            HR.Wald <- F
            HR.LR <- F

            # process sub-features
            for(j in seq(along = feature.value)) {

              # get sub-feature name and value
              subfeature.name <- names(feature.value)[j]
              if (is.null(subfeature.name) || subfeature.name == "" || is.na(subfeature.name)) {
                subfeature.name <- feature.value[[j]]
                stopifnot(is.character(subfeature.name) && length(subfeature.name) == 1)
                stopifnot(!is.na(subfeature.name))
              }
              subfeature.value <- feature.value[[j]]

              # process sub-features
              if (subfeature.name == "ratio") {
                stopifnot(identical(subfeature.value, "ratio"))
                HR.ratio <- T
              } else if (subfeature.name == "CI") {
                stopifnot(identical(subfeature.value, "CI"))
                HR.CI <- T
              } else if (subfeature.name == "level") {
                stopifnot(is.numeric(subfeature.value) && length(subfeature.value) == 1)
                stopifnot(subfeature.value > 0 && subfeature.value < 1)
                HR.level <- subfeature.value
              } else if (subfeature.name == "Wald") {
                stopifnot(identical(subfeature.value, "Wald"))
                HR.Wald <- T
              } else if (subfeature.name == "LR") {
                stopifnot(identical(subfeature.value, "LR"))
                HR.LR <- T
              } else
                stop("invalid sub-feature in HR in block.features")
              rm(subfeature.name, subfeature.value)
            }

            # perform Cox regression
            stopifnot(group %in% groups)
            model <- coxph(y ~ x, data = data.frame(x = as.double(group == groups[2]), y = endpoint), method = "breslow", eps = 1E-6)

            # create block text line
            s <- "HR"
            if (HR.ratio) s <- sprintf("%s(%s vs %s)", s, groups[2], groups[1])
            s <- sprintf("%s=%6.4f", s, exp(model$coef))
            if (HR.CI) s <- sprintf("%s (%6.4f..%6.4f)", s,
                                    exp(model$coef + qnorm(0.5 * (1 - HR.level)) * sqrt(model$var)),
                                    exp(model$coef - qnorm(0.5 * (1 - HR.level)) * sqrt(model$var)))
            if (HR.Wald) s <- sprintf("%s, p%s=%s", s, ifelse(HR.LR, "(Wald)", ""),
                                      gbg.format.p.v1(1 - pchisq(model$coef^2/model$var, 1)))
            if (HR.LR) s <- sprintf("%s, p%s=%s", s, ifelse(HR.Wald, "(LR)", ""),
                                      gbg.format.p.v1(1 - pchisq(2 * (model$loglik[2] - model$loglik[1]), 1)))

            # show block text line
            grobs <- gList(grobs, textGrob(
              s,
              unit(block.just[1], "npc"),
              unit(n.lines - line.counter, "lines"),
              c(block.just[1], 0), vp=vp))
            rm(HR.ratio, HR.CI, HR.level, HR.Wald, HR.LR, j, model, s)
          }

        # log rank test block feature
        } else if (feature.name == "log-rank") {
          line.counter <- line.counter + 1 # create one block text line
          if (k == 1) {
            stopifnot(identical(feature.value, "log-rank"))
            sd <- survdiff(y ~ x, data = data.frame(x = group, y = endpoint, stringsAsFactors = F))
            grobs <- gList(grobs, textGrob(
              sprintf("p(Log-rank)=%s", gbg.format.p.v1(1 - pchisq(sd$chisq, length(groups) - 1))),
              unit(block.just[1], "npc"),
              unit(n.lines - line.counter, "lines"),
              c(block.just[1], 0), vp=vp))
            rm(sd)
          }

        # stratified log rank test block feature
        } else if (feature.name == "log-rank stratified") {
          line.counter <- line.counter + 1 # create one block text line
          if (k == 1) {
            # checks
            stopifnot(is.list(feature.value))
            stopifnot(identical(sort(names(feature.value)), c("data", "name")))
            stopifnot(is.numeric(feature.value$data) || is.character(feature.value$data) || is.factor(feature.value$data))
            stopifnot(length(feature.value$data) == length(valid.samples))
            z <- feature.value$data[valid.samples]
            stopifnot(!is.na(z))
            stopifnot(is.character(feature.value$name) && length(feature.value$name) == 1)
            stopifnot(!is.na(feature.value$name))

            # calculate p-value, show block text line
            sd <- survdiff(y ~ x + strata(z), data = data.frame(
              x = group, y = endpoint, z = z, stringsAsFactors = F))
            grobs <- gList(grobs, textGrob(
              sprintf("p(Log-rank stratified by %s)=%s", feature.value$name, gbg.format.p.v1(1 - pchisq(sd$chisq, length(groups) - 1))),
              unit(block.just[1], "npc"),
              unit(n.lines - line.counter, "lines"),
              c(block.just[1], 0), vp=vp))
            rm(z, sd)
          }

        # event number block feature
        } else if (feature.name == "events") {
          line.counter <- line.counter + length(groups) # create one block text line per subgroup
          if (k == 1) {
            stopifnot(identical(feature.value, "events"))
            for(j in seq(along = groups)) {
              stopifnot(is.finite(endpoint[, 1])) # internal check
              stopifnot(endpoint[, 2] %in% c(0, 1)) # internal check
              stopifnot(!is.na(group)) # internal check
              flags <- (group == groups[j])
              grobs <- gList(grobs, textGrob(
                sprintf("%s %1.0f/%1.0f events",
                        groups[j], sum(flags & endpoint[, 2] == 1), sum(flags)),
                unit(block.just[1], "npc"),
                unit(n.lines - line.counter - j + length(groups), "lines"),
                c(block.just[1], 0),
                gp = gpar(col = if (block.colored) groups.col[j]),
                vp=vp))
            }
            rm(j, flags)
          }

        # median time block feature
        } else if (feature.name == "median") {
          line.counter <- line.counter + length(groups) # create one block text line per subgroup
          if (k == 1) {
            stopifnot(is.character(feature.value) && length(feature.value) == 1)
            stopifnot(!is.na(feature.value))
            for(j in seq(along = groups)) {
              # calculate median follow up time
              qt <- quantile(survfit(y ~ 1, data = data.frame(y = endpoint[group == groups[j]])), 0.5)$quantile
              stopifnot(length(qt) == 1) # internal
              stopifnot(is.numeric(qt) || is.na(qt)) # internal
              if (is.na(qt))
                qt.str <- "NA"
              else
                qt.str <- sprintf("%g %s", qt, feature.value)

              # show block text line
              grobs <- gList(grobs, textGrob(
                sprintf("median time%s=%s",
                        ifelse(length(groups) == 1, "", sprintf("(%s)", groups[j])), qt.str),
                unit(block.just[1], "npc"),
                unit(n.lines - line.counter - j + length(groups), "lines"),
                c(block.just[1], 0),
                gp = gpar(col = if (block.colored) groups.col[j]),
                vp=vp))
            }
            rm(j, qt, qt.str)
          }

        # bad feature name
        } else
          stop("invalid feature name in block.features")
      }
    }

    # combine grobs into one grob
    ret <- gTree(vp = vp0, children = grobs)
    ret <- gTree(vp = vCurves, children = gList(ret))
    return(ret)
  }



  ###### parameter checks and defaults

  # check endpoint.time and endpoint.event, derive n.samples and endpoint
  if (is.Surv(endpoint.time)) {
    stopifnot(attr(endpoint.time, "type") == "right")
    stopifnot(missing(endpoint.event))
    endpoint <- endpoint.time
    n.samples <- dim(endpoint)[1]
    stopifnot(identical(dim(endpoint), c(n.samples, 2L)))
  } else if (is.numeric(endpoint.time) && is.logical(endpoint.event)) {
    stopifnot(length(endpoint.time) == length(endpoint.event))
    n.samples <- length(endpoint.time)
    endpoint <- Surv(endpoint.time, endpoint.event)
  } else if (is.numeric(endpoint.time) && is.numeric(endpoint.event)) {
    stopifnot(endpoint.event %in% c(0, 1, NA))
    stopifnot(length(endpoint.time) == length(endpoint.event))
    n.samples <- length(endpoint.time)
    endpoint <- Surv(endpoint.time, endpoint.event)
  } else if (is.numeric(endpoint.time) && (is.character(endpoint.event) || is.factor(endpoint.event))) {
    stopifnot(endpoint.event %in% c("yes", "no", NA))
    stopifnot(length(endpoint.time) == length(endpoint.event))
    n.samples <- length(endpoint.time)
    endpoint <- Surv(endpoint.time, endpoint.event == "yes")
  } else {
    stop("bad data type for endpoint.time and/or endpoint.event")
  }
  stopifnot(endpoint[, 1] >= 0 | is.na(endpoint))
  endpoint[is.na(endpoint)] <- NA
  rm(endpoint.time, endpoint.event)

  # check group, determine groups
  if (missing(group)) {
    group <- rep("", n.samples)
    groups <- ""
  } else if (is.factor(group)) {
    stopifnot(length(group) == n.samples)
    groups <- levels(group)
  } else if (is.character(group)) {
    stopifnot(length(group) == n.samples)
    groups <- sort(unique(group))
  } else if (is.numeric(group)) {
    stopifnot(length(group) == n.samples)
    groups <- as.character(sort(unique(group)))
    group <- as.character(group)
  } else {
    stop("bad data type for group")
  }

  # determine samples to process
  valid.samples <- !is.na(endpoint) & !is.na(group)
  endpoint <- endpoint[valid.samples]
  group <- group[valid.samples]
  # remember valid.samples for stratified log-rank test

  # remove groups without samples
  flags <- rep(T, length(groups))
  for(i in seq(along = groups))
    flags[i] <- any(group == groups[i])
  groups <- groups[flags]
  stopifnot(length(groups) > 0)
  rm(i, flags)

  # check bw
  stopifnot(is.logical(bw) && length(bw) == 1)
  stopifnot(!is.na(bw))

  # check/determine groups.col
  if (missing(groups.col)) {
    if (bw) {
      groups.col <- "black"
    } else {
      groups.col <- c("blue", "red", "green4", "magenta", "cyan", "goldenrod4")
      stopifnot(length(groups.col) >= length(groups))
      groups.col <- groups.col[1:length(groups)]
    }
  }
  if (length(groups.col) == 1)
    groups.col <- rep(groups.col, length(groups))
  stopifnot(length(groups.col) == length(groups))
  check.col.specification(groups.col)

  # check/determine groups.lty
  if (missing(groups.lty)) {
    if (bw) {
      groups.lty <- 1:6
      stopifnot(length(groups.lty) >= length(groups))
      groups.lty <- groups.lty[1:length(groups)]
    } else {
      groups.lty <- 1
    }
  }
  if (length(groups.lty) == 1)
    groups.lty <- rep(groups.lty, length(groups))
  stopifnot(length(groups.lty) == length(groups))
  check.lty.specification(groups.lty)

  # check atrisk.shown, atrisk.colored, legend.colored
  stopifnot(is.logical(atrisk.shown) && length(atrisk.shown) == 1)
  stopifnot(!is.na(atrisk.shown))
  stopifnot(is.logical(atrisk.colored) && length(atrisk.colored) == 1)
  stopifnot(!is.na(atrisk.colored))
  stopifnot(is.logical(legend.colored) && length(legend.colored) == 1)
  stopifnot(!is.na(legend.colored))

  # check label parameters
  stopifnot(is.character(xlab) && length(xlab) == 1)
  stopifnot(!is.na(xlab))
  stopifnot(is.logical(xlab.in) && length(xlab.in) == 1)
  stopifnot(!is.na(xlab.in))
  stopifnot(is.character(ylab) && length(ylab) == 1)
  stopifnot(!is.na(ylab))
  stopifnot(is.numeric(lab.cex) && length(lab.cex) == 1)
  stopifnot(lab.cex > 0)

  # check/determine xlim
  if (missing(xlim)) {
    xlim <- max(endpoint[, 1], na.rm = T)
    if (!missing(xticks)) {
      stopifnot(is.numeric(xticks) && length(xticks) >= 1)
      stopifnot(xticks >= 0)
      xlim <- max(c(xlim, xticks))
    }
    xlim <- xlim * 1.02
  }
  stopifnot(is.numeric(xlim) && length(xlim) == 1)
  stopifnot(xlim > 0)

  # determine xticks
  if (missing(xticks)) {
    xticks <- seq(0, xlim, ifelse(xlim < 12, 1, 12))
  }
  stopifnot(is.numeric(xticks) && length(xticks) >= 1)
  stopifnot(xticks >= 0)

  # check yticks
  stopifnot(is.numeric(yticks))
  stopifnot(yticks >= 0 & yticks <= 100)

  # check title parameters
  if (!missing(title)) {
    stopifnot(is.character(title) & length(title) == 1)
    stopifnot(!is.na(title))
  }
  stopifnot(is.numeric(title.cex) & length(title.cex) == 1)
  stopifnot(title.cex > 0)

  # check font parameters
  stopifnot(is.numeric(fontsize) & length(fontsize) == 1)
  stopifnot(fontsize > 0)
  # parameter "fontfamily" is not explicitely check here but implicitely as a
  #   parameter to the gpar() function below. Please note that the validity of
  #   the fontfamily depends on the graphical device.
  stopifnot(is.numeric(lineheight) && length(lineheight) == 1)
  stopifnot(lineheight > 0)

  # check censor marker parameters
  if (!is.null(censor.pch)) {
    stopifnot((is.numeric(censor.pch) || is.character(censor.pch)) && length(censor.pch) == 1)
    if (is.numeric(censor.pch)) {
      stopifnot(is.finite(censor.pch) && censor.pch == as.integer(censor.pch))
    } else {
      stopifnot(!is.na(censor.pch) & nchar(censor.pch) == 1)
    }
  }
  stopifnot(is.numeric(censor.cex) && length(censor.cex) == 1)
  stopifnot(censor.cex > 0)

  # check line width parameters
  stopifnot(is.numeric(curves.lwd) && length(curves.lwd) == 1)
  stopifnot(curves.lwd > 0)
  stopifnot(is.numeric(axes.lwd) && length(axes.lwd) == 1)
  stopifnot(axes.lwd > 0)

  # check median survival flag
  stopifnot(is.logical(median.shown) && length(median.shown) == 1)
  stopifnot(!is.na(median.shown))

  # check/determine median.col
  if (missing(median.col))
    median.col <- groups.col
  if (length(median.col) == 1)
    median.col <- rep(median.col, length(groups))
  stopifnot(length(median.col) == length(groups))
  check.col.specification(median.col)

  # check/determine median.lty
  if (missing(median.lty))
    median.lty <- 6
  if (length(median.lty) == 1)
    median.lty <- rep(median.lty, length(groups))
  stopifnot(length(median.lty) == length(groups))
  check.lty.specification(median.lty)

  # check median line width
  stopifnot(is.numeric(median.lwd) && length(median.lwd) == 1)
  stopifnot(median.lwd > 0)

  # block parameters are checked when plotting the block



  ###### perform plotting

  # width of group legend lines and group texts
  uGroup.lines <- unit(5, "strwidth", "x")
  uGroup.texts <- unit(0, "strwidth", "")
  for(g in groups)
    uGroup.texts <- max(uGroup.texts, unit(1, "strwidth", g))
  uGroup.texts <- uGroup.texts + unit(1, "strwidth", " 100%") # add some space before and after group text

  # create viewports, init lists
  vPlot <- viewport(gp = gpar(fontsize = fontsize, fontfamily = fontfamily, lineheight = lineheight)) # global options
  uYLabel <- unit(1, "strwidth", "  100% --") + unit(lab.cex, "lines") # y-axis label
  uLeft <- max(uGroup.lines + uGroup.texts, uYLabel) # usually the legend width
  uBottom <- unit(2.5 + ifelse(atrisk.shown, 1 + length(groups), 0) + ifelse(xlab.in, 0, lab.cex), "lines") # x-axis, patients-at-risk, x-axis label
  uRight <- unit(0.5, "strwidth", "999") # ensure rightmost x-axis tick label and patients-at-risk to be visible
  uTop <- unit(0.5, "lines") # ensure uppermost y-axis tick label to be visible
  if (!missing(title)) uTop <- uTop + unit(title.cex, "strheight", title)
  vCurves <- viewport(x = uLeft, y = uBottom,
                      width = unit(1, "npc") - uLeft - uRight,
                      height = unit(1, "npc") - uBottom - uTop,
                      just = c(0, 0),
                      xscale = c(0, xlim), yscale = c(0, 102))

  # create "static" grobs
  grobs <- gList(
    rectGrob(vp = vCurves, gp = gpar(lwd = axes.lwd)),
    xaxisGrob(vp = vCurves, at = xticks,
              gp = gpar(lwd = axes.lwd)),
    yaxisGrob(vp = vCurves, at = yticks, label = sprintf("%1.0f%%", yticks),
              gp = gpar(lwd = axes.lwd)),
    textGrob(xlab, x = unit(xlim / 2, "native"),
             y = unit(ifelse(xlab.in, 1,
                             (-2.5 - ifelse(atrisk.shown, 1 + length(groups), 0)) / lab.cex), "lines"),
             just = "top", gp = gpar(cex = lab.cex, fontface = "bold"), vp = vCurves),
    textGrob(ylab, x = (-1 / lab.cex) * uYLabel,
             y = unit(50, "native"), rot = 90,
             just = "top", gp = gpar(cex = lab.cex, fontface = "bold"), vp = vCurves))
  if (!missing(title)) grobs <- gList(
    grobs,
    textGrob(title, x = unit(xlim / 2, "native"), y = unit(1, "npc") + unit(0.45/title.cex, "lines"),
             just = "bottom", gp = gpar(cex = title.cex, fontface = "bold"), vp = vCurves))

  # add median lines
  if (median.shown) {
    grobs <- gList(grobs, create.median.grobs(data.frame(
      groups = groups, median.col = median.col, median.lty = median.lty, stringsAsFactors = F),
      median.lwd, endpoint, group, xlim, vCurves))
  }

  # matrix for patients at risk
  n.at.risk <- matrix("", nrow = length(groups), ncol = length(xticks))

  # create grobs for each group
  for(i in seq(along = groups)) {
    # perform KM calculations in group
    in.group <- (group == groups[i])
    sf <- survfit(endpoint[in.group] ~ 1, conf.type = "none")
    n = length(sf$time)
    stopifnot(n >= 1)
    stopifnot(sf$time >= 0)
    stopifnot(length(sf$n.risk) == n)
    stopifnot(length(sf$n.event) == n)
    stopifnot(length(sf$n.censor) == n)
    stopifnot(length(sf$surv) == n)
    stopifnot(length(sf$std.err) == n)

    # points for KM curve
    x <- c(0, sf$time[gl(n, 2)])
    y <- c(1, 1, sf$surv[c(gl(n-1, 2), n)])
    stopifnot(diff(x) >= 0)
    stopifnot(diff(y) <= 0)

    # remove KM curve points not necessary
    flags <- c(T, diff(x) > 0 | diff(y) < 0) # no duplicated points
    x <- x[flags]
    y <- y[flags]
    flags <- c(T, diff(y, 2) < 0, T) # no intermediate points
    x <- x[flags]
    y <- y[flags]
    stopifnot(diff(x) >= 0)
    stopifnot(diff(y) <= 0)
    stopifnot((diff(x) == 0) + (diff(y) == 0) == 1)

    # add KM curve
    grobs <- gList(grobs, linesGrob(
      x = unit(x, "native"), y = unit(100 * y, "native"),
      gp = gpar(col = groups.col[i], lty = groups.lty[i], lwd = curves.lwd),
      vp = vCurves))

    # add censored samples
    if (!is.null(censor.pch)) {
      flags <- (sf$n.censor > 0)
      if (any(flags)) {
        grobs <- gList(grobs, pointsGrob(
          x = unit(sf$time[flags], "native"),
          y = unit(100 * sf$surv[flags], "native"),
          pch = censor.pch, gp = gpar(col = groups.col[i], cex = censor.cex),
          vp = vCurves))
      }
    }

    # add legend entry for patients at risk
    if (atrisk.shown) {
      grobs <- gList(grobs,
                     linesGrob(x = unit.c(-1 * uGroup.lines - uGroup.texts,
                                          -1 * uGroup.texts),
                               y = unit(rep(-2.6 - i, 2), "lines") + unit(0.4, "strheight", "pM"),
                               gp = gpar(col = groups.col[i], lty = groups.lty[i], lwd = curves.lwd),
                               vp = vCurves),
                     textGrob(sprintf(" %s", groups[i]),
                              x = -1 * uGroup.texts, y = unit(-2.6 - i, "lines"),
                              just = c("left", "bottom"),
                              gp = gpar(col = if (legend.colored) groups.col[i]),
                              vp = vCurves))
    }

    # calculate numbers of patients at risk
    for(j in seq(along = xticks)) {
      idx <- which.min(ifelse(sf$time < xticks[j], NA, sf$time))
      stopifnot(length(idx) <= 1)
      if (length(idx) == 0)
        n.at.risk[i, j] <- "0"
      else
        n.at.risk[i, j] <- sprintf("%1.0f", sf$n.risk[idx])
    }
  }

  # add patients at risk
  if (atrisk.shown)
    for(j in seq(along = xticks)) {
      # horizontal position (left alignment in column)
      x <- unit(xticks[j], "native") + unit(max(nchar(n.at.risk[, j])) / 2, "strwidth", "9")

      # plot patients at risk numbers
      for(i in seq(along = groups)) {
        grobs <- gList(grobs, textGrob(
          n.at.risk[i, j],
          x = x, y = unit(-2.6 - i, "lines"), just = c("right", "bottom"),
          gp = gpar(col = if (atrisk.colored) groups.col[i]),
          vp = vCurves))
      }
    }

  # add block
  if (!missing(block.features)) {
    grobs <- gList(grobs, create.block.grob(
      block.features, block.cex, block.lineheight, block.colored, block.just, block.x, block.y,
      groups, endpoint, group, valid.samples, groups.col, censor.pch, censor.cex, lineheight, vCurves))
  }

  # combine grobs
  gPlot <- gTree(vp = vPlot, children = grobs)
  return(gPlot)
}


