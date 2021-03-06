\name{transform_smooth}
\alias{branch_smooth}
\alias{transform_smooth}
\title{Transformation: smooth the data}
\usage{
transform_smooth(..., method = guess(), formula = guess(), se = TRUE,
  level = 0.95, n = 80L, na.rm = FALSE)

branch_smooth(..., se = TRUE)
}
\arguments{
  \item{method}{Model fitting function to use - it must
  support R's standard modelling interface, taking a
  formula and data frame as input, and returning
  predictions with \code{\link{predict}}. If not supplied,
  will use \code{\link{loess}} for <= 1000 points,
  otherwise it will use \code{\link[mgcv]{gam}}. Other
  modelling functions that will work include
  \code{\link{lm}}, \code{\link{glm}} and
  \code{\link[MASS]{rlm}}}

  \item{formula}{Formula passed to modelling function. Can
  only use \code{y} and \code{x} variables.  If not
  specified, defaults to \code{y ~ s(x)} for \code{method =
  gam}, \code{y ~ x} otherwise.}

  \item{se}{include standard errors in output? Requires
  approprate method of \code{predictdf}, since the
  interface for returning predictions with standard errors
  is not consistent acrossing modelling frameworks.}

  \item{level}{the confidence level of the standard
  errors.}

  \item{n}{the number of grid points to use in the
  prediction}

  \item{na.rm}{If \code{TRUE} missing values will be
  silently removed, otherwise they will be removed with a
  warning.}

  \item{...}{Named arguments for model function, unnamed
  arguments will be dropped.}

  \item{...}{Named arguments are passed on to the
  transform, unnamed arguments are passed on to the
  branch.}
}
\description{
\code{transform_smooth} is a data transformation that fits
a model to a 2d dataset and computes predictions and
standard errors. \code{branch_smooth} combines
\code{transform_smooth} with \code{mark_line} and
\code{mark_area} to display a smooth line and its standard
errror.
}
\section{Input}{
  Currently \code{transform_smooth} only works with data
  frames and requires the following properties:

  \itemize{ \item \code{x}, numeric, horizontal position
  \item \code{y}, numeric, vertical position }
}

\section{Ouput}{
  \code{transform_smooth} creates a data frame with
  columns:

  \itemize{ \item \code{x}: regularly spaced grid of
  \code{n} locations \item \code{y}: predicted value from
  smooth }

  If standard errors are requested, it will also contain:

  \itemize{ \item \code{y_lower__} and \code{y_upper__}:
  upper and lower bounds of confidence interval \item
  \code{se__}: the standard error (width of the confidence
  interval) }
}
\examples{
ggvis(mtcars, props(x = ~wt, y = ~mpg), mark_symbol(), branch_smooth())
ggvis(mtcars, props(x = ~wt, y = ~mpg), mark_symbol(),
  branch_smooth(method = "lm", se = FALSE))

# These are equivalent to combining transform_smooth with mark_line and
# mark_area
ggvis(mtcars, props(x = ~wt, y = ~mpg),
  mark_symbol(),
  branch(transform_smooth(),
    mark_area(props(x = ~x, y = ~y_lower__, y2 = ~y_upper__,
      fillOpacity := 0.2)),
    mark_line(props(x = ~x, y = ~y))
  )
)

# You can also combine other data transformations like splitting
ggvis(mtcars, props(x = ~wt, y = ~mpg, stroke = ~cyl), by_group(cyl),
   branch_smooth(method = "lm"))

# You can see the results of a transformation by creating your own pipeline
# and sluicing data through it
sluice(pipeline(mtcars, transform_smooth(n = 5L)),
  props(x = ~disp, y = ~mpg))
}

