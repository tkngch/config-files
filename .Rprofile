#!/usr/bin/env Rscript

library(utils)
library(grDevices)
library(graphics)
library(stats)


.First <- function() {
    if(interactive()) try(loadhistory("~/.cache/Rhistory"))
}


.Last <- function() {
    if(interactive()) try(savehistory("~/.cache/Rhistory"))
}


# options(warn=1)  # print warnings as they occur
options(warn=2)  # treat warnings as errors

# chooseCRANmirror(ind=17)  # Bristol HTTPS


#########################
# Convenience functions #
#########################

resize <- function() {
    options(width=as.integer(system("stty -a | head -n 1 | awk '{print $7}' | sed 's/;//'", intern=T)))
}


logistic <- function(x) { 1 / (1 + exp(-1 * x)) }


print_info <- function(info, accent) {
    cat("\n\n")
    cat(paste(rep(accent, nchar(info)), sep="", collapse=""))
    cat("\n")
    cat(info)
    cat("\n")
    cat(paste(rep(accent, nchar(info)), sep="", collapse=""))
    cat("\n\n")
}


compare <- function(fm1, fm0, confint=TRUE) {
    print(anova(fm1, fm0, test="Chisq"))
    cat("\n")
    print(fixef(fm1))
    if (confint) { print(confint(fm1, method="Wald")) }
    cat("\n\n")
}


#####################################
# Installation routine for packages #
#####################################


install_package <- function(pkg) {
    install.packages(pkg,
                     lib=Sys.getenv("R_LIBS_USER"))
}


update_packages <- function() {
    update.packages(lib.loc=Sys.getenv("R_LIBS_USER"))
}


install_lme4 <- function() {
    import("devtools");
    with_libpaths(new=Sys.getenv("R_LIBS_USER"),
                  install_github("lme4/lme4",
                                 dependencies=TRUE))
}


# adapted from http://irkernel.github.io/installation/ on 29 Jan 2016
install_irkernel <- function() {
    install.packages(c('rzmq','repr','IRkernel','IRdisplay'),
                     repos = c('http://irkernel.github.io/', getOption('repos')),
                     type = 'source',
                     lib=Sys.getenv("R_LIBS_USER"))
}


# retrieved from http://mc-stan.org/rstan/install.R
# then modifed to allow user installation and to specify the number of cores
# on 24 September 2014
install_rstan <- function() {
    Sys.setenv(MAKEFLAGS = "-j4")  # 4 cores

  on.exit(Sys.unsetenv("R_MAKEVARS_USER"))
  on.exit(Sys.unsetenv("R_MAKEVARS_SITE"), add = TRUE)

  try(remove.packages("rstan", lib=Sys.getenv("R_LIBS_USER")), silent = TRUE)
  Sys.setenv(R_MAKEVARS_USER = "foobar")
  Sys.setenv(R_MAKEVARS_SITE = "foobar")
  install.packages(c("inline", "BH", "RcppEigen"),
                   lib=Sys.getenv("R_LIBS_USER"))
  install.packages("Rcpp", type = "source",
                   lib=Sys.getenv("R_LIBS_USER"))
  library(inline)
  library(Rcpp)
  src <- '
    std::vector<std::string> s;
    s.push_back("hello");
    s.push_back("world");
    return Rcpp::wrap(s);
  '
  hellofun <- cxxfunction(body = src, includes = '', plugin = 'Rcpp', verbose = FALSE)
  test <- try(hellofun())
  if(inherits(test, "try-error")) stop("hello world failed; ask for help on Rcpp list")

  options(repos = c(getOption("repos"),
          rstan = "http://rstan.org/repo/"))
  install.packages("rstan", type = 'source',
                   lib=Sys.getenv("R_LIBS_USER"))
  library(rstan)
  set_cppo("fast")
  if (any(grepl("^darwin", R.version$os, ignore.case = TRUE))) {
    cat('\nCC=clang', 'CXX=clang++ -arch x86_64 -ftemplate-depth-256',
        file = "~/.R/Makevars", sep = "\n", append = TRUE)
  }
  return(invisible(NULL))
}
