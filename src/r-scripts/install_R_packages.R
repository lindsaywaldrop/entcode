#### Installs required R packages ####

packages <- c("pracma", "useful", "data.table", "ggplot2", "R.matlab", 
              "doParallel","foreach", "tidyr", "patchwork",
              "viridis", "stringr", "knitr", "markdown", "rmarkdown")

package.check <- lapply(
  packages,
  FUN <- function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE, repos = "http://cran.us.r-project.org")
      library(x, character.only = TRUE)
    }
  }
)
