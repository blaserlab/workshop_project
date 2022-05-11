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
bb_cellmeta(cds_main_5) |> glimpse()
bb_var_umap(cds_main_5, "doubletfinder_low_conf", value_to_highlight = "Doublet", cell_size = 2)
bb_cellmeta(cds_main_6)
bb_cellmeta(cds_main_7) |> glimpse()
bb_cellmeta(cds_main_8)
bb_cellmeta(cds_main_9) |> glimpse()
bb_cellmeta(cds_main_10) |> glimpse()
bb_cellmeta(cds_main_11)
bb_cellmeta(cds_main_12) |> glimpse()
bb_rowmeta(cds_main_13) |> glimpse()
bb_cellmeta(cds_main_14) |> glimpse()

# cell assignments
bb_var_umap(cds_main, var = "partition", plot_title = "Partitions")
bb_var_umap(cds_main, var = "leiden", plot_title = "Leiden Clusters")
bb_var_umap(cds_main, var = "louvain", plot_title = "Louvain Clusters")

leiden_seurat <- bb_cellmeta(cds_main) %>%
  group_by(leiden, seurat_celltype_l1) %>%
  summarise(n = n())
leiden_seurat

ggplot(leiden_seurat,
       mapping = aes(x = leiden,
                     y = n,
                     fill = seurat_celltype_l1)) +
  geom_bar(position="fill", stat="identity") +
  scale_fill_brewer(palette = "Set1")

# Recode the leiden clusters with our cell assignments
colData(cds_main)$leiden_assignment <- recode(colData(cds_main)$leiden,
                                                  "1" = "T/NK",
                                                  "2" = "Mono",
                                                  "3" = "B",
                                                  "4" = "DC")
bb_var_umap(cds_main, var = "leiden_assignment")
bb_cellmeta(cds_main) |> glimpse()
