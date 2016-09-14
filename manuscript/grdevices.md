# Graphics Devices

Watch a video of this chapter: [Part 1](https://youtu.be/ftc6_hqRYuY) [Part 2](https://youtu.be/ci6ogllxVxg)



A graphics device is something where you can make a plot appear. Examples include

  * A window on your computer (screen device)
  
  * A PDF file (file device)

  * A PNG or JPEG file (file device)

  * A scalable vector graphics (SVG) file (file device)

When you make a plot in R, it has to be "sent" to a specific graphics device. The most common place for a plot to be "sent" is the *screen device*. On a Mac the screen device is launched with the `quartz()` function, on Windows the screen device is launched with `windows()` function, and on Unix/Linux the screen device is launched with `x11()` function. 

When making a plot, you need to consider how the plot will be used to determine what device the plot should be sent to. The list of devices supported by your installation of R is found in `?Devices`. There are also graphics devices that have been created by users and these are aviailable through packages on CRAN.

For quick visualizations and exploratory analysis, usually you want to use the screen device. Functions like `plot` in base, `xyplot` in lattice, or `qplot` in ggplot2 will default to sending a plot to the screen device. On a given platform, such as Mac, Windows, or Unix/Linux, there is only one screen device.

For plots that may be printed out or be incorporated into a document, such as papers, reports, or slide presentations, usually a *file device* is more appropriate, there are many different file devices to choose from and exactly which one to use in a given situation is something we discuss later.

Note that typically, not all graphics devices are available on all platforms. For example, you cannot launch the `windows()` device on a Mac or the `quartz()` device on Windows. The code for mst of the key graphics devices is implemented in the `grDevices` package, which comes with a standard R installation and is typically loaded by default.


## The Process of Making a Plot

When making a plot one must first make a few considerations (not
necessarily in this order):

- Where will the plot be made? On the screen? In a file? 

- How will the plot be used?
  - Is the plot for viewing temporarily on the screen?  
  - Will it be presented in a web browser?
  - Will it eventually end up in a paper that might be printed? 
  - Are you using it in a presentation?

- Is there a large amount of data going into the plot? Or is it just a
  few points?

- Do you need to be able to dynamically resize the graphic?

- What graphics system will you use: base, lattice, or ggplot2? These
  generally cannot be mixed.

Base graphics are usually constructed piecemeal, with each aspect of the plot handled separately through a series of function calls; this is sometimes conceptually simpler and allows plotting to mirror the thought process. Lattice graphics are usually created in a single function call, so all of the graphics parameters have to specified at once; specifying everything at once allows R to automatically calculate the necessary spacings and font sizes. The ggplot2 system combines concepts from both base and lattice graphics but uses an independent implementation.



## How Does a Plot Get Created?

There are two basic approaches to plotting. The first is most common. This involves

1. Call a *plotting* function like `plot`, `xyplot`, or `qplot`

2. The plot appears on the screen device

3. Annotate the plot if necessary

4. Enjoy

Here's an example of this process in making a plot with the `plot()` function.


~~~~~~~~
> ## Make plot appear on screen device
> with(faithful, plot(eruptions, waiting)) 
> 
> ## Annotate with a title
> title(main = "Old Faithful Geyser data")  
~~~~~~~~

The second basic approach to plotting is most commonly used for file devices:

1. Explicitly launch a graphics device

2. Call a plotting function to make a plot (Note: if you are using a file
device, no plot will appear on the screen)

3. Annotate the plot if necessary

3. Explicitly close graphics device with `dev.off()` (this is very important!)

Here's an example of how to make a plot using this second approach. In this case we make a plot that gets saved in a PDF file.


~~~~~~~~
> ## Open PDF device; create 'myplot.pdf' in my working directory
> pdf(file = "myplot.pdf")  
> 
> ## Create plot and send to a file (no plot appears on screen)
> with(faithful, plot(eruptions, waiting))  
> 
> ## Annotate plot; still nothing on screen
> title(main = "Old Faithful Geyser data")  
> 
> ## Close the PDF file device
> dev.off()  
> 
> ## Now you can view the file 'myplot.pdf' on your computer
~~~~~~~~


## Graphics File Devices

There are two basic types of file devices to consider: *vector* and *bitmap*
devices. Some of the key vector formats are

- `pdf`: useful for line-type graphics, resizes well, usually
  portable, not efficient if a plot has many objects/points

- `svg`: XML-based scalable vector graphics; supports animation and
  interactivity, potentially useful for web-based plots

- `win.metafile`: Windows metafile format (only on Windows)

- `postscript`: older format, also resizes well, usually portable, can
  be used to create encapsulated postscript files; Windows systems
  often don’t have a postscript viewer

Some examples of bitmap formats are

- `png`: bitmapped format, good for line drawings or images with solid
  colors, uses lossless compression (like the old GIF format), most
  web browsers can read this format natively, good for plotting many
  many many points, does not resize well

- `jpeg`: good for photographs or natural scenes, uses lossy
  compression, good for plotting many many many points, does not
  resize well, can be read by almost any computer and any web browser,
  not great for line drawings

- `tiff`: Creates bitmap files in the TIFF format; supports lossless
  compression

- `bmp`: a native Windows bitmapped format


## Multiple Open Graphics Devices

It is possible to open multiple graphics devices (screen, file, or
  both), for example when viewing multiple plots at once. Plotting can only occur on one graphics device at a time, though. 
  
The **currently active** graphics device can be found by calling  `dev.cur()` Every open graphics device is assigned an integer starting with 2 (there is no graphics device 1). You can change the active graphics device with `dev.set(<integer>)` where `<integer>` is the number associated with the graphics device you want to switch to


## Copying Plots

Copying a plot to another device can be useful because some plots
require a lot of code and it can be a pain to type all that in again
for a different device. Of course, it is always good to save the code that creates your plots, especially for any plots that you might publish or give to other people. 

The `dev.copy()` can be used to copy a plot from one device to another. For example you might copy a plot from the screen device to a file device. The  `dev.copy2pdf()` function is used specifically to copy a plot from the current device (usually the screen device) to a PDF file.

Note that copying a plot is not an exact operation, so the result may not
be identical to the original. In particular, when copying from the screen device to a file, depending on the size of the file device, many annotations such as axis labels may not look right.



~~~~~~~~
> library(datasets)
> 
> ## Create plot on screen device
> with(faithful, plot(eruptions, waiting))  
> 
> ## Add a main title
> title(main = "Old Faithful Geyser data")  
> 
> ## Copy my plot to a PNG file
> dev.copy(png, file = "geyserplot.png")  
> 
> ## Don't forget to close the PNG device!
> dev.off()  
~~~~~~~~


## Summary

Plots must be created on a graphics device. The default graphics device is almost always the screen device, which is most useful for exploratory analysis. File devices are useful for creating plots that can be included in other documents or sent to other people

For file devices, there are vector and bitmap formats

  - Vector formats are good for line drawings and plots with solid
    colors using a modest number of points

  - Bitmap formats are good for plots with a large number of points,
    natural scenes or web-based plots
