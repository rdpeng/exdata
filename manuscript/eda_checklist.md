# Exploratory Data Analysis Checklist



In this chapter we will run through an informal "checklist" of things to do when embarking on an exploratory data analysis. As a running example I will use a dataset on hourly ozone levels in the United States for the year 2014. The elements of the checklist are

1. Formulate your question

2. Read in your data

3. Check the packaging

4. Run `str()`

5. Look at the top and the bottom of your data

6. Check your "n"s

7. Validate with at least one external data source

8. Try the easy solution first

9. Challenge your solution

10. Follow up

## Formulate your question

Formulating a question can be a useful way to guide the exploratory data analysis process and to limit the exponential number of paths that can be taken with any sizeable dataset. In particular, a *sharp* question or hypothesis can serve as a dimension reduction tool that can eliminate variables that are not immediately relevant to the question. 

For example, in this chapter we will be looking at an air pollution dataset from the U.S. Environmental Protection Agency (EPA). A general question one could as is

> Are air pollution levels higher on the east coast than on the west coast?

But a more specific question might be

> Are hourly ozone levels on average higher in New York City than they are in Los Angeles?

Note that both questions may be of interest, and neither is right or wrong. But the first question requires looking at all pollutants across the entire east and west coasts, while the second question only requires looking at single pollutant in two cities.

It's usually a good idea to spend a few minutes to figure out what is the question you're *really* interested in, and narrow it down to be as specific as possible (without becoming uninteresting).

For this chapter, we will focus on the following question:

> Which counties in the United States have the highest levels of ambient ozone pollution?

As a side note, one of the most important questions you can answer with an exploratory data analysis is "Do I have the right data to answer this question?" Often this question is difficult ot answer at first, but can become more clear as we sort through and look at the data.

## Read in your data

The next task in any exploratory data analysis is to read in some data. Sometimes the data will come in a very messy format and you'll need to do some cleaning. Other times, someone else will have cleaned up that data for you so you'll be spared the pain of having to do the cleaning. 

We won't go through the pain of cleaning up a dataset here, not because it's not important, but rather because there's often not much generalizable knowledge to obtain from going through it. Every dataset has its unique quirks and so for now it's probably best to not get bogged down in the details.

Here we have a relatively clean dataset from the U.S. EPA on hourly ozone measurements in the entire U.S. for the year 2014. The data are available from the EPA's [Air Quality System web page](https://aqs.epa.gov/aqsweb/airdata/download_files.html). I've simply downloaded the zip file from the web site, unzipped the archive, and put the resulting file in a directory called "data". If you want to run this code you'll have to use the same directory structure.

The dataset is a comma-separated value (CSV) file, where each row of the file contains one hourly measurement of ozone at some location in the country.

**NOTE**: Running the code below may take a few minutes. There are 7,147,884 rows in the CSV file. If it takes too long, you can read in a subset by specifying a value for the `n_max` argument to `read_csv()` that is greater than 0.


~~~~~~~~
> library(readr)
> ozone <- read_csv("data/hourly_44201_2014.csv", 
+                   col_types = "ccccinnccccccncnncccccc")
~~~~~~~~



The `readr` package by Hadley Wickham is a nice package for reading in flat files *very* fast, or at least much faster than R's built-in functions. It makes some tradeoffs to obtain that speed, so these functions are not always appropriate, but they serve our purposes here.

The character string provided to the `col_types` argument specifies the class of each column in the dataset. Each letter represents the class of a column: "c" for character, "n" for numeric", and "i" for integer. No, I didn't magically know the classes of each column---I just looked quickly at the file to see what the column classes were. If there are too many columns, you can not specify `col_types` and `read_csv()` will try to figure it out for you.

Just as a convenience for later, we can rewrite the names of the columns to remove any spaces.


~~~~~~~~
> names(ozone) <- make.names(names(ozone))
~~~~~~~~

## Check the packaging

Have you ever gotten a present *before* the time when you were allowed to open it? Sure, we all have. The problem is that the present is wrapped, but you desperately want to know what's inside. What's a person to do in those circumstances? Well, you can shake the box a bit, maybe knock it with your knuckle to see if it makes a hollow sound, or even weigh it to see how heavy it is. This is how you should think about your dataset before you start analyzing it for real. 

Assuming you don't get any warnings or errors when reading in the dataset, you should now have an object in your workspace named `ozone`. It's usually a good idea to poke at that object a little bit before we break open the wrapping paper.

For example, you can check the number of rows and columns.


~~~~~~~~
> nrow(ozone)
[1] 7147884
> ncol(ozone)
[1] 23
~~~~~~~~

Remember when I said there were 7,147,884 rows in the file? How does that match up with what we've read in? This dataset also has relatively few columns, so you might be able to check the original text file to see if the number of columns printed out (23) here matches the number of columns you see in the original file.


## Run `str()`

Another thing you can do is run `str()` on the dataset. This is usually a safe operation in the sense that even with a very large dataset, running `str()` shouldn't take too long.


~~~~~~~~
> str(ozone)
Classes 'tbl_df', 'tbl' and 'data.frame':	7147884 obs. of  23 variables:
 $ State.Code         : chr  "01" "01" "01" "01" ...
 $ County.Code        : chr  "003" "003" "003" "003" ...
 $ Site.Num           : chr  "0010" "0010" "0010" "0010" ...
 $ Parameter.Code     : chr  "44201" "44201" "44201" "44201" ...
 $ POC                : int  1 1 1 1 1 1 1 1 1 1 ...
 $ Latitude           : num  30.5 30.5 30.5 30.5 30.5 ...
 $ Longitude          : num  -87.9 -87.9 -87.9 -87.9 -87.9 ...
 $ Datum              : chr  "NAD83" "NAD83" "NAD83" "NAD83" ...
 $ Parameter.Name     : chr  "Ozone" "Ozone" "Ozone" "Ozone" ...
 $ Date.Local         : chr  "2014-03-01" "2014-03-01" "2014-03-01" "2014-03-01" ...
 $ Time.Local         : chr  "01:00" "02:00" "03:00" "04:00" ...
 $ Date.GMT           : chr  "2014-03-01" "2014-03-01" "2014-03-01" "2014-03-01" ...
 $ Time.GMT           : chr  "07:00" "08:00" "09:00" "10:00" ...
 $ Sample.Measurement : num  0.047 0.047 0.043 0.038 0.035 0.035 0.034 0.037 0.044 0.046 ...
 $ Units.of.Measure   : chr  "Parts per million" "Parts per million" "Parts per million" "Parts per million" ...
 $ MDL                : num  0.005 0.005 0.005 0.005 0.005 0.005 0.005 0.005 0.005 0.005 ...
 $ Uncertainty        : num  NA NA NA NA NA NA NA NA NA NA ...
 $ Qualifier          : chr  "" "" "" "" ...
 $ Method.Type        : chr  "FEM" "FEM" "FEM" "FEM" ...
 $ Method.Name        : chr  "INSTRUMENTAL - ULTRA VIOLET" "INSTRUMENTAL - ULTRA VIOLET" "INSTRUMENTAL - ULTRA VIOLET" "INSTRUMENTAL - ULTRA VIOLET" ...
 $ State.Name         : chr  "Alabama" "Alabama" "Alabama" "Alabama" ...
 $ County.Name        : chr  "Baldwin" "Baldwin" "Baldwin" "Baldwin" ...
 $ Date.of.Last.Change: chr  "2014-06-30" "2014-06-30" "2014-06-30" "2014-06-30" ...
~~~~~~~~

The output for `str()` duplicates some information that we already have, like the number of rows and columns. More importantly, you can examine the *classes* of each of the columns to make sure they are correctly specified (i.e. numbers are `numeric` and strings are `character`, etc.). Because I pre-specified all of the column classes in `read_csv()`, they all should match up with what I specified.

Often, with just these simple maneuvers, you can identify potential problems with the data before plunging in head first into a complicated data analysis. 



## Look at the top and the bottom of your data

I find it useful to look at the "beginning" and "end" of a dataset right after I check the packaging. This lets me know if the data were read in properly, things are properly formatted, and that everthing is there. If your data are time series data, then make sure the dates at the beginning and end of the dataset match what you expect the beginning and ending time period to be. 

You can peek at the top and bottom of the data with the `head()` and `tail()` functions.

Here's the top.


~~~~~~~~
> head(ozone[, c(6:7, 10)])
  Latitude Longitude Date.Local
1   30.498 -87.88141 2014-03-01
2   30.498 -87.88141 2014-03-01
3   30.498 -87.88141 2014-03-01
4   30.498 -87.88141 2014-03-01
5   30.498 -87.88141 2014-03-01
6   30.498 -87.88141 2014-03-01
~~~~~~~~

For brevity I've only taken a few columns. And here's the bottom.


~~~~~~~~
> tail(ozone[, c(6:7, 10)])
        Latitude Longitude Date.Local
7147879 18.17794 -65.91548 2014-09-30
7147880 18.17794 -65.91548 2014-09-30
7147881 18.17794 -65.91548 2014-09-30
7147882 18.17794 -65.91548 2014-09-30
7147883 18.17794 -65.91548 2014-09-30
7147884 18.17794 -65.91548 2014-09-30
~~~~~~~~

I find `tail()` to be particularly useful because often there will be some problem reading the end of a dataset and if you don't check that you'd never know. Sometimes there's weird formatting at the end or some extra comment lines that someone decided to stick at the end.

Make sure to check all the columns and verify that all of the data in each column looks the way it's supposed to look. This isn't a foolproof approach, because we're only looking at a few rows, but it's a decent start.



## Check your "n"s

In general, counting things is usually a good way to figure out if anything is wrong or not. In the simplest case, if you're expecting there to be 1,000 observations and it turns out there's only 20, you know something must have gone wrong somewhere. But there are other areas that you can check depending on your application. To do this properly, you need to identify some *landmarks* that can be used to check against your data. For example, if you are collecting data on people, such as in a survey or clinical trial, then you should know how many people there are in your study. That's something you should check in your dataset, to make sure that you have data on all the people you thought you would have data on.

In this example, we will use the fact that the dataset purportedly contains *hourly* data for the *entire country*. These will be our two landmarks for comparison.

Here, we have hourly ozone data that comes from monitors across the country. The monitors should be monitoring continuously during the day, so all hours should be represented. We can take a look at the `Time.Local` variable to see what time measurements are recorded as being taken.


~~~~~~~~
> table(ozone$Time.Local)

 00:00  00:01  01:00  01:02  02:00  02:03  03:00 
288698      2 290871      2 283709      2 282951 
 03:04  04:00  04:05  05:00  05:06  06:00  06:07 
     2 288963      2 302696      2 302356      2 
 07:00  07:08  08:00  08:09  09:00  09:10  10:00 
300950      2 298566      2 297154      2 297132 
 10:11  11:00  11:12  12:00  12:13  13:00  13:14 
     2 298125      2 298297      2 299997      2 
 14:00  14:15  15:00  15:16  16:00  16:17  17:00 
301410      2 302636      2 303387      2 303806 
 17:18  18:00  18:19  19:00  19:20  20:00  20:21 
     2 303795      2 304268      2 304268      2 
 21:00  21:22  22:00  22:23  23:00  23:24 
303551      2 295701      2 294549      2 
~~~~~~~~

One thing we notice here is that while almost all measurements in the dataset are recorded as being taken on the hour, some are taken at slightly different times. Such a small number of readings are taken at these off times that we might not want to care. But it does seem a bit odd, so it might be worth a quick check. 

We can take a look at which observations were measured at time "00:01".


~~~~~~~~
> library(dplyr)
> filter(ozone, Time.Local == "13:14") %>% 
+         select(State.Name, County.Name, Date.Local, 
+                Time.Local, Sample.Measurement)
# A tibble: 2 x 5
  State.Name County.Name Date.Local Time.Local
  <chr>      <chr>       <chr>      <chr>     
1 New York   Franklin    2014-09-30 13:14     
2 New York   Franklin    2014-09-30 13:14     
# … with 1 more variable:
#   Sample.Measurement <dbl>
~~~~~~~~

We can see that it's a monitor in Franklin County, New York and that the measurements were taken on September 30, 2014. What if we just pulled all of the measurements taken at this monitor on this date?


~~~~~~~~
> filter(ozone, State.Code == "36" 
+        & County.Code == "033" 
+        & Date.Local == "2014-09-30") %>%
+         select(Date.Local, Time.Local, 
+                Sample.Measurement) %>% 
+         as.data.frame
   Date.Local Time.Local Sample.Measurement
1  2014-09-30      00:01              0.011
2  2014-09-30      01:02              0.012
3  2014-09-30      02:03              0.012
4  2014-09-30      03:04              0.011
5  2014-09-30      04:05              0.011
6  2014-09-30      05:06              0.011
7  2014-09-30      06:07              0.010
8  2014-09-30      07:08              0.010
9  2014-09-30      08:09              0.010
10 2014-09-30      09:10              0.010
11 2014-09-30      10:11              0.010
12 2014-09-30      11:12              0.012
13 2014-09-30      12:13              0.011
14 2014-09-30      13:14              0.013
15 2014-09-30      14:15              0.016
16 2014-09-30      15:16              0.017
17 2014-09-30      16:17              0.017
18 2014-09-30      17:18              0.015
19 2014-09-30      18:19              0.017
20 2014-09-30      19:20              0.014
21 2014-09-30      20:21              0.014
22 2014-09-30      21:22              0.011
23 2014-09-30      22:23              0.010
24 2014-09-30      23:24              0.010
25 2014-09-30      00:01              0.010
26 2014-09-30      01:02              0.011
27 2014-09-30      02:03              0.011
28 2014-09-30      03:04              0.010
29 2014-09-30      04:05              0.010
30 2014-09-30      05:06              0.010
31 2014-09-30      06:07              0.009
32 2014-09-30      07:08              0.008
33 2014-09-30      08:09              0.009
34 2014-09-30      09:10              0.009
35 2014-09-30      10:11              0.009
36 2014-09-30      11:12              0.011
37 2014-09-30      12:13              0.010
38 2014-09-30      13:14              0.012
39 2014-09-30      14:15              0.015
40 2014-09-30      15:16              0.016
41 2014-09-30      16:17              0.016
42 2014-09-30      17:18              0.014
43 2014-09-30      18:19              0.016
44 2014-09-30      19:20              0.013
45 2014-09-30      20:21              0.013
46 2014-09-30      21:22              0.010
47 2014-09-30      22:23              0.009
48 2014-09-30      23:24              0.009
~~~~~~~~

Now we can see that this monitor just records its values at odd times, rather than on the hour. It seems, from looking at the previous output, that this is the only monitor in the country that does this, so it's probably not something we should worry about.


Since EPA monitors pollution across the country, there should be a good representation of states. Perhaps we should see exactly how many states are represented in this dataset. 


~~~~~~~~
> select(ozone, State.Name) %>% unique %>% nrow
[1] 52
~~~~~~~~

So it seems the representation is a bit too good---there are 52 states in the dataset, but only 50 states in the U.S.! 

We can take a look at the unique elements of the `State.Name` variable to see what's going on.


~~~~~~~~
> unique(ozone$State.Name)
 [1] "Alabama"              "Alaska"              
 [3] "Arizona"              "Arkansas"            
 [5] "California"           "Colorado"            
 [7] "Connecticut"          "Delaware"            
 [9] "District Of Columbia" "Florida"             
[11] "Georgia"              "Hawaii"              
[13] "Idaho"                "Illinois"            
[15] "Indiana"              "Iowa"                
[17] "Kansas"               "Kentucky"            
[19] "Louisiana"            "Maine"               
[21] "Maryland"             "Massachusetts"       
[23] "Michigan"             "Minnesota"           
[25] "Mississippi"          "Missouri"            
[27] "Montana"              "Nebraska"            
[29] "Nevada"               "New Hampshire"       
[31] "New Jersey"           "New Mexico"          
[33] "New York"             "North Carolina"      
[35] "North Dakota"         "Ohio"                
[37] "Oklahoma"             "Oregon"              
[39] "Pennsylvania"         "Rhode Island"        
[41] "South Carolina"       "South Dakota"        
[43] "Tennessee"            "Texas"               
[45] "Utah"                 "Vermont"             
[47] "Virginia"             "Washington"          
[49] "West Virginia"        "Wisconsin"           
[51] "Wyoming"              "Puerto Rico"         
~~~~~~~~

Now we can see that Washington, D.C. (District of Columbia) and Puerto Rico are the "extra" states included in the dataset. Since they are clearly part of the U.S. (but not official states of the union) that all seems okay.

This last bit of analysis made use of something we will discuss in the next section: external data. We knew that there are only 50 states in the U.S., so seeing 52 state names was an immediate trigger that something might be off. In this case, all was well, but validating your data with an external data source can be very useful.


## Validate with at least one external data source

Making sure your data matches something outside of the dataset is very important. It allows you to ensure that the measurements are roughly in line with what they should be and it serves as a check on what *other* things might be wrong in your dataset. External validation can often be as simple as checking your data against a single number, as we will do here.

In the U.S. we have national ambient air quality standards, and for ozone, the [current standard](http://www.epa.gov/ttn/naaqs/standards/ozone/s_o3_history.html) set in 2008 is that the "annual fourth-highest daily maximum 8-hr concentration, averaged over 3 years" should not exceed 0.075 parts per million (ppm). The exact details of how to calculate this are not important for this analysis, but roughly speaking, the 8-hour average concentration should not be too much higher than 0.075 ppm (it can be higher because of the way the standard is worded). 

Let's take a look at the hourly measurements of ozone.


~~~~~~~~
> summary(ozone$Sample.Measurement)
   Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
0.00000 0.02000 0.03200 0.03123 0.04200 0.34900 
~~~~~~~~

From the summary we can see that the maximum hourly concentration is quite high (0.349 ppm) but that in general, the bulk of the distribution is far below 0.075. 

We can get a bit more detail on the distribution by looking at deciles of the data.


~~~~~~~~
> quantile(ozone$Sample.Measurement, seq(0, 1, 0.1))
   0%   10%   20%   30%   40%   50%   60%   70% 
0.000 0.010 0.018 0.023 0.028 0.032 0.036 0.040 
  80%   90%  100% 
0.044 0.051 0.349 
~~~~~~~~

Knowing that the national standard for ozone is something like 0.075, we can see from the data that

* The data are at least of the right order of magnitude (i.e. the units are correct)

* The range of the distribution is roughly what we'd expect, given the regulation around ambient pollution levels

* Some hourly levels (less than 10%) are above 0.075 but this may be reasonable given the wording of the standard and the averaging involved.


## Try the easy solution first

Recall that our original question was

> Which counties in the United States have the highest levels of ambient ozone pollution?

What's the simplest answer we could provide to this question? For the moment, don't worry about whether the answer is correct, but the point is how could you provide *prima facie* evidence for your hypothesis or question. You may refute that evidence later with deeper analysis, but this is the first pass.

Because we want to know which counties have the *highest* levels, it seems we need a list of counties that are ordered from highest to lowest with respect to their levels of ozone. What do we mean by "levels of ozone"? For now, let's just blindly take the average across the entire year for each county and then rank counties according to this metric. 

To identify each county we will use a combination of the `State.Name` and the `County.Name` variables.


~~~~~~~~
> ranking <- group_by(ozone, State.Name, County.Name) %>%
+         summarize(ozone = mean(Sample.Measurement)) %>%
+         as.data.frame %>%
+         arrange(desc(ozone))
~~~~~~~~

Now we can look at the top 10 counties in this ranking.


~~~~~~~~
> head(ranking, 10)
   State.Name County.Name      ozone
1  California    Mariposa 0.04992485
2  California      Nevada 0.04866836
3     Wyoming      Albany 0.04834274
4     Arizona     Yavapai 0.04746346
5     Arizona        Gila 0.04722276
6  California        Inyo 0.04659648
7        Utah    San Juan 0.04654895
8     Arizona    Coconino 0.04605669
9  California   El Dorado 0.04595514
10     Nevada  White Pine 0.04465562
~~~~~~~~

It seems interesting that all of these counties are in the western U.S., with 4 of them in California alone. 

For comparison we can look at the 10 lowest counties too.


~~~~~~~~
> tail(ranking, 10)
     State.Name          County.Name       ozone
781      Alaska    Matanuska Susitna 0.020911008
782  Washington              Whatcom 0.020114267
783      Hawaii             Honolulu 0.019813165
784   Tennessee                 Knox 0.018579452
785  California               Merced 0.017200647
786      Alaska Fairbanks North Star 0.014993138
787    Oklahoma                Caddo 0.014677374
788 Puerto Rico               Juncos 0.013738328
789 Puerto Rico              Bayamon 0.010693529
790 Puerto Rico               Catano 0.004685369
~~~~~~~~

Let's take a look at one of the higest level counties, Mariposa County, California. First let's see how many observations there are for this county in the dataset.


~~~~~~~~
> filter(ozone, State.Name == "California" & County.Name == "Mariposa") %>% nrow
[1] 9328
~~~~~~~~

Always be checking. Does that number of observations sound right? Well, there's 24 hours in a day and 365 days per, which gives us 8760, which is close to that number of observations. Sometimes the counties use alternate methods of measurement during the year so there may be "extra" measurements.

We can take a look at how ozone varies through the year in this county by looking at monthly averages. First we'll need to convert the date variable into a `Date` class.


~~~~~~~~
> ozone <- mutate(ozone, Date.Local = as.Date(Date.Local))
~~~~~~~~

Then we will split the data by month to look at the average hourly levels.


~~~~~~~~
> filter(ozone, State.Name == "California" & County.Name == "Mariposa") %>%
+         mutate(month = factor(months(Date.Local), levels = month.name)) %>%
+         group_by(month) %>%
+         summarize(ozone = mean(Sample.Measurement))
# A tibble: 10 x 2
   month      ozone
 * <fct>      <dbl>
 1 January   0.0408
 2 February  0.0388
 3 March     0.0455
 4 April     0.0498
 5 May       0.0505
 6 June      0.0564
 7 July      0.0522
 8 August    0.0554
 9 September 0.0512
10 October   0.0469
~~~~~~~~

A few things stand out here. First, ozone appears to be higher in the summer months and lower in the winter months. Second, there are two months missing (November and December) from the data. It's not immediately clear why that is, but it's probably worth investigating a bit later on. 

Now let's take a look at one of the lowest level counties, Caddo County, Oklahoma.


~~~~~~~~
> filter(ozone, State.Name == "Oklahoma" & County.Name == "Caddo") %>% nrow
[1] 5666
~~~~~~~~

Here we see that there are perhaps fewer observations than we would expect for a monitor that was measuring 24 hours a day all year. We can check the data to see if anything funny is going on.


~~~~~~~~
> filter(ozone, State.Name == "Oklahoma" & County.Name == "Caddo") %>%
+         mutate(month = factor(months(Date.Local), levels = month.name)) %>%
+         group_by(month) %>%
+         summarize(ozone = mean(Sample.Measurement))
# A tibble: 9 x 2
  month       ozone
* <fct>       <dbl>
1 January   0.0187 
2 February  0.00206
3 March     0.002  
4 April     0.0232 
5 May       0.0242 
6 June      0.0202 
7 July      0.0191 
8 August    0.0209 
9 September 0.002  
~~~~~~~~

Here we can see that the levels of ozone are much lower in this county and that also three months are missing (October, November, and December). Given the seasonal nature of ozone, it's possible that the levels of ozone are so low in those months that it's not even worth measuring. In fact some of the monthly averages are below the typical method detection limit of the measurement technology, meaning that those values are highly uncertain and likely not distinguishable from zero.


## Challenge your solution

The easy solution is nice because it is, well, easy, but you should never allow those results to hold the day. You should always be thinking of ways to challenge the results, especially if those results comport with your prior expectation.

Now, the easy answer seemed to work okay in that it gave us a listing of counties that had the highest average levels of ozone for 2014. However, the analysis raised some issues. For example, some counties do not have measurements every month. Is this a problem? Would it affect our ranking of counties if we had those measurements?

Also, how stable are the rankings from year to year? We only have one year's worth of data for the moment, but we could perhaps get a sense of the stability of the rankings by shuffling the data around a bit to see if anything changes. We can imagine that from year to year, the ozone data are somewhat different randomly, but generally follow similar patterns across the country. So the shuffling process could approximate the data changing from one year to the next. It's not an ideal solution, but it could give us a sense of how stable the rankings are.

First we set our random number generator and resample the indices of the rows of the data frame with replacement. The statistical jargon for this approach is a bootstrap sample. We use the resampled indices to create a new dataset, `ozone2`, that shares many of the same qualities as the original but is randomly perturbed.


~~~~~~~~
> set.seed(10234)
> N <- nrow(ozone)
> idx <- sample(N, N, replace = TRUE)
> ozone2 <- ozone[idx, ]
~~~~~~~~

Now we can reconstruct our rankings of the counties based on this resampled data.


~~~~~~~~
> ranking2 <- group_by(ozone2, State.Name, County.Name) %>%
+         summarize(ozone = mean(Sample.Measurement)) %>%
+         as.data.frame %>%
+         arrange(desc(ozone))
~~~~~~~~

We can then compare the top 10 counties from our original ranking and the top 10 counties from our ranking based on the resampled data.


~~~~~~~~
> cbind(head(ranking, 10),
+       head(ranking2, 10))
   State.Name County.Name      ozone State.Name
1  California    Mariposa 0.04992485 California
2  California      Nevada 0.04866836 California
3     Wyoming      Albany 0.04834274    Wyoming
4     Arizona     Yavapai 0.04746346    Arizona
5     Arizona        Gila 0.04722276    Arizona
6  California        Inyo 0.04659648       Utah
7        Utah    San Juan 0.04654895 California
8     Arizona    Coconino 0.04605669    Arizona
9  California   El Dorado 0.04595514 California
10     Nevada  White Pine 0.04465562     Nevada
   County.Name      ozone
1     Mariposa 0.04983094
2       Nevada 0.04869841
3       Albany 0.04830520
4      Yavapai 0.04748795
5         Gila 0.04728284
6     San Juan 0.04665711
7         Inyo 0.04652602
8     Coconino 0.04616988
9    El Dorado 0.04611164
10  White Pine 0.04466106
~~~~~~~~

We can see that the rankings based on the resampled data (columns 4--6 on the right) are very close to the original, with the first 7 being identical. Numbers 8 and 9 get flipped in the resampled rankings but that's about it. This might suggest that the original rankings are somewhat stable.

We can also look at the bottom of the list to see if there were any major changes.


~~~~~~~~
> cbind(tail(ranking, 10),
+       tail(ranking2, 10))
     State.Name          County.Name       ozone
781      Alaska    Matanuska Susitna 0.020911008
782  Washington              Whatcom 0.020114267
783      Hawaii             Honolulu 0.019813165
784   Tennessee                 Knox 0.018579452
785  California               Merced 0.017200647
786      Alaska Fairbanks North Star 0.014993138
787    Oklahoma                Caddo 0.014677374
788 Puerto Rico               Juncos 0.013738328
789 Puerto Rico              Bayamon 0.010693529
790 Puerto Rico               Catano 0.004685369
     State.Name          County.Name       ozone
781      Alaska    Matanuska Susitna 0.020806642
782  Washington              Whatcom 0.020043750
783      Hawaii             Honolulu 0.019821603
784   Tennessee                 Knox 0.018814913
785  California               Merced 0.016917933
786      Alaska Fairbanks North Star 0.014933125
787    Oklahoma                Caddo 0.014662867
788 Puerto Rico               Juncos 0.013858010
789 Puerto Rico              Bayamon 0.010578880
790 Puerto Rico               Catano 0.004775807
~~~~~~~~

Here we can see that the bottom 7 counties are identical in both rankings, but after that things shuffle a bit. We're less concerned with the counties at the bottom of the list, but this suggests there is also reasonable stability.


## Follow up questions

In this chapter I've presented some simple steps to take when starting off on an exploratory analysis. The example analysis conducted in this chapter was far from perfect, but it got us thinking about the data and the question of interest. It also gave us a number of things to follow up on in case we continue to be interested in this question.

At this point it's useful to consider a few followup questions.

1. **Do you have the right data?** Sometimes at the conclusion of an exploratory data analysis, the conclusion is that the dataset is not really appropriate for this question. In this case, the dataset seemed perfectly fine for answering the question of which counties had the highest levels of ozone.

2. **Do you need other data?** One sub-question we tried to address was whether the county rankings were stable across years. We addressed this by resampling the data once to see if the rankings changed, but the better way to do this would be to simply get the data for previous years and re-do the rankings. 

3. **Do you have the right question?** In this case, it's not clear that the question we tried to answer has immediate relevance, and the data didn't really indicate anything to increase the question's relevance. For example, it might have been more interesting to assess which counties were in violation of the national ambient air quality standard, because determining this could have regulatory implications. However, this is a much more complicated calculation to do, requiring data from at least 3 previous years.


The goal of exploratory data analysis is to get you thinking about your data and reasoning about your question. At this point, we can refine our question or collect new data, all in an iterative process to get at the truth.
