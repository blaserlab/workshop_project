# edit your "byline" in .Rprofile
usethis::edit_r_profile()
# # Initialize a new package
#
blaseRtemplates::initialize_package(path = "~/r_projects/workshop.project.datapkg")
#
#
# Install the package into a hidden environment
# Only loaded into memory when called.
blaseRtemplates::bb_renv_datapkg("C://Users//blas02//r_projects//datapkg//workshop.project.datapkg")

# blaseRtemplates::easy_install("lazyData", "new_or_update")
lazyData::requireData("workshop.project.datapkg")

analysis_configs
cds_main
system.file("data-raw/load_process.R", package = "workshop.project.datapkg")
