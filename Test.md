Untitled
================

## GitHub Documents

This is an R Markdown format used for publishing markdown documents to
GitHub. When you click the **Knit** button all R code chunks are run and
a markdown file (.md) suitable for publishing to GitHub is generated.

## Including Code

You can include R code in the document as follows:

``` r
test.table <- read_csv("~/Desktop/test.table.csv")
```

    ## Rows: 35 Columns: 9
    ## ── Column specification ────────────────────────────────────────────────────────
    ## Delimiter: ","
    ## chr (9): Starting_state, First_Event, Distrubtion, Parameters_Estimate, Tota...
    ## 
    ## ℹ Use `spec()` to retrieve the full column specification for this data.
    ## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.

``` r
# Save the HTML table to a file
html_file <- "table.html"
kable(test.table, format = "html", col.names = c("Starting_State", "First_Event", "Distribution", "Parameters Estimate", "Total Probability", "Probability at t=15", "Median Time-to-event", "25th% Time", "75th% Time"), align = "c") %>%
  kable_styling(fixed_thead = T) %>%
  kable_styling(bootstrap_options = c("striped", "hover"), full_width = F, font_size = 10) %>%
  column_spec(1, "0.8in") %>%
  column_spec(2, "0.6in", background = "yellow") %>%
  column_spec(3, "0.8in") %>%
  column_spec(4, "1.5in") %>%
  column_spec(5, "1.5in") %>%
  column_spec(6, "1.5in") %>%
  column_spec(7, "1.5in") %>%
  column_spec(8, "1.3in") %>%
  column_spec(9, width = "1.3in") %>%
  row_spec(1:35, align = "c") %>%
  save_kable(html_file)

# Take a screenshot and save it as a PNG file
webshot(html_file, "table_screenshot.png")
```

![](Test_files/figure-gfm/cars-1.png)<!-- -->

![Table Screenshot](table_screenshot.png)

## Including Plots

You can also embed plots, for example:

Note that the `echo = FALSE` parameter was added to the code chunk to
prevent printing of the R code that generated the plot.
