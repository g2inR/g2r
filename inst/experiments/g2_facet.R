library(htmltools)
library(g2r)

#  gosh this is ugly and I'm sure highly worst practice
asJSON <- jsonlite:::asJSON
setMethod("asJSON", "ANY", function(x, force = FALSE, ...) {
  if (inherits(x, "noquote")) {
    return(x)
  }
  if (isS4(x) && !is(x, "classRepresentation")) {
    if (isTRUE(force)) {
      return(asJSON(attributes(x), force = force, ...))
    } else {
      stop("No method for S4 class:", class(x))
    }
  } else if (length(class(x)) > 1) {
    # If an object has multiple classes, we recursively try the next class. This is
    # S3 style dispatching that doesn't work by default for formal method definitions
    # There should be a more native way to accomplish this
    return(asJSON(structure(x, class = class(x)[-1]), force = force, ...))
  } else if (isTRUE(force) && existsMethod("asJSON", class(unclass(x)))) {
    # As a last resort we can force encoding using the unclassed object
    return(asJSON(unclass(x), force = force, ...))
  } else if (isTRUE(force)) {
    return(asJSON(NULL))
    warning("No method asJSON S3 class: ", class(x))
  } else {
    # If even that doesn't work, we give up.
    stop("No method asJSON S3 class: ", class(x))
  }
})
assignInNamespace("asJSON", asJSON, ns="jsonlite")
rm(asJSON, envir = .GlobalEnv)

scr_template <- "
G2.track(false)

var data = %s

var chart_config = %s;

var chart = new G2.Chart(chart_config.config);

Object.keys(chart_config).filter(function(ky) {
  return ky !== 'config'
}).forEach(function(ky) {
  if(['source', 'tooltip'].indexOf(ky) > -1) {
    chart[ky](chart_config[ky])
    return
  }

  if(['scale', 'axis'].indexOf(ky) > -1) {
    Object.keys(chart_config[ky]).forEach(function(scale_ky) {
      chart[ky](scale_ky, chart_config[ky][scale_ky])
    })
    return
  }
  
  if(ky === 'geom') {
    chart_config[ky].forEach(function(geom) {
    var geom_obj = chart[geom.type]();
    Object.keys(geom)
      .filter(function(d) {return d !== 'type'})
      .forEach(function(geom_ky) {
        geom_obj[geom_ky](geom[geom_ky])
      })
    })
    return
  }

  if(ky === 'facet') {
    var facet_config = chart_config[ky][0]
    facet_config.eachView = function(view) {
      var geom = facet_config.geom
      var geom_obj = view[geom.type]();
      Object.keys(geom)
        .filter(function(d) {return d !== 'type'})
        .forEach(function(geom_ky) {
          geom_obj[geom_ky](geom[geom_ky])
        })
    }
    chart.facet(facet_config.type, facet_config)
    return
  }
})

chart.render()
"

# get a subset of diamonds for testing
data("diamonds", package="ggplot2")
dia <- diamonds[sample(seq_len(nrow(diamonds)),2000),]

g2_cht3 <- list(
  config = list(
    container = "mountNode",
    forceFit = TRUE,
    height = noquote("window.innerHeight"),
    padding = c(30,80,80,80)
  ),
  source = noquote("data"),# have to separate out the scale argument manually now,
  scale = list(
    carat = list(sync = TRUE),
    price = list(sync = TRUE, tickCount = 3),
    cut = list(sync = TRUE)
  ),
  facet = list(
    list(
      type = "rect",
      fields = c("cut", "clarity"),
      geom = list(
        type = "point",
        position = "carat*price",
        color = "cut",
        shape = "circle",
        opacity = 0.3,
        size = 3
      )
    )
  )
)

scr <- tags$script(HTML(
  sprintf(
    scr_template,
    jsonlite::toJSON(as.data.frame(dia), auto_unbox=TRUE, dataframe="rows"),
    jsonlite::toJSON(g2_cht3, auto_unbox=TRUE, pretty=TRUE)  
  )
))

browsable(
  tagList(
    dep_g2(),
    tags$div(id="mountNode"),
    scr
  )
)