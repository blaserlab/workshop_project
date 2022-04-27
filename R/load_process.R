# this is a general template for loading and processing 10X scrnaseq data
# modify as necessary

# read in the config file -------------------------------------------------
analysis_configs <- read_csv("X://Labs//Blaser//staff//single_cell//vignettes//scRNAseq_vignette//vignette_config.csv", col_types = "cccc")

# generate sequencing qc table --------------------------------------------
seq_qc <- map_dfr(.x = analysis_configs$sample,
                  .f = \(x, data = analysis_configs) {
                    pipestance <- data |>
                      filter(sample == x) |>
                      pull(pipestance_path)
                    read_csv(
                      list.files(
                        path = pipestance,
                        pattern = "metrics_summary.csv",
                        recursive = TRUE,
                        full.names = T
                      )
                    ) |>
                      select(
                        c(
                          "Estimated Number of Cells",
                          "Mean Reads per Cell",
                          "Median Genes per Cell",
                          "Fraction Reads in Cells"
                        )
                      ) |>
                      mutate(sample = x) |>
                      relocate(sample) |>
                      mutate(`Fraction Reads in Cells` =
                               as.numeric(str_remove_all(`Fraction Reads in Cells`,
                                                         "[:punct:]")) / 1000)

                  })

# Generate a list of CDS objects using purrr::map ------------------------
cds_list <- map(.x = analysis_configs$sample,
                .f = \(x, conf = analysis_configs) {
                  conf_filtered <- conf |>
                    filter(sample == x)
                  targz <- list.files(
                    conf_filtered$pipestance_path,
                    pattern = "filtered_feature_bc_matrix.tar.gz",
                    recursive = T,
                    full.names = T
                  )
                  cds <- bb_load_tenx_targz(targz_file = targz,
                                            sample_metadata_tbl = conf_filtered |>
                                              select(-c(sample, pipestance_path)))
                  if ("Antibody Capture" %in% bb_rowmeta(cds)$data_type) {
                    cds <- bb_split_citeseq(cds)
                  }
                  return(cds)
                }) %>%
  set_names(nm = analysis_configs$sample)


# generate a list of qc results for individual CDS objects ---------------
ind_qc_res <- pmap(.l = list(
  cds = cds_list,
  cds_name = names(cds_list),
  genome = rep("human", times = length(cds_list))
),
.f = bb_qc) %>%
  set_names(nm = names(cds_list))


# gets the number of cells in each cds and divides it by 100000 ---------
anticipated_doublet_rate <- unlist(map(cds_list, ncol)) / 100000

# extracts the first element of the qc result list for each cds ---------
qc_calls <- map(ind_qc_res, 1)

# generates a list of tables with doubletfinder results -----------------
doubletfinder_list <-
  pmap(
    .l = list(
      cds = cds_list,
      doublet_prediction = anticipated_doublet_rate,
      qc_table = qc_calls
    ),
    .f = bb_doubletfinder
  ) %>%
  set_names(names(cds_list))


# rejoins doubletfinder and qc data onto the list of CDS objects -------
cds_list_rejoined <- pmap(
  .l = list(
    cds = cds_list,
    qc_data = qc_calls,
    doubletfinder_data = doubletfinder_list
  ),
  .f = bb_rejoin
)

# Merge the CDS list into a single CDS ---------------------------------
cds_main_1 <- monocle3::combine_cds(cds_list = cds_list_rejoined)

# Remove mitochondrial and ribosomal genes. ----------------------------
cds_main_2 <-
  cds_main_1[rowData(cds_main_1)$gene_short_name %notin%
             blaseRdata::hg38_remove_genes, ]

# Remove the low-quality cells ----------------------------------------
cds_main_3 <- cds_main_2[, colData(cds_main_2)$qc.any == FALSE]


# Uncomment and run the following section if you want to preview the CDS
# before removing predicted doublets and aligning.

# option to preview cds ---------------------------------------------------
# Calculate the PCA dimensions
cds_main_4 <- preprocess_cds(cds_main_3,
                           use_genes = bb_rowmeta(cds_main_3) |>
                             filter(data_type == "Gene Expression") |>
                             pull(id))
# Calculate UMAP dimensions
cds_main_5 <- reduce_dimension(cds_main_4, cores = 40)


# Remove the high-confidence doublets ------------------------------------
cds_main_6 <-
  cds_main_5[, colData(cds_main_5)$doubletfinder_high_conf == "Singlet"]

# Remove the qc and doubletfinder columns from the cell metadata --------
cds_main_7 <- cds_main_6
colData(cds_main_7)$qc.any <- NULL
colData(cds_main_7)$doubletfinder_low_conf <- NULL
colData(cds_main_7)$doubletfinder_high_conf <- NULL

# Calculate the PCA dimensions ------------------------------------------
cds_main_8 <- preprocess_cds(cds_main_7,
                           use_genes = bb_rowmeta(cds_main_7) |>
                             filter(data_type == "Gene Expression") |>
                             pull(id))
# Calculate UMAP dimensions ---------------------------------------------
cds_main_9 <- reduce_dimension(cds_main_8, cores = 40)

# align by batch --------------------------------------------------------
# edit the align_by parameter accordingly
cds_main_10 <- bb_align(cds_main_9, align_by = "sample")

# Identify clusters and calculate top markers ---------------------------
cds_main_11 <- cds_main_10
dir.create("data")
cds_main_12 <-
  bb_triplecluster(
    cds_main_11,
    n_top_markers = 50,
    outfile = "data/cds_main_top_markers.csv",
    n_cores = 8
  )
cds_main_top_markers <- read_csv("data/cds_main_top_markers.csv")

# Identify gene modules and add them to the gene metadata. ---------------
cds_main_13 <- bb_gene_modules(cds_main_12, n_cores = 24)

# align to seurat reference ---------------------------------------------
# NB:  human PBMC only
cds_main_14<-
  bb_seurat_anno(
    cds_main_13,
    reference = system.file("extdata", "pbmc_multimodal.h5seurat",
                            package = "blaseRextras")
  )

# save the objects -------------------------------------------------------
save(analysis_configs, file = "data/analysis_configs.rda", compress = "bzip2")
save(cds_main_14, file = "data/cds_main.rda", compress = "bzip2")
save(cds_main_top_markers, file = "data/cds_main_top_markers.rda", compress = "bzip2")
save(seq_qc, file = "data/seq_qc.rda", compress = "bzip2")
save(ind_qc_res, file = "data/ind_qc_res.rda", compress = "bzip2")
