
# conflicts ---------------------------------------------------------------
# resolve conflicting function names here

conflict_prefer("filter", "dplyr")
conflict_prefer("lag", "dplyr")
conflict_prefer("select", "dplyr")
conflict_prefer("rename", "dplyr")
conflict_prefer("count", "dplyr")


# analysis configurations -------------------------------------------------
# use this section to set graphical themes, color palettes, etc.

# experimental_group_palette <- c("group1" = "red4", "group2" = "blue3")


# source local configs ----------------------------------------------------
# these are sourced after main configs and will overwrite duplicate entries if
# present. The file local_configs.R is ignored by git and so is useful for user-
# specific configurations such as output directories or formatting.

fs::file_create("R/local_configs.R") # will not overwrite

source("R/local_configs.R")
