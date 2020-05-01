# Data Analysis Case Study: Changes in Fine Particle Air Pollution in the U.S.



This chapter presents an example data analysis looking at changes in fine particulate matter (PM) air pollution in the United States using the Environmental Protection Agencies freely available national monitoring data. The purpose of the chapter is to just show how the various tools that we have covered in this book can be used to read, manipulate, and summarize data so that you can develop statistical evidence for relevant real-world questions. 

[Watch a video of this chapter](https://youtu.be/VE-6bQvyfTQ). Note that this video differs slightly from this chapter in the code that is implemented. In particular, the video version focuses on using base graphics plots. However, the general analysis is the same.


## Synopsis

In this chapter we aim to describe the changes in fine particle (PM2.5) outdoor air pollution in the United States between the years 1999 and 2012. Our overall hypothesis is that out door PM2.5 has decreased on average across the U.S. due to nationwide regulatory requirements arising from the Clean Air Act. To investigate this hypothesis, we obtained PM2.5 data from the U.S. Environmental Protection Agency which is collected from monitors sited across the U.S. We specifically obtained data for the years 1999 and 2012 (the most recent complete year available). From these data, we found that, on average across the U.S., levels of PM2.5 have decreased between 1999 and 2012. At one individual monitor, we found that levels have decreased and that the variability of PM2.5 has decreased. Most individual states also experienced decreases in PM2.5, although some states saw increases.


## Loading and Processing the Raw Data

From the [EPA Air Quality System](http://www.epa.gov/ttn/airs/airsaqs/detaildata/downloadaqsdata.htm) we obtained data on fine particulate matter air pollution (PM2.5) that is monitored across the U.S. as part of the nationwide PM monitoring network. We obtained the files for the years 1999 and 2012.


### Reading in the 1999 data

We first read in the 1999 data from the raw text file included in the zip archive. The data is a delimited file were fields are delimited with the `|` character adn missing values are coded as blank fields. We skip some commented lines in the beginning of the file and initially we do not read the header data.



~~~~~~~~
> library(readr)
> pm0 <- read_delim("data/RD_501_88101_1999-0.txt", 
+                   delim = "|",
+                   comment = "#", 
+                   col_names = FALSE, 
+                   na = "")
~~~~~~~~

After reading in the 1999 we check the first few rows (there are 117,421) rows in this dataset. 


~~~~~~~~
> dim(pm0)
[1] 117421     28
> head(pm0[, 1:13])
# A tibble: 6 x 13
  X1    X2    X3    X4    X5       X6    X7    X8    X9   X10    X11 X12   
  <chr> <chr> <chr> <chr> <chr> <dbl> <dbl> <dbl> <dbl> <dbl>  <dbl> <time>
1 RD    I     01    027   0001  88101     1     7   105   120 2.00e7 00'00"
2 RD    I     01    027   0001  88101     1     7   105   120 2.00e7 00'00"
3 RD    I     01    027   0001  88101     1     7   105   120 2.00e7 00'00"
4 RD    I     01    027   0001  88101     1     7   105   120 2.00e7 00'00"
5 RD    I     01    027   0001  88101     1     7   105   120 2.00e7 00'00"
6 RD    I     01    027   0001  88101     1     7   105   120 2.00e7 00'00"
# … with 1 more variable: X13 <dbl>
~~~~~~~~

We then attach the column headers to the dataset and make sure that they are properly formated for R data frames.



~~~~~~~~
> cnames <- readLines("data/RD_501_88101_1999-0.txt", 1)
> cnames <- strsplit(cnames, "|", fixed = TRUE)
> ## Ensure names are properly formatted
> names(pm0) <- make.names(cnames[[1]])  
> head(pm0[, 1:13])
# A tibble: 6 x 13
  X..RD Action.Code State.Code County.Code Site.ID Parameter   POC
  <chr> <chr>       <chr>      <chr>       <chr>       <dbl> <dbl>
1 RD    I           01         027         0001        88101     1
2 RD    I           01         027         0001        88101     1
3 RD    I           01         027         0001        88101     1
4 RD    I           01         027         0001        88101     1
5 RD    I           01         027         0001        88101     1
6 RD    I           01         027         0001        88101     1
# … with 6 more variables: Sample.Duration <dbl>, Unit <dbl>, Method <dbl>,
#   Date <dbl>, Start.Time <time>, Sample.Value <dbl>
~~~~~~~~

The column we are interested in is the `Sample.Value` column which contains the PM2.5 measurements. Here we extract that column and print a brief summary.



~~~~~~~~
> x0 <- pm0$Sample.Value
> summary(x0)
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
   0.00    7.20   11.50   13.74   17.90  157.10   13217 
~~~~~~~~

Missing values are a common problem with environmental data and so we check to se what proportion of the observations are missing (i.e. coded as `NA`).


~~~~~~~~
> ## Are missing values important here?
> mean(is.na(x0))
[1] 0.1125608
~~~~~~~~

Because the proportion of missing values is relatively low (0.1125608), we choose to ignore missing values for now.


### Reading in the 2012 data

We then read in the 2012 data in the same manner in which we read the 1999 data (the data files are in the same format). 



~~~~~~~~
> pm1 <- read_delim("data/RD_501_88101_2012-0.txt", 
+                   comment = "#", 
+                   col_names = FALSE, 
+                   delim = "|", 
+                   na = "")
~~~~~~~~

We also set the column names (they are the same as the 1999 dataset) and extract the `Sample.Value` column from this dataset.


~~~~~~~~
> names(pm1) <- make.names(cnames[[1]])
~~~~~~~~


Since we will be comparing the two years of data, it makes sense to combine them into a single data frame


~~~~~~~~
> library(dplyr)
> pm <- rbind(pm0, pm1)
~~~~~~~~
 
and create a factor variable indicating which year the data comes from. We also rename the `Sample.Value` variable to a more sensible `PM`.

~~~~~~~~
> pm <- mutate(pm, year = factor(rep(c(1999, 2012), c(nrow(pm0), nrow(pm1))))) %>%
+         rename(PM = Sample.Value)
~~~~~~~~


## Results

### Entire U.S. analysis

In order to show aggregate changes in PM across the entire monitoring network, we can make boxplots of all monitor values in 1999 and 2012. Here, we take the log of the PM values to adjust for the skew in the data.


~~~~~~~~
> library(ggplot2)
> 
> ## Take a random sample because it's faster
> set.seed(2015)
> idx <- sample(nrow(pm), 1000)
> qplot(year, log2(PM), data = pm[idx, ], geom = "boxplot")
~~~~~~~~

![Boxplot of PM values in 1999 and 2012](images/example-boxplot log values-1.png)

From the raw boxplot, it seems that on average, the levels of PM in 2012 are lower than they were in 1999. Interestingly, there also appears to be much greater variation in PM in 2012 than there was in 1999.

We can make some summaries of the two year's worth data to get at actual numbers.


~~~~~~~~
> with(pm, tapply(PM, year, summary))
$`1999`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
   0.00    7.20   11.50   13.74   17.90  157.10   13217 

$`2012`
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
 -10.00    4.00    7.63    9.14   12.00  908.97   73133 
~~~~~~~~

Interestingly, from the summary of 2012 it appears there are some negative values of PM, which in general should not occur. We can investigate that somewhat to see if there is anything we should worry about.


~~~~~~~~
> filter(pm, year == "2012") %>% summarize(negative = mean(PM < 0, na.rm = TRUE))
# A tibble: 1 x 1
  negative
     <dbl>
1   0.0215
~~~~~~~~

There is a relatively small proportion of values that are negative, which is perhaps reassuring. In order to investigate this a step further we can extract the date of each measurement from the original data frame. The idea here is that perhaps negative values occur more often in some parts of the year than other parts. However, the original data are formatted as character strings so we convert them to R's `Date` format for easier manipulation.


~~~~~~~~
> library(lubridate)

Attaching package: 'lubridate'
The following objects are masked from 'package:base':

    date, intersect, setdiff, union
> negative <- filter(pm, year == "2012") %>% 
+         mutate(negative = PM < 0, date = ymd(Date)) %>%
+         select(date, negative)
~~~~~~~~


We can then extract the month from each of the dates with negative values and attempt to identify when negative values occur most often.


~~~~~~~~
> mutate(negative, month = factor(month.name[month(date)], levels = month.name)) %>%
+         group_by(month) %>%
+         summarize(pct.negative = mean(negative, na.rm = TRUE) * 100)
# A tibble: 10 x 2
   month     pct.negative
 * <fct>            <dbl>
 1 January          2.97 
 2 February         2.43 
 3 March            2.41 
 4 April            2.18 
 5 May              1.73 
 6 June             2.56 
 7 July             0.792
 8 August           1.06 
 9 September        1.52 
10 October          0    
~~~~~~~~

From the table above it appears that bulk of the negative values occur in the first four months of the year (January--April). However, beyond that simple observation, it is not clear why the negative values occur. That said, given the relatively low proportion of negative values, we will ignore them for now.


### Changes in PM levels at an individual monitor

So far we have examined the change in PM levels on average across the country. One issue with the previous analysis is that the monitoring network could have changed in the time period between 1999 and 2012. So if for some reason in 2012 there are more monitors concentrated in cleaner parts of the country than there were in 1999, it might appear the PM levels decreased when in fact they didn't. In this section we will focus on a single monitor in New York State to see if PM levels *at that monitor* decreased from 1999 to 2012. 

Our first task is to identify a monitor in New York State that has data in 1999 and 2012 (not all monitors operated during both time periods). First we subset the data frames to only include data from New York (`State.Code == 36`) and only include the `County.Code` and the `Site.ID` (i.e. monitor number) variables.


~~~~~~~~
> sites <- filter(pm, State.Code == 36) %>% select(County.Code, Site.ID, year) %>% unique
~~~~~~~~

Then we create a new variable that combines the county code and the site ID into a single string.


~~~~~~~~
> sites <- mutate(sites, site.code = paste(County.Code, Site.ID, sep = "."))
> str(sites)
tibble [51 × 4] (S3: tbl_df/tbl/data.frame)
 $ County.Code: chr [1:51] "001" "001" "005" "005" ...
 $ Site.ID    : chr [1:51] "0005" "0012" "0073" "0080" ...
 $ year       : Factor w/ 2 levels "1999","2012": 1 1 1 1 1 1 1 1 1 1 ...
 $ site.code  : chr [1:51] "001.0005" "001.0012" "005.0073" "005.0080" ...
~~~~~~~~

Finally, we want the intersection between the sites present in 1999 and 2012 so that we might choose a monitor that has data in both periods.


~~~~~~~~
> site.year <- with(sites, split(site.code, year))
> both <- intersect(site.year[[1]], site.year[[2]])
> print(both)
 [1] "001.0005" "001.0012" "005.0080" "013.0011" "029.0005" "031.0003"
 [7] "063.2008" "067.1015" "085.0055" "101.0003"
~~~~~~~~

Here (above) we can see that there are 10 monitors that were operating in both time periods. However, rather than choose one at random, it might best to choose one that had a reasonable amount of data in each year.


~~~~~~~~
> count <- mutate(pm, site.code = paste(County.Code, Site.ID, sep = ".")) %>% 
+         filter(site.code %in% both)
~~~~~~~~

Now that we have subsetted the original data frames to only include the data from the monitors that overlap between 1999 and 2012, we can count the number of observations at each monitor to see which ones have the most observations.


~~~~~~~~
> group_by(count, site.code) %>% summarize(n = n())
# A tibble: 10 x 2
   site.code     n
 * <chr>     <int>
 1 001.0005    186
 2 001.0012     92
 3 005.0080     92
 4 013.0011    213
 5 029.0005     94
 6 031.0003    198
 7 063.2008    152
 8 067.1015    153
 9 085.0055     38
10 101.0003    527
~~~~~~~~

A number of monitors seem suitable from the output, but we will focus here on County 63 and site ID 2008. 


~~~~~~~~
> pmsub <- filter(pm, State.Code == "36" & County.Code == "063" & Site.ID == "2008") %>%
+         select(Date, year, PM) %>%
+         mutate(Date = ymd(Date), yday = yday(Date))
~~~~~~~~

Now we plot the time series data of PM for the monitor in both years.


~~~~~~~~
> qplot(yday, PM, data = pmsub, facets = . ~ year, xlab = "Day of the year")
~~~~~~~~

![Daily PM for 1999 and 2012](images/example-unnamed-chunk-13-1.png)



From the plot above, we can that median levels of PM (horizontal solid line) have decreased a little from 10.45 in 1999 to 8.29 in 2012. However, perhaps more interesting is that the variation (spread) in the PM values in 2012 is much smaller than it was in 1999. This suggest that not only are median levels of PM lower in 2012, but that there are fewer large spikes from day to day. One issue with the data here is that the 1999 data are from July through December while the 2012 data are recorded in January through April. It would have been better if we'd had full-year data for both years as there could be some seasonal confounding going on.

### Changes in state-wide PM levels

Although ambient air quality standards are set at the federal level in the U.S. and hence affect the entire country, the actual reduction and management of PM is left to the individual states. States that are not "in attainment" have to develop a plan to reduce PM so that that the are in attainment (eventually). Therefore, it might be useful to examine changes in PM at the state level. This analysis falls somewhere in between looking at the entire country all at once and looking at an individual monitor.

What we do here is calculate the mean of PM for each state in 1999 and 2012.


~~~~~~~~
> mn <- group_by(pm, year, State.Code) %>% summarize(PM = mean(PM, na.rm = TRUE))
> head(mn)
# A tibble: 6 x 3
# Groups:   year [1]
  year  State.Code    PM
  <fct> <chr>      <dbl>
1 1999  01         20.0 
2 1999  02          6.67
3 1999  04         10.8 
4 1999  05         15.7 
5 1999  06         17.7 
6 1999  08          7.53
> tail(mn)
# A tibble: 6 x 3
# Groups:   year [1]
  year  State.Code    PM
  <fct> <chr>      <dbl>
1 2012  51          8.71
2 2012  53          6.36
3 2012  54          9.82
4 2012  55          7.91
5 2012  56          4.01
6 2012  72          6.05
~~~~~~~~

Now make a plot that shows the 1999 state-wide means in one "column" and the 2012 state-wide means in another columns. We then draw a line connecting the means for each year in the same state to highlight the trend.


~~~~~~~~
> qplot(xyear, PM, data = mutate(mn, xyear = as.numeric(as.character(year))), 
+       color = factor(State.Code), 
+       geom = c("point", "line"))
~~~~~~~~

![Change in mean PM levels from 1999 to 2012 by state](images/example-unnamed-chunk-16-1.png)


This plot needs a bit of work still. But we can see that many states have decreased the average PM levels from 1999 to 2012 (although a few states actually increased their levels). 
