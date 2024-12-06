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
print(test.table)
```

    ## # A tibble: 35 × 9
    ##    Starting_state First_Event Distrubtion      Parameters_Estimate `Total _Prob`
    ##    <chr>          <chr>       <chr>            <chr>               <chr>        
    ##  1 Symptom Onset  Virtual     Log normal       logmean = 1.14, lo… 0.081 (0.08,…
    ##  2 Symptom Onset  Outpatient  Log normal       logmean = 1.28, lo… 0.127 (0.125…
    ##  3 Symptom Onset  Urgent Care Generalized gam… mu = 0.940, sigma … 0.368 (0.364…
    ##  4 Symptom Onset  Emergency   Log normal       logmean = 1.23, lo… 0.289 (0.285…
    ##  5 Symptom Onset  Inpatient   Generalized gam… mu = 1.73, sigma =… 0.034 (0.033…
    ##  6 Symptom Onset  Ventilation NA/No events     <NA>                <NA>         
    ##  7 Symptom Onset  Death       Exponential      rate = 0.125        0 (0, 0.001) 
    ##  8 Positive Test  Virtual     Generalized gam… mu = -2.30, sigma … 0.072 (0.07,…
    ##  9 Positive Test  Outpatient  Log normal       logmean = -1.95, l… 0.122 (0.12,…
    ## 10 Positive Test  Urgent Care Generalized gam… mu = -2.30, sigma … 0.37 (0.366,…
    ## # ℹ 25 more rows
    ## # ℹ 4 more variables: Prob_t_15 <chr>, Median_Time <chr>, `25th` <chr>,
    ## #   `75th` <chr>

``` r
test.table$Prob_t_15
```

    ##  [1] "0.079 (0.078, 0.081)" "0.123 (0.121, 0.125)" "0.359 (0.354, 0.363)"
    ##  [4] "0.281 (0.277, 0.285)" "0.032 (0.031, 0.033)" NA                    
    ##  [7] "0 (0, 0.001)"         "0.072 (0.07, 0.073)"  "0.122 (0.120, 0.124)"
    ## [10] "0.370 (0.366, 0.375)" "0.322 (0.318, 0.327)" "0.032 (0.032, 0.033)"
    ## [13] "0 (0, 0.001)"         "0.001 (0, 0.001)"     "0.12 (0.117, 0.122)" 
    ## [16] "0.114 (0.111, 0.116)" "0.117 (0.115, 0.119)" "0.014 (0.01, 0.017)" 
    ## [19] "0 (0, 0.001)"         "0 (0, 0)"             "0.142 (0.14, 0.144)" 
    ## [22] "0.078 (0.076, 0.08)"  "0.023 (0.019, 0.028)" "0.002 (0.001, 0.004)"
    ## [25] "0.003 (0.002, 0.005)" "0.075 (0.073, 0.083)" "0.013 (0.013, 0.014)"
    ## [28] NA                     "0 (0, 0.001)"         "0.036 (0.034, 0.037)"
    ## [31] "0.001 (0.001, 0.002)" "0.001 (0, 0.001)"     "0.062 (0.049, 0.078)"
    ## [34] "0.024 (0.016, 0.034)" "0.257 (0.184, 0.348)"

``` r
kable(test.table, format = "simple", col.names = c("Starting_State", "First_Event", "Distribution", "Parameters_Estimate", "Total_Probability", "Probability_at_t = 15", "Median_Time_To_Event", "25th%_Time", "75th%_Time"), align = "c")  
```

| Starting_State | First_Event |   Distribution    |           Parameters_Estimate           |  Total_Probability   | Probability_at_t = 15 | Median_Time_To_Event |     25th%\_Time      |     75th%\_Time      |
|:--------------:|:-----------:|:-----------------:|:---------------------------------------:|:--------------------:|:---------------------:|:--------------------:|:--------------------:|:--------------------:|
| Symptom Onset  |   Virtual   |    Log normal     |      logmean = 1.14, logsd = 0.804      | 0.081 (0.08, 0.083)  | 0.079 (0.078, 0.081)  |  3.12 (3.07, 3.18)   |  1.82 (1.78, 1.85)   |  5.37 (5.26, 5.47)   |
| Symptom Onset  | Outpatient  |    Log normal     |      logmean = 1.28, logsd = 0.781      | 0.127 (0.125, 0.129) | 0.123 (0.121, 0.125)  |  3.59 (3.53, 3.66)   |  2.12 (2.08, 2.16)   |   6.09 (5.96, 6.2)   |
| Symptom Onset  | Urgent Care | Generalized gamma |  mu = 0.940, sigma = 0.707, Q = -0.440  | 0.368 (0.364, 0.373) | 0.359 (0.354, 0.363)  |   2.85 (2.8, 2.9)    |  1.78 (1.75, 1.82)   |  4.77 (4.67, 4.87)   |
| Symptom Onset  |  Emergency  |    Log normal     |      logmean = 1.23, logsd = 0.766      | 0.289 (0.285, 0.293) | 0.281 (0.277, 0.285)  |  3.42 (3.36, 3.48)   |    2.04 (2, 2.08)    |  5.73 (5.61, 5.84)   |
| Symptom Onset  |  Inpatient  | Generalized gamma |   mu = 1.73, sigma = 0.761, Q = 0.487   | 0.034 (0.033, 0.035) | 0.032 (0.031, 0.033)  |   4.97 (4.8, 5.16)   |   2.83 (2.74, 2.9)   |  8.21 (7.98, 8.48)   |
| Symptom Onset  | Ventilation |   NA/No events    |                   NA                    |          NA          |          NA           |          NA          |          NA          |          NA          |
| Symptom Onset  |    Death    |    Exponential    |              rate = 0.125               |     0 (0, 0.001)     |     0 (0, 0.001)      |  5.55 (2.54, 11.99)  |   2.3 (1.06, 5.33)   | 11.09 (5.11, 25.69)  |
| Positive Test  |   Virtual   | Generalized gamma | mu = -2.30, sigma = 0.0443, Q = -18.30  | 0.072 (0.07, 0.073)  |  0.072 (0.07, 0.073)  |  0.17 (0.17, 0.18)   |  0.12 (0.12, 0.13)   |   0.3 (0.29, 0.31)   |
| Positive Test  | Outpatient  |    Log normal     |      logmean = -1.95, logsd = 1.22      | 0.122 (0.12, 0.124)  | 0.122 (0.120, 0.124)  |  0.14 (0.14, 0.15)   |  0.06 (0.06, 0.06)   |  0.33 (0.32, 0.33)   |
| Positive Test  | Urgent Care | Generalized gamma | mu = -2.30, sigma = -0.00314, Q = -17.9 | 0.37 (0.366, 0.375)  | 0.370 (0.366, 0.375)  |   0.1 (0.1, 0.11)    |    0.1 (0.1, 0.1)    |  0.11 (0.11, 0.11)   |
| Positive Test  |  Emergency  | Generalized gamma | mu = -2.30, sigma = 0.00431, Q = -13.30 | 0.322 (0.318, 0.327) | 0.322 (0.318, 0.327)  |   0.1 (0.1, 0.11)    |    0.1 (0.1, 0.1)    |  0.11 (0.11, 0.11)   |
| Positive Test  |  Inpatient  |    Log normal     |     logmean = -2.17, logsd = 0.761      | 0.032 (0.032, 0.033) | 0.032 (0.032, 0.033)  |  0.11 (0.11, 0.12)   |  0.07 (0.07, 0.07)   |  0.19 (0.19, 0.19)   |
| Positive Test  | Ventilation |    Exponential    |              rate = 0.141               |     0 (0, 0.001)     |     0 (0, 0.001)      |  4.93 (2.48, 10.03)  |  2.05 (0.99, 3.89)   |  9.86 (4.79, 18.76)  |
| Positive Test  |    Death    |       Gamma       |      shape = 0.573, rate = 0.0382       |   0.001 (0, 0.001)   |   0.001 (0, 0.001)    |  7.63 (2.78, 16.64)  |    2 (0.37, 5.86)    | 20.23 (9.97, 37.94)  |
|    Virtual     | Outpatient  |       Gamma       |      shape = 0.512, rate = 0.0450       | 0.16 (0.158, 0.161)  |  0.12 (0.117, 0.122)  |  5.28 (5.11, 5.45)   |  1.21 (1.09, 1.33)   | 15.11 (14.15, 16.15) |
|    Virtual     | Urgent Care |    Log normal     |     logmean = 0.0259, logsd = 1.95      | 0.124 (0.123, 0.126) | 0.114 (0.111, 0.116)  |  1.03 (0.86, 1.21)   |  0.28 (0.23, 0.33)   |  3.83 (3.19, 4.55)   |
|    Virtual     |  Emergency  |    Log normal     |     logmean = -0.0618, logsd = 1.82     | 0.125 (0.123, 0.126) | 0.117 (0.115, 0.119)  |  0.94 (0.79, 1.12)   |  0.27 (0.23, 0.32)   |   3.21 (2.7, 3.82)   |
|    Virtual     |  Inpatient  |      Weibull      |       shape = 0.590, scale = 6.07       | 0.017 (0.013, 0.021) |  0.014 (0.01, 0.017)  |  3.26 (1.94, 5.29)   |  0.74 (0.36, 1.45)   |   10.56 (7, 16.33)   |
|    Virtual     | Ventilation |     Gompertz      |     shape = 0.149, rate = 0.0000792     |     0 (0, 0.002)     |     0 (0, 0.001)      | 48.23 (0.02, 51.96)  | 42.33 (0.01, 48.27)  | 52.89 (0.04, 56.78)  |
|    Virtual     |    Death    |    Log normal     |      logmean = 3.38, logsd = 0.342      |   0.001 (0, 0.003)   |       0 (0, 0)        |  29.2 (21.3, 41.2)   | 23.22 (15.48, 33.35) | 36.85 (26.1, 55.55)  |
|   Outpatient   | Urgent Care |    Log normal     |     logmean = -0.572, logsd = 2.27      | 0.154 (0.152, 0.155) |  0.142 (0.14, 0.144)  |  0.56 (0.48, 0.67)   |   0.12 (0.1, 0.14)   |   2.62 (2.21, 3.1)   |
|   Outpatient   |  Emergency  |    Log normal     |      logmean = 0.288, logsd = 2.02      | 0.088 (0.087, 0.089) |  0.078 (0.076, 0.08)  |  1.33 (1.09, 1.63)   |  0.34 (0.28, 0.41)   |  5.19 (4.24, 6.29)   |
|   Outpatient   |  Inpatient  |    Log normal     |      logmean = 0.181, logsd = 2.30      | 0.027 (0.023, 0.032) | 0.023 (0.019, 0.028)  |   1.2 (0.8, 1.85)    |  0.25 (0.17, 0.39)   |  5.65 (3.78, 8.59)   |
|   Outpatient   | Ventilation |    Log normal     |     logmean = -0.574, logsd = 1.82      | 0.002 (0.001, 0.004) | 0.002 (0.001, 0.004)  |  0.56 (0.16, 1.77)   |  0.17 (0.04, 0.61)   |  1.92 (0.51, 7.84)   |
|   Outpatient   |    Death    |    Log normal     |      logmean = 2.02, logsd = 1.31       | 0.004 (0.003, 0.007) | 0.003 (0.002, 0.005)  |  7.55 (4.16, 12.9)   |  3.12 (1.58, 5.88)   | 18.23 (9.65, 35.48)  |
|  Urgent Care   |  Emergency  | Generalized gamma |  mu = -2.29, sigma = 0.132, Q = -15.80  | 0.082 (0.081, 0.083) | 0.075 (0.073, 0.083)  |  0.41 (0.38, 0.42)   |  0.18 (0.17, 0.18)   |  1.75 (1.54, 1.84)   |
|  Urgent Care   |  Inpatient  | Generalized gamma |  mu = -2.29, sigma = 0.146, Q = -12.70  | 0.014 (0.014, 0.015) | 0.013 (0.013, 0.014)  |  0.34 (0.27, 0.35)   |  0.16 (0.14, 0.17)   |  1.24 (0.79, 1.28)   |
|  Urgent Care   | Ventilation |   NA/No events    |                   NA                    |          NA          |          NA           |          NA          |          NA          |          NA          |
|  Urgent Care   |    Death    |    Exponential    |              rate = 0.250               |     0 (0, 0.001)     |     0 (0, 0.001)      |  2.77 (0.44, 20.59)  |  1.15 (0.16, 9.51)   |  5.54 (0.79, 45.81)  |
|   Emergency    |  Inpatient  |    Log normal     |      logmean = 0.362, logsd = 2.16      | 0.041 (0.041, 0.042) | 0.036 (0.034, 0.037)  |  1.44 (1.13, 1.84)   |  0.33 (0.27, 0.42)   |  6.17 (4.76, 7.95)   |
|   Emergency    | Ventilation |      Weibull      |       shape = 0.491, scale = 3.40       | 0.001 (0.001, 0.002) | 0.001 (0.001, 0.002)  |  1.61 (0.29, 6.25)   |  0.27 (0.02, 1.89)   |  6.62 (1.7, 26.96)   |
|   Emergency    |    Death    |     Gompertz      |      shape = 0.0496, rate = 0.0130      | 0.003 (0.002, 0.004) |   0.001 (0, 0.001)    | 26.05 (15.88, 32.51) | 14.91 (7.74, 22.21)  | 37.05 (28.01, 43.62) |
|   Inpatient    | Ventilation | Generalized gamma |   mu = 0.095, sigma = 1.94, Q = 0.00    | 0.068 (0.055, 0.085) | 0.062 (0.049, 0.078)  |   1.1 (0.07, 1.13)   |   0.3 (0.29, 0.31)   |  7.82 (5.39, 10.88)  |
|   Inpatient    |    Death    |     Gompertz      |      shape = 0.0148, rate = 0.0347      | 0.055 (0.044, 0.07)  | 0.024 (0.016, 0.034)  |  17.5 (2.44, 23.52)  |  4.06 (3.91, 4.22)   | 31.38 (23.53, 44.89) |
|  Ventilation   |    Death    |       Gamma       |      shape = 0.538, rate = 0.0471       | 0.345 (0.254, 0.457) | 0.257 (0.184, 0.348)  |  5.52 (2.87, 9.58)   |  1.35 (0.40, 3.19)   | 15.28 (9.02, 24.68)  |

## Including Plots

You can also embed plots, for example:

![](Test_files/figure-gfm/pressure-1.png)<!-- -->

Note that the `echo = FALSE` parameter was added to the code chunk to
prevent printing of the R code that generated the plot.
