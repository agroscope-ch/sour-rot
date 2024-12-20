# Sour Rot

This is the repository associated to the paper [Revisiting sour rot of grapevine through disease-associated microbiomes: a tripartite co-infection?](https://www.biorxiv.org/content/10.1101/2024.09.19.613941v1). For the sake of **open-data**, we provide all the data used in the paper in the folder [Data](https://github.com/agroscope-ch/sour-rot/tree/master/Data). 
In addition to providing the data and for the sake of **reproducibility**, we provide the codes that have produced the analyses and the figures of this paper. The codes are provided in the _Rmarkdown_ file [Reproducing_figures_sour_rot.Rmd](https://github.com/agroscope-ch/sour-rot/blob/master/Reproducing_figures_sour_rot.Rmd), that both produce the results and gives details about how they are obtained, so as to make all the preprocessing steps fully transparent. The corresponding (i.e. readable) file [Reproducing_figures_sour_rot.html](https://github.com/agroscope-ch/sour-rot/blob/master/Reproducing_figures_sour_rot.html) can be either downloaded or visualized using this [link](https://html-preview.github.io/?url=https://github.com/agroscope-ch/sour-rot/blob/master/Reproducing_figures_sour_rot.html).

Those analyses are done using standard R pacakges, essentially the [tidyverse](https://www.tidyverse.org/) [[1]](#1)  collection of packages and [metacoder](https://grunwaldlab.github.io/metacoder_documentation/index.html)[[2]](#2)

## Note on downloading the files

As it is customary for github repository, the easiest way to get the repository is by using the following `git` command

```
git clone https://github.com/agroscope-ch/sour-rot.git 
```
For more information about what that this precisely mean, [see](https://github.com/git-guides/git-clone).

It is also possible to download all the files separately by clicking on it and then use the top right icon `download raw file`, as shown here

![](./Figures/Download_file_github.png)

In poarticular all the files with format that are not natively redered or supported by github (for instance in this repository, `.html` and `.xlsx` files) cannot be visualized without first downloading it. 

## Data

The data are described in full details in the paper and are available in the folder [`Data`](https://github.com/agroscope-ch/sour-rot/tree/master/Data). There are 3 different studies, each of which with a `xlsx` file. Some of the results (Figure 8-10) require data at the sample level of the third study, which are provided in the file [` `]

## Figures

Most of the figures are provided in different formats: 

- `.png` provided for simplicity. 
- `.html` interactive plots, usefull for better exploring the data
- `.eps` required for publication


## References

<a id="1">[1]</a> 
Wickham, H. _et al._ (2019). 
Journal of Open Source Software, 43(4), 1686. [DOI: 10.21105/joss.01686](https://doi.org/10.21105/joss.01686)

<a id="2">[2]</a> 
Z. Foster, T. Sharpton and N. Grünwald (2017). 
PLOS Computational Biology, 13(2), 1-15. [DOI: 10.1371/journal.pcbi.1005404](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005404)
