# R-universe
usethis::edit_r_profile()

# Enable universe(s) by blaserlab
options(repos = c(
  blaserlab = 'https://blaserlab.r-universe.dev',
  CRAN = 'https://cloud.r-project.org'))

# load_process.R
# usethis::use_template("load_process.R", package = "blaseRtemplates", save_as = "R/load_process.R")

# dependencies
# load monocle3 and Seurat

# configs:
# add conflict_prefer("rowRanges", "MatrixGenerics")

# explore the objects
seq_qc
cds_list
cds_list[[1]]
colData(cds_list[[1]])
rowData(cds_list[[1]])
monocle3::exprs(cds_list[[1]])

ind_qc_res$chromium_controller[[1]]
ind_qc_res$chromium_controller[[2]]
ind_qc_res$chromium_controller[[3]]
ind_qc_res$chromium_controller[[4]]
ind_qc_res$chromium_controller[[5]]
ind_qc_res$chromium_controller[[6]]

doubletfinder_list

bb_cellmeta(cds_main_1)
bb_cellmeta(cds_main_2)
bb_cellmeta(cds_main_3)
bb_cellmeta(cds_main_4)
bb_cellmeta(cds_main_5)
bb_cellmeta(cds_main_6)
bb_cellmeta(cds_main_7)
bb_cellmeta(cds_main_8)
bb_cellmeta(cds_main_9)
bb_cellmeta(cds_main_10)
bb_cellmeta(cds_main_11)
bb_cellmeta(cds_main_12)
bb_cellmeta(cds_main_13)
bb_cellmeta(cds_main_14)
