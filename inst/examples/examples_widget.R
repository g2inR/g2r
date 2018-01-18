library(g2r)
library(magrittr)

# I only did point and path wrappers for now
#   in case we decide to pursue a different API

g2_chart(data = mtcars) %>%
  g2_point(
    position = "hp*mpg"
  )

g2_chart(data = mtcars) %>%
  g2_point(
    position = "hp*mpg"
  ) %>%
  g2_path(
    position = "hp*mpg"
  )

# g2_geom allows creation of any geom
g2_chart(data = data.frame(
  name = LETTERS[1:3],
  amount = floor(runif(3,10,20)),
  stringsAsFactors = FALSE
)) %>%
  g2_geom(
    type = "interval",
    position = "name*amount",
    color = "name"
  )

