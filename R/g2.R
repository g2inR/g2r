#' G2 Chart
#'
#' Create a 'g2' chart
#'
#' @import htmlwidgets
#'
#' @export
g2_chart <- function(
  # https://github.com/antvis/g2/blob/master/src/index.d.ts
  # ChartProp interface
  data = NULL,
  #container: string | HTMLDivElement;
  #width: number;
  #height: number;
  padding = NULL,
  #padding?:
  #  | {
  #    top: number;
  #    right: number;
  #    bottom: number;
  #    left: number;
  #  }
  #| number
  #| [number, number, number, number]
  #| [string, string];
  #background?: ChartBackground;
  #plotBackground?: ChartBackground;
  forceFit = TRUE,
  #forceFit?: boolean;
  animate = TRUE,
  #animate?: boolean;
  #pixelRatio?: number;
  #data?: Object | any;
  options = list(),
  
  width = NULL,
  height = NULL,
  elementId = NULL
) {

  # forward options using x
  x <- list(
    data = data,
    padding = padding,
    forceFit = forceFit,
    animate = animate,
    options = options
  )
  
  # remove NULL
  x <- Filter(Negate(is.null), x)

  # create widget
  htmlwidgets::createWidget(
    name = 'g2',
    x = x,
    width = width,
    height = height,
    package = 'g2r',
    dependencies = dep_g2(),
    elementId = elementId
  )
}

#' Shiny bindings for g2
#'
#' Output and render functions for using g2 within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a g2
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name g2-shiny
#'
#' @export
g2Output <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'g2', width, height, package = 'g2r')
}

#' @rdname g2-shiny
#' @export
renderG2 <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, g2Output, env, quoted = TRUE)
}
