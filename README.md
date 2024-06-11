# Sour Rot

Fungal communities were studied in 4 different environments:
- Drosophila, vectors of the disease;
- The skin of healthy grape berries;
- The inside of healthy grape berries
- berries affected by the disease (i.e., with indistinguishable exteriors and interiors).

The aim is to see if there are any differences in terms of fungal community. We have discarded the data of the inside of healthy berries as there was just a very few fungi inside. 

For each observation (i.e. a healthy or infected berry or a _Drosophila_) $`\mathbf{x}_i,\quad i = 1,\dots,n`$, we observe a certain number of different fungi. In concrete terms, let $`p`$ be the number of different fungi observed in all samples, and let $`x_{ik}`$ be the number of occurrences of fungus $`k, \quad k = 1,\dots,p`$ in sample $`i`$. The design matrix $`\mathbf{X}`$ with generic entries $`x_{ik}`$ is the data set provided in the file [Missing link]()

## Data description

The dataset contains 124 samples, distributed as follows :

- each insect harvest (1 to 6 ) for the 3 insect types (male, female, other)
- each berry harvested (1 to 8 ) for each cluster
    - The outside of 5 healthy bunches (G11Cx, G12Cx, G13Cx, G14Cx, G15Cx), x being the berry (8 berries in total)
    - 8 bunches infected with acid rot (G4Bx, G5Bx, G8Bx, G9Bx, G10Bx, G16Bx, G17Bx, G18Bx).

For each detected fungus, the species, the genus, the family and the order are given. Some are classified as _Incertae sedis_. 

## Note on data saving

To ensure long term support and readability of the dataset, we have saved a copy of the original `.xlsx` file in a `.csv` file. To do so, we have run the following R line of code (using the package [`readxl`](https://readxl.tidyverse.org/))

```
dfSourRot <- read_excel(path = "Data/data_sour_rot.xlsx", col_names = T, skip = 1)
write_csv(dfSourRot, file = "Data/data_sour_rot.csv")
```

In the function `LoadSourRot` in the file [`Load_preprocess_sour_rot.R`](Load_preprocess_sour_rot.R), one can substitute the line 
```
dfSourRot <- read_excel(path = "Data/data_sour_rot.xlsx", col_names = T, skip = 1)
```
with the line

```
dfSourRot <- read.csv(file = "Data/data_sour_rot.csv")
```

to get the exact same result, but relying on the `.csv` file. 
