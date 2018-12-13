install.packages("lazyeval")
library(lazyeval)
# Document
# NOT RUN {
# Interp works with formulas, lazy objects, quoted calls and strings
interp(~ x + y, x = 10) # ~10 + y
interp(lazy(x + y), x = 10) # 10 + y
interp(quote(x + y), x = 10) # 10 + y
interp("x + y", x = 10) # "10 + y"

# Use as.name if you have a character string that gives a
# variable name
interp(~ mean(var), var = as.name("mpg")) # ~mean(mpg)
# or supply the quoted name directly
interp(~ mean(var), var = quote(mpg)) # ~mean(mpg)

# Or a function!
interp(~ f(a, b), f = as.name("+")) # ~a + b
# Remember every action in R is a function call:
# http://adv-r.had.co.nz/Functions.html#all-calls

# If you've built up a list of values through some other
# mechanism, use .values
interp(~ x + y, .values = list(x = 10)) # ~10 + y

# You can also interpolate variables defined in the current
# environment, but this is a little risky.
y <- 10
interp(~ x + y, .values = environment())
# }

# When you want to use a character string (e.g. "v1") as a variable name, you just:
# 1. Convert the string to a symbol using sym() from the rlang package
# 2. In your function call, write !! in front of the symbol
## book_breakingther2_3(examples)에서 사용
my_var <- "Sepal.Length"
my_sym <- sym(my_var)
summarize(iris, Mean = mean(!!my_sym))
