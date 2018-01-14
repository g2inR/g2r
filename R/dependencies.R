#' Dependencies for g2, bizcharts, and data-set
#'
#' @return \code{htmltools::htmlDependency}
#' @name dependencies
NULL

#' @rdname dependencies
#' @export
dep_g2 <- function() {
  #https://unpkg.com/@antv/g2@3.0.4-beta.3/
  htmltools::htmlDependency(
    name = "g2",
    version = "3.0.4",
    src = c(file=system.file("www/g2/lib", package="g2r")),
    script = "g2.js"
  )
}

#' @rdname dependencies
#' @export
dep_dataset <- function() {
  #https://unpkg.com/@antv/data-set@0.8.3/
  htmltools::htmlDependency(
    name = "data-set",
    version = "0.8.3",
    src = c(file=system.file("www/data-set/lib", package="g2r")),
    script = "data-set.js"
  )
}

#' @rdname dependencies
#' @export
dep_bizcharts <- function() {
  #https://unpkg.com/bizcharts@3.1.0/
  htmltools::htmlDependency(
    name = "bizcharts",
    version = "3.1.0",
    src = c(file=system.file("www/bizcharts/lib", package="g2r")),
    script = "Bizcharts.min.js"
  )
}

#' @rdname dependencies
#' @export
dep_corejs <- function() {
  #shim/polyfill for ES5 and ES6 so react will show up in RStudio Viewer
  #https://unpkg.com/core-js@2.5.3/
  htmltools::htmlDependency(
    name = "core-js",
    version = "2.5.3",
    src = c(file=system.file("www/core-js/dist", package="g2r")),
    script = "shim.min.js"
  )
}
