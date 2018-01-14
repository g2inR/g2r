library(htmltools)
library(reactR)
library(g2r)

browsable(
  tagList(
    dep_corejs(),
    html_dependency_react(),
    dep_bizcharts(),
    tags$div(id="mountNode"),
    tags$script(HTML(babel_transform(
"
G2.track(false)

const { Chart, Axis, Geom, Tooltip, Facet, View, Legend } = window.BizCharts;

const data = [
  { year: '1951', sales: 38 },
  { year: '1952', sales: 52 },
  { year: '1956', sales: 61 },
  { year: '1957', sales: 145 },
  { year: '1958', sales: 48 },
  { year: '1959', sales: 38 },
  { year: '1960', sales: 38 },
  { year: '1962', sales: 38 },
];

const cols = {
  'sales': {tickInterval: 20},
};

ReactDOM.render((
    <Chart height={400} data={data} scale={cols} forceFit>
    <Axis name='year' />
    <Axis name='sales' />
    <Tooltip crosshairs={{type : 'y'}}/>
    <Geom type='interval' position='year*sales' />
    </Chart>
  ),
  document.getElementById('mountNode')
);
"      
    )))
  )
)

# devtools::install_github("timelyportfolio/htmltools")
el <- tag(
  "Chart",
  list(
    height = noquote("{400}"),
    data = noquote("{data}"),
    scales = noquote("{cols}"),
    forceFit = NA,
    tag("Axis", list(name = "year")),
    tag("Axis", list(name = "sales")),
    tag("Tooltip", list(crosshairs = noquote("{{type: 'y'}}"))),
    tag("Geom", list(type = "interval", position = "year*sales"))
  )
)

browsable(
  tagList(
    html_dependency_react(),
    dep_bizcharts(),
    tags$div(id="mountNode"),
    tags$script(HTML(babel_transform(
sprintf(
"
G2.track(false)

const { Chart, Axis, Geom, Tooltip, Facet, View, Legend } = window.BizCharts;

const data = [
  { year: '1951', sales: 38 },
  { year: '1952', sales: 52 },
  { year: '1956', sales: 61 },
  { year: '1957', sales: 145 },
  { year: '1958', sales: 48 },
  { year: '1959', sales: 38 },
  { year: '1960', sales: 38 },
  { year: '1962', sales: 38 },
];

const cols = {
  'sales': {tickInterval: 20},
};

ReactDOM.render(
  %s,
  document.getElementById('mountNode')
)
",
  el
)
    )))
  )
)