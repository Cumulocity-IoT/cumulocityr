# utility functions

.get_env <- function(the_var) {
  # get value of environment variable, throw error if not found.
  result <- Sys.getenv(the_var)
  if (result=="")
    stop(paste0(c("env var '", the_var, "' not found."), collapse = ""))
}
