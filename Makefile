all: 			whatisEDA.md grdevices.md principles.md plotbase.md plottingsystems.md exploratorygraphs.md hclust.md example.md dimensionreduction.md colors.md ggplot2.md dplyr.md eda_checklist.md kmeans.md

book_codefiles.zip:     all
			./codefiles.R
			cat codefiles_output.txt |xargs zip $@

example.md: 			     example.Rmd
				     knit.R $<
				     perl -npi -e 's/```r/~~~~~~~~/' $@
				     perl -npi -e 's/```/~~~~~~~~/' $@

dimensionreduction.md: 		     dimensionreduction.Rmd
				     knit.R $<
				     perl -npi -e 's/```r/~~~~~~~~/' $@
				     perl -npi -e 's/```/~~~~~~~~/' $@
				     ## ./equation.pl $@
				     R --no-save --args $@ < fixmath.R

exploratorygraphs.md:	exploratorygraphs.Rmd
			knit.R $<
			perl -npi -e 's/```r/~~~~~~~~/' $@
			perl -npi -e 's/```/~~~~~~~~/' $@

hclust.md:		hclust.Rmd
			knit.R $<
			perl -npi -e 's/```r/~~~~~~~~/' $@
			perl -npi -e 's/```/~~~~~~~~/' $@
			##./equation.pl $@
			R --no-save --args $@ < fixmath.R

kmeans.md:		kmeans.Rmd
			knit.R $<
			perl -npi -e 's/```r/~~~~~~~~/' $@
			perl -npi -e 's/```/~~~~~~~~/' $@

dplyr.md:		dplyr.Rmd
			knit.R $<
			perl -npi -e 's/```r/~~~~~~~~/' $@
			perl -npi -e 's/```/~~~~~~~~/' $@

eda_checklist.md:	eda_checklist.Rmd
			knit.R $<
			perl -npi -e 's/```r/~~~~~~~~/' $@
			perl -npi -e 's/```/~~~~~~~~/' $@

ggplot2.md:		ggplot2.Rmd
			knit.R $<
			perl -npi -e 's/```r/~~~~~~~~/' $@
			perl -npi -e 's/```/~~~~~~~~/' $@

colors.md:		colors.Rmd
			knit.R $<
			perl -npi -e 's/```r/~~~~~~~~/' $@
			perl -npi -e 's/```/~~~~~~~~/' $@

cluster-example.md:	cluster-example.Rmd
			knit.R $<
			perl -npi -e 's/```r/~~~~~~~~/' $@
			perl -npi -e 's/```/~~~~~~~~/' $@

plotbase.md:		plotbase.Rmd
			knit.R $<
			perl -npi -e 's/```r/~~~~~~~~/' $@
			perl -npi -e 's/```/~~~~~~~~/' $@

principles.md:		principles.Rmd
			knit.R $<
			perl -npi -e 's/```r/~~~~~~~~/' $@
			perl -npi -e 's/```/~~~~~~~~/' $@

plottingsystems.md:	plottingsystems.Rmd
			knit.R $<
			perl -npi -e 's/```r/~~~~~~~~/' $@
			perl -npi -e 's/```/~~~~~~~~/' $@

grdevices.md:		grdevices.Rmd
			knit.R $<
			perl -npi -e 's/```r/~~~~~~~~/' $@
			perl -npi -e 's/```/~~~~~~~~/' $@

whatisEDA.md:		whatisEDA.Rmd
			knit.R $<
