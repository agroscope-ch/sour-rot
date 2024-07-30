source("Load_preprocess_sour_rot.R")
#
library(vegan)

lsSourRot <- LoadSourRot(normalization = FALSE)
dfSourRot <- lsSourRot$dfSourRot
vars <- lsSourRot$vars
types <- lsSourRot$types

rm(lsSourRot)

## selecting the level of accuracy on which we want to work

## possibles arguments are (from coarsest to finest)
# "order", "family", "genus", "species"
level.work <- "species"


dfSourRotDiversity <- dfSourRot[,c(level.work, vars)] |> 
  group_by(pick({{level.work}})) |> 
  dplyr::summarise(across(.cols = {{vars}}, .fns = ~ sum(.x, na.rm = TRUE)))


# names.sample <- names(dfSourRotDiversity)[-1]
# target <- dfSourRotDiversity[[level.work]]
# 
# df.temp <- dfSourRotDiversity[,-1] |> as.matrix() |> t() |> as.data.frame()
# names(df.temp) <- dfSourRotDiversity$target

df <- dfSourRotDiversity[,-1] |>
  t() |> ### Community data matrix: x with samples as rows and species as column for vegan documentation
  vegan::decostand(method =  "hellinger") |> #### normalization/standardization step
  vegan::vegdist(method = "bray", binary = FALSE) |> #### choice of the beta diversity index.
  as.matrix()
#
# 

# Creates a matrix with all combination of two elements among nr elements + 
# couples of identical indices, so that indices.unique.types has 
# choose(nr, 2) + nr rows
nr <- length(unique(types))
z <- sequence(nr)
indices.unique.types <- cbind(
  row = unlist(lapply(2:nr, function(x) x:nr), use.names = FALSE),
  col = rep(z[-length(z)], times = rev(tail(z, -1))-1))
indices.unique.types <- rbind(indices.unique.types,
                              rep(which(unique(types) == "insect"),2),
                              rep(which(unique(types) == "sour rot"),2),
                              rep(which(unique(types) == "extern"),2))
select.categories <- apply(indices.unique.types, c(2,1),function(z)unique(types)[z]) |> t()



df <-  reshape2::melt(data = df, varnames = c("sample_1", "sample_2")) |> 
  filter(sample_1 != sample_2) |> 
  # distinct() |> # removes the duplicates, as just explained
  left_join(x = _, y = data.frame(samp =vars, type = types), by = c("sample_1" = "samp")) |> 
  left_join(x = _, y = data.frame(samp =vars, type = types), by = c("sample_2" = "samp")) |> 
  rowwise() |>
  mutate(interaction =factor( paste(type.x, type.y, sep = "-")))
df_plot <- data.frame()
for(i in 1:nrow(select.categories))
{
  df_plot <- rbind(df_plot,
                   df |> filter(type.x == select.categories[i, 1] & type.y == select.categories[i, 2]))
}

ggplot(df_plot, aes(x = interaction, y  = value, fill  = interaction)) +
  geom_violin()+ 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
ggsave("Figures/comparisons_distr_beta_diversity_violin.pdf")
ggplot(df_plot, aes(x = interaction, y  = value, fill  = interaction)) +
  geom_boxplot()+ 
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))
ggsave("Figures/comparisons_distr_beta_diversity_boxplot.pdf")
ggplot(df_plot, aes(x  = value, col  = interaction)) +
  geom_density()
ggsave("Figures/comparisons_distr_beta_diversity_densities.pdf")



# need to remove values that are identical up to permutation
# i.e. beta(G11C1, G11C2) = beta(G11C2, G11C1) so we need to remove the duplicates
# we proceed in 2 steps
# 1. for each rwo, we sort the first two columns in an arbitrary order
# 2. we remove the duplicates, 

## Checks that the results is as expected: we compare the obtained object 
## after sorting the first two columns and the original one.
k <- apply(df[,1:2], MARGIN = 1, function(z) sort(z)) |> t() |> as.data.frame()  |> 
  cbind(df[,1:2])
apply(k,1,function(z)base::setequal(x = z[1:2], y = z[3:4]) ) ##

df[,1:2] <- apply(df[,1:2], MARGIN = 1, function(z) sort(z)) |> t() |> as.data.frame()

df <- df |> 
  # distinct() |> # removes the duplicates, as just explained
  left_join(x = _, y = data.frame(samp =names.sample, type = types), by = c("sample_1" = "samp")) |> 
  left_join(x = _, y = data.frame(samp =names.sample, type = types), by = c("sample_2" = "samp")) |> 
  rowwise() |>
  mutate(interaction =factor( paste(type.x, type.y, sep = "-")),
         type.x = NULL, type.y =NULL)


# 
# 
# df <- reshape2::melt(vegdist(decostand(dfSourRotDiversity[,-1] |> t(), "hellinger"), "bray", binary = FALSE) |> 
#                        as.matrix(), 


#                      varnames = c("row", "col"))

# 
# 
# 
# dfSourRotDiversity <- df.temp |> mutate(type = types) |> 
#   group_by(type) |> 
#   summarise(across(everything(),  ~ mean(.x, na.rm = TRUE))) |> 
#   as.data.frame()
# rm(df.temp)
# row.names(dfSourRotDiversity) <- dfSourRotDiversity[,1]
# dfSourRotDiversity <- dfSourRotDiversity[,-1]



vegdist(decostand(dfSourRotDiversity[,-1] |> t(), "hellinger"), "bray", binary = FALSE)

groups <- expand.grid(unique(types), unique(types)) |> unique()


ns <- table(types)


# rows <- ns[indices.unique.types[i,1]]
# columns <- ns[indices.unique.types[i,2]]
combinations <- list()
for(i in 1:nrow(indices.unique.types))
{
  combinations[[i]] <- list()
  combinations[[i]]$comb <- unique(types)[indices.unique.types[i,]]
  combinations[[i]]$el <- cbind(expand.grid(x = names.sample[types == unique(types)[indices.unique.types[i,1]]],
                                    y = names.sample[types == unique(types)[indices.unique.types[i,2]]]), 
                                crossing = paste0( unique(types)[indices.unique.types[i,]], collapse = "-"))
}

lapply(combinations, function(z) z$el )
vegdist(decostand(dfSourRotDiversity[,-1], "hellinger"), "bray", binary = FALSE)
