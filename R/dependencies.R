
# renv --------------------------------------------------------------------

# set up the renv from scratch

# renv::init(bioconductor = TRUE)

# restore the renv from the lockfile

# renv::restore(clean = TRUE)



# package installation ----------------------------------------------------

# # Try this first...it's faster:
# blaseRtemplates::easy_install("<package name>", how = "link_from_cache")

# # If you need a new package or an update, try this:
# blaseRtemplates::easy_install("<package name>", how = "new_or_update")

# # If you are installing from a "tarball", use this:
# blaseRtemplates::easy_install("/path/to/tarball.tar.gz")

# # use "bioc::<package name>" for bioconductor packages
# # use "<repo/package name>" for github source packages

# load and attach packages ------------------------------------------------

library("blaseRtemplates")
library("conflicted")
library("tidyverse")
library("gert")

# install and load data package if using ----------------------------------------------

#
# blaseRtemplates::bb_renv_datapkg(path = "<path to data package directory>")
# lazyData::requireData("<data package name>")
#
