# cds reduced dimensions
SingleCellExperiment::reducedDims(cds_main)$UMAP
SingleCellExperiment::reducedDims(cds_main)$PCA

# cds cell metadata
SingleCellExperiment::colData(cds_main)
blaseRtools::bb_cellmeta(cds_main)

monocle3::exprs(cds_main)

# Plotting a simple categorical variable
bb_var_umap(cds_main, "sample")

# highlight a value
bb_var_umap(cds_main,
            var = "leiden_assignment",
            value_to_highlight = "T/NK",
            cell_size = 2,
            foreground_alpha = 0.4)

# change the color
bb_var_umap(cds_main,
            var = "leiden_assignment",
            value_to_highlight = "T/NK",
            palette = "green4",
            cell_size = 2,
            foreground_alpha = 0.4)

# plot cell density in UMAP space
bb_var_umap(cds_main,
            var = "density",
            facet_by = "equipment",
            cell_size = 2,
            plot_title = "Local Cell Density")

# plot expression of a gene mapped to color
bb_gene_umap(cds_main,
             gene_or_genes = "CD3D")

# plot multiple genes
bb_gene_umap(cds_main, gene_or_genes = c("CD19", "CD3D", "CD14"))

# plot a group of genes (gene module)
agg_genes <-
  bb_rowmeta(cds_main) %>%
  select(id, module_labeled) %>%
  filter(module_labeled == "Module 1")


bb_gene_umap(cds_main,
             gene_or_genes = agg_genes)

# gene dotplots
# most efficient and "fair" way to show gene expression by group

bb_gene_dotplot(cds_main,
                markers = c("CD3E", "CD14", "CD19"),
                group_cells_by = "leiden_assignment")

# change the order of cells and/or genes
bb_gene_dotplot(cds_main,
                markers = c("CD3E", "CD14", "CD19"),
                group_cells_by = "leiden_assignment",
                gene_ordering = c("CD19", "CD14", "CD3E"),
                group_ordering = c("T/NK", "DC", "Mono", "B"))

# add another dimension to the plot
cell_groupings <-
  tribble(
    ~aesthetic,~variable, ~value, ~level,
    "facet","equipment", "chromium", 1,
    "facet","equipment", "X", 2,
    "axis", "leiden_assignment", "B", 1,
    "axis", "leiden_assignment", "T/NK", 2,
    "axis", "leiden_assignment", "DC", 3,
    "axis", "leiden_assignment", "Mono", 4
  )


bb_gene_dotplot(cds_main,
                markers = c("CD3E", "CD14", "CD19"),
                group_cells_by = "multifactorial",
                gene_ordering = c("CD19", "CD14", "CD3E"),
                group_ordering = cell_groupings)

# differential representation of cell clusters by another factor
bb_cluster_representation(cds = cds_main,
                          cluster_var = "leiden_assignment",
                          class_var = "equipment",
                          experimental_class = "X",
                          control_class = "chromium",
                          return_value = "plot")

# differential gene expression

# pseudobulk: good for getting l2fc
pseudosamples <-
  bb_cellmeta(cds_main) %>%
  group_by(sample, leiden_assignment) %>%
  summarise()
pseudosamples

pseudobulk_res <-
  bb_pseudobulk_mf(cds = cds_main,
                   pseudosample_table = pseudosamples,
                   design_formula = "~ leiden_assignment + batch",
                   result_recipe = c("leiden_assignment", "T/NK", "Mono"))
pseudobulk_res$Header
pseudobulk_res$Result |> arrange(padj)

# regression:  not as good but still possible
# use for looking at a handful of genes
regression_res <- bb_monocle_regression(cds = cds_main,
                                                 gene_or_genes = c("CD19", "CD3D", "CD14"),
                                                 form = "~leiden_assignment")
regression_res

