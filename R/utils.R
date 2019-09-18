# utility functions

.get_env <- function(the_var) {
  # get value of environment variable, throw error if not found.
  result <- Sys.getenv(the_var)
  if (result=="") {
    stop(paste0(c("env var '", the_var, "' not found."), collapse = ""))
  }
  return(result)
}

.get_cumulocity_base_url <- function() {.get_env("CUMULOCITY_base_url")}

.get_cumulocity_usr <- function() {.get_env("CUMULOCITY_usr")}

.get_cumulocity_pwd <- function() {.get_env("CUMULOCITY_pwd")}



