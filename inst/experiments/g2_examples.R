library(g2r)
library(htmltools)

# basic copy/paste to see if g2 is working
browsable(
  tagList(
    dep_g2(),
    tags$div(id="c1"),
    tags$script(HTML(
"
G2.track(false)

const data = [
{ genre: 'Sports', sold: 275 },
{ genre: 'Strategy', sold: 1150 },
{ genre: 'Action', sold: 120 },
{ genre: 'Shooter', sold: 350 },
{ genre: 'Other', sold: 150 },
];

const chart = new G2.Chart({
container: 'c1',
width: 500,
height: 500
});

chart.source(data);
chart.interval().position('genre*sold').color('genre');
chart.render();
"      
    ))
  )
)

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
})

chart.render()
"


g2cht1 <- list(
  config = list(
    container = "c1",
    forceFit = TRUE,
    height = 400 #noquote("window.innerHeight")
  ),
  source = noquote("data"),
  scale = list(
    value = list(min = 0),
    year = list(range = c(0,1))
  ),
  tooltip = list(
    crosshairs = list(type="line")
  ),
  geom = list(
    list(type = "line", position = "year*value"),
    list(
      type = "point",
      position = "year*value",
      size = 4,
      shape = "circle",
      style = list(
        stroke = "#fff",
        lineWidth = 1
      )
    )
  )
)

scr <- tags$script(HTML(
  sprintf(
    scr_template
    ,
    "[
    { year: '1991', value: 3 },
    { year: '1992', value: 4 },
    { year: '1993', value: 3.5 },
    { year: '1994', value: 5 },
    { year: '1995', value: 4.9 },
    { year: '1996', value: 6 },
    { year: '1997', value: 7 },
    { year: '1998', value: 9 },
    { year: '1999', value: 13 }
    ]",
    jsonlite::toJSON(g2cht1, auto_unbox=TRUE, pretty=TRUE)  
  )
))

browsable(
  tagList(
    dep_g2(),
    tags$div(id="c1"),
    scr
  )
)


g2_cht2 <- list(
  config = list(
    container = "mountNode",
    forceFit = TRUE,
    height = noquote("window.innerHeight")
  ),
  source = noquote("dv"),# have to separate out the scale argument manually now,
  scale = list(
    month = list(range = c(0,1))
  ),
  tooltip = list(
    crosshairs = list(type="line")
  ),
  axis = list(
    temperature = list(
      label = list(
        formatter = noquote("val => {return val + '°C'}")
      )
    )
  ),
  geom = list(
    list(
      type = "line",
      position = "month*temperature",
      color = "city"
    ),
    list(
      type = "point",
      position = "month*temperature",
      color = "city",
      size = 4,
      shape = "circle",
      style = list(
        stroke = "#fff",
        lineWidth = 1
      )
    )
  )
)

scr <- tags$script(HTML(
  sprintf(
    scr_template
    ,
    "
    [
    { month: 'Jan', Tokyo: 7.0, London: 3.9 },
    { month: 'Feb', Tokyo: 6.9, London: 4.2 },
    { month: 'Mar', Tokyo: 9.5, London: 5.7 },
    { month: 'Apr', Tokyo: 14.5, London: 8.5 },
    { month: 'May', Tokyo: 18.4, London: 11.9 },
    { month: 'Jun', Tokyo: 21.5, London: 15.2 },
    { month: 'Jul', Tokyo: 25.2, London: 17.0 },
    { month: 'Aug', Tokyo: 26.5, London: 16.6 },
    { month: 'Sep', Tokyo: 23.3, London: 14.2 },
    { month: 'Oct', Tokyo: 18.3, London: 10.3 },
    { month: 'Nov', Tokyo: 13.9, London: 6.6 },
    { month: 'Dec', Tokyo: 9.6, London: 4.8 }
    ];
    var ds = new DataSet();
    var dv = ds.createView().source(data);
    dv.transform({
    type: 'fold',
    fields: [ 'Tokyo', 'London' ], // 展开字段集
    key: 'city', // key字段
    value: 'temperature', // value字段
    });
    ",
    jsonlite::toJSON(g2_cht2, auto_unbox=TRUE, pretty=TRUE)  
  )
))

# looks data-set is not compatible with RStudio Viewer
browsable(
  tagList(
    dep_g2(),
    dep_dataset(),
    tags$div(id="mountNode"),
    scr
  )
)
