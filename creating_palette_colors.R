### We merge the two datasets used in Figure 1-7 to use a single color for each species/genus disregarding the Figure
df_col <-  dfExp1 |>
  select(Genus, Order) |>
  mutate(Exp = 1) |> 
  distinct() |> 
  bind_rows(dfExp2 |> select(Genus, Order) |> distinct() |>   mutate(Exp = -1)) |> 
  group_by(Genus, Order) |> 
  # the variable overlap allows to identify if the species appears Table S1 (1), Table S2 (-1) or both (0)
  reframe(Genus = Genus, Order = Order, Overlap = sum(Exp)) |> 
  distinct() 

# We use 3 distinct palette:
# Greens for Saccharomycotina, that are usually associated with Sour rot
# Reds for Bacteria
# the Cividis palette, ranging from blue to yellow for the other fungi
# We arrange the first by type (bacteria, Other and Saccharomycotina) and within
# each type, by alphabetical order of the Genera

df_col <- df_col |> mutate(type = case_when(
  Order %in% c("Rhodospirillales" , "Enterobacterales", "Xanthomonadales", "Bacillales")~ "Bacteria",
  Order %in% c("Ascoideales", "Pichiales","Dipodascales", "Saccharomycodales", "Serinales", "Phaffomycetales" )~ "Saccharomycotina",
  .default = "Non-Saccharomycotina"
)) |> 
  arrange(type, Genus, desc(is.na(Order))) |> 
  mutate(type = factor(type, levels = unique(type)), Genus = factor(Genus, levels = unique(Genus)), Order = factor(Order, levels = unique(Order)))
# Assignment of a color to each genera
cat_col <- table(df_col$type)
df_col$ColName <- NA
df_col$ColName[df_col$type == "Non-Saccharomycotina"] <- colorspace::divergingx_hcl(n =cat_col["Non-Saccharomycotina"],palette = "Cividis")
df_col$ColName[df_col$type == "Bacteria"] <- colorspace::sequential_hcl(n =(cat_col["Bacteria"]) + 1,palette = "OrRd")[1:cat_col["Bacteria"]]
df_col$ColName[df_col$type == "Saccharomycotina"] <- colorspace::sequential_hcl(n =(cat_col["Saccharomycotina"]) + 2,palette = "Greens")[1:cat_col["Saccharomycotina"]]

# Assigning the color of one species of the order to the corresponding order
# So that the colorscale of the order is also a subset with similar colors than the species;
# The "gap" between colors of the order are proportional to the number of species of this
# order observed in the study
df_col <- df_col |> mutate(rank = 1:nrow(df_col)) |> group_by(Order) |> 
  reframe(ColOrder = ColName[which.min(rank)], Genus) |> ungroup() |> 
  left_join(df_col, y=_, by = c("Genus", "Order"))
df_col$ColOrder[which(is.na(df_col$Order))] <- "#000000"

df_col <- df_col |> mutate(rank = 1:nrow(df_col)) |> group_by(type) |> 
  reframe(Coltype = ColName[which.min(rank)+2], Genus) |> ungroup() |> 
  left_join(df_col, y=_, by = c("Genus", "type"))

## showing colors of Species
myPalette <- df_col$ColName
names(myPalette) <- df_col$Genus
colorKey = data.frame(colorName=names(myPalette))
ggplot(data=colorKey, aes(x=1, y = nrow(colorKey):1, fill=colorName, label=colorName)) +
  geom_tile(width = 0.1) +
  scale_fill_manual("Genera" , values = myPalette, breaks = names(myPalette)) +
  theme_void()+
  geom_text()


## showing colors of Order
df_order <- df_col |> select(Order, ColOrder) |> distinct()
myPalette <- df_order$ColOrder
names(myPalette) <- df_order$Order
colorKey = data.frame(colorName=names(myPalette))
ggplot(data=colorKey, aes(x=1, y = nrow(colorKey):1, fill=colorName, label=colorName)) +
  geom_tile(width = 0.1) +
  scale_fill_manual("Genera" , values = myPalette, breaks = names(myPalette), na.value="black") +
  theme_void()+
  geom_text()

## showing colors of type
df_type <- df_col |> select(type, Coltype) |> distinct()
myPalette <- df_type$Coltype
names(myPalette) <- df_type$type
colorKey = data.frame(colorName=names(myPalette))
ggplot(data=colorKey, aes(x=1, y = nrow(colorKey):1, fill=colorName, label=colorName)) +
  geom_tile(width = 0.1) +
  scale_fill_manual("Genera" , values = myPalette, breaks = names(myPalette)) +
  theme_void()+
  geom_text()

rm(df_order, df_type, myPalette, colorKey)

## Creating a table to check the correspondance between original names of
## the species, genera and order that are then used in the figures.
a <- dfExp1 |> select(Species, Order, Family, Genus) |> distinct()
b <- dfExp2 |> select(Species, Order, Family, Genus) |> distinct()
write_flag = FALSE
if(write_flag)
{
  bind_rows(a,b) |> 
    select(-Family)|>  
    distinct() |> 
    select(Species, Genus, Order) |>
    write.table(file = "check_names.csv", quote = FALSE, row.names = FALSE, col.names = TRUE, sep = ";")
}
rm(a,b)
