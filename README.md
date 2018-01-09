Experiments with R and g2 - this is nowhere near a full-featured `htmlwidget`.  I'll start with hacks and sketches to understand the `g2` API and hopefully determine the best way to structure an `R` API for chart creation.

# g2

The new [g2](https://github.com/antvis/g2) is just too good to not integrate into `R`.  Leland Wilkinson's Grammar of Graphics inspired both `ggplot2` and `g2` so hopefully many of the concepts will translate nicely.

### Facets

Good facetting is what really separates `g2` from nearly all other `JavaScript` visualization libraries.  Definitely have a look at the facetting [examples](https://antv.alipay.com/zh-cn/g2/3.x/demo/index.html#_%E5%88%86%E9%9D%A2).
