#' @export
g2_geom <- function(
  g2 = NULL,
  #type: {string}, // 声明 geom 的类型：point line path area interval polygon schema edge heatmap pointStack pointJitter pointDodge intervalStack intervalDodge intervalSymmetric areaStack schemaDodge
  type = c("point", "line", "path", "area", "interval", "polygon", "schema", "edge", "heatmap", "pointStack", "pointJitter", "pointDodge", "intervalStack", "intervalDodge", "intervalSymmetric", "areaStack", "schemaDodge"),
  #adjust: {string} | {array}, // 数据调整方式声明，如果只有一种调整方式，可以直接声明字符串，如果有多种混合方式，则以数组格式传入
  #position: {string} | {object}, // potision 图形属性配置
  position = NULL,
  #color: {string} | {object}, // color 图形属性配置
  color = NULL,
  #shape: {string} | {object}, // shape 图形属性配置
  shape = NULL,
  #size: {string} | {object}, // size 图形属性配置
  size = NULL,
  #opacity: {string} | {object}, // opacity 图形属性配置
  opacity = NULL,
  #label: {string} | {object}, // 图形上文本标记的配置
  label = NULL,
  #tooltip: {string}, // 配置 tooltip 上显示的字段名称
  tooltip = NULL,
  #style: {object}, // 图形的样式属性配置
  style = NULL,
  #active: {boolean}, // 开启关闭 geom active 交互
  active = NULL
  #select: {object}, // geom 选中交互配置
  #animate: {object} // 动画配置
) {
  geom <- list(
    type = type,
    position = position,
    color = color,
    shape = shape,
    size = size,
    opacity = opacity,
    label = label,
    tooltip = tooltip,
    style = style,
    active = active
  )
  
  if(is.null(g2$x$options$geoms)) {
    g2$x$options$geoms <- list()
  }
  
  n <- length(g2$x$options$geoms)
  g2$x$options$geoms[[n+1]] <- Filter(Negate(is.null),geom)
  
  return(g2)
}

#' @export
g2_point <- function(g2 = NULL, ...) {
  if(is.null(g2)) {
    stop("no g2 provided", call. = FALSE)
  }
  
  g2_geom(g2, type = "point", ...)
}

#' @export
g2_line <- function(g2 = NULL, ...) {
  if(is.null(g2)) {
    stop("no g2 provided", call. = FALSE)
  }
  
  g2_geom(g2, type = "line", ...)
}

#' @export
g2_path <- function(g2 = NULL, ...) {
  if(is.null(g2)) {
    stop("no g2 provided", call. = FALSE)
  }
  
  g2_geom(g2, type = "path", ...)
}