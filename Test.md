---
title: "Untitled"
output: 
  html_document:
    keep_md: true
---



## GitHub Documents

This is an R Markdown format used for publishing markdown documents to GitHub. When you click the **Knit** button all R code chunks are run and a markdown file (.md) suitable for publishing to GitHub is generated.

## Including Code

You can include R code in the document as follows:


```r
test.table <- read_csv("~/Desktop/test.table.csv")
```

```
## Rows: 35 Columns: 9
## ── Column specification ────────────────────────────────────────────────────────
## Delimiter: ","
## chr (9): Starting_state, First_Event, Distrubtion, Parameters_Estimate, Tota...
## 
## ℹ Use `spec()` to retrieve the full column specification for this data.
## ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
```

```r
print(test.table)
```

```
## # A tibble: 35 × 9
##    Starting_state First_Event Distrubtion      Parameters_Estimate `Total _Prob`
##    <chr>          <chr>       <chr>            <chr>               <chr>        
##  1 Symptom Onset  Virtual     Log normal       "logmean = 1.14, \… "0.081 \n(0.…
##  2 Symptom Onset  Outpatient  Log normal       "logmean = 1.28, l… "0.127 (0.12…
##  3 Symptom Onset  Urgent Care Generalized gam… "mu = 0.940, sigma… "0.368 (0.36…
##  4 Symptom Onset  Emergency   Log normal       "logmean = 1.23, l… "0.289 (0.28…
##  5 Symptom Onset  Inpatient   Generalized gam… "mu = 1.73, sigma … "0.034 (0.03…
##  6 Symptom Onset  Ventilation NA/No events      <NA>                <NA>        
##  7 Symptom Onset  Death       Exponential      "rate = 0.125"      "0 (0, 0.001…
##  8 Positive Test  Virtual     Generalized gam… "mu = -2.30, sigma… "0.072 (0.07…
##  9 Positive Test  Outpatient  Log normal       "logmean = -1.95, … "0.122 (0.12…
## 10 Positive Test  Urgent Care Generalized gam… "mu = -2.30, sigma… "0.37 (0.366…
## # ℹ 25 more rows
## # ℹ 4 more variables: Prob_t_15 <chr>, Median_Time <chr>, `25th` <chr>,
## #   `75th` <chr>
```

```r
test.table$Prob_t_15
```

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
```

```r
kable(test.table, col.names = c("Starting_State", "First_Event", "Distribution", "Parameters_Estimate", "Total Probability", "Probability_at_t = 15", "Median_Time_To_Event", "25th%_Time", "75th%_Time"), align = "c")  
```

<table>
 <thead>
  <tr>
   <th style="text-align:center;"> Starting_State </th>
   <th style="text-align:center;"> First_Event </th>
   <th style="text-align:center;"> Distribution </th>
   <th style="text-align:center;"> Parameters_Estimate </th>
   <th style="text-align:center;"> Total Probability </th>
   <th style="text-align:center;"> Probability_at_t = 15 </th>
   <th style="text-align:center;"> Median_Time_To_Event </th>
   <th style="text-align:center;"> 25th%_Time </th>
   <th style="text-align:center;"> 75th%_Time </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Symptom Onset </td>
   <td style="text-align:center;"> Virtual </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = 1.14, 
logsd = 0.804 </td>
   <td style="text-align:center;"> 0.081 
(0.08, 0.083) </td>
   <td style="text-align:center;"> 0.079 (0.078, 0.081) </td>
   <td style="text-align:center;"> 3.12 (3.07, 3.18) </td>
   <td style="text-align:center;"> 1.82 (1.78, 1.85) </td>
   <td style="text-align:center;"> 5.37 (5.26, 5.47) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Symptom Onset </td>
   <td style="text-align:center;"> Outpatient </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = 1.28, logsd = 0.781 </td>
   <td style="text-align:center;"> 0.127 (0.125, 0.129) </td>
   <td style="text-align:center;"> 0.123 (0.121, 0.125) </td>
   <td style="text-align:center;"> 3.59 (3.53, 3.66) </td>
   <td style="text-align:center;"> 2.12 (2.08, 2.16) </td>
   <td style="text-align:center;"> 6.09 (5.96, 6.2) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Symptom Onset </td>
   <td style="text-align:center;"> Urgent Care </td>
   <td style="text-align:center;"> Generalized gamma </td>
   <td style="text-align:center;"> mu = 0.940, sigma = 0.707, Q = -0.440 </td>
   <td style="text-align:center;"> 0.368 (0.364, 0.373) </td>
   <td style="text-align:center;"> 0.359 (0.354, 0.363) </td>
   <td style="text-align:center;"> 2.85 (2.8, 2.9) </td>
   <td style="text-align:center;"> 1.78 (1.75, 1.82) </td>
   <td style="text-align:center;"> 4.77 (4.67, 4.87) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Symptom Onset </td>
   <td style="text-align:center;"> Emergency </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = 1.23, logsd = 0.766 </td>
   <td style="text-align:center;"> 0.289 (0.285, 0.293) </td>
   <td style="text-align:center;"> 0.281 (0.277, 0.285) </td>
   <td style="text-align:center;"> 3.42 (3.36, 3.48) </td>
   <td style="text-align:center;"> 2.04 (2, 2.08) </td>
   <td style="text-align:center;"> 5.73 (5.61, 5.84) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Symptom Onset </td>
   <td style="text-align:center;"> Inpatient </td>
   <td style="text-align:center;"> Generalized gamma </td>
   <td style="text-align:center;"> mu = 1.73, sigma = 0.761, Q = 0.487 </td>
   <td style="text-align:center;"> 0.034 (0.033, 0.035) </td>
   <td style="text-align:center;"> 0.032 (0.031, 0.033) </td>
   <td style="text-align:center;"> 4.97 (4.8, 5.16) </td>
   <td style="text-align:center;"> 2.83 (2.74, 2.9) </td>
   <td style="text-align:center;"> 8.21 (7.98, 8.48) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Symptom Onset </td>
   <td style="text-align:center;"> Ventilation </td>
   <td style="text-align:center;"> NA/No events </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Symptom Onset </td>
   <td style="text-align:center;"> Death </td>
   <td style="text-align:center;"> Exponential </td>
   <td style="text-align:center;"> rate = 0.125 </td>
   <td style="text-align:center;"> 0 (0, 0.001) </td>
   <td style="text-align:center;"> 0 (0, 0.001) </td>
   <td style="text-align:center;"> 5.55 (2.54, 11.99) </td>
   <td style="text-align:center;"> 2.3 (1.06, 5.33) </td>
   <td style="text-align:center;"> 11.09 (5.11, 25.69) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Positive Test </td>
   <td style="text-align:center;"> Virtual </td>
   <td style="text-align:center;"> Generalized gamma </td>
   <td style="text-align:center;"> mu = -2.30, sigma = 0.0443, Q = -18.30 </td>
   <td style="text-align:center;"> 0.072 (0.07, 0.073) </td>
   <td style="text-align:center;"> 0.072 (0.07, 0.073) </td>
   <td style="text-align:center;"> 0.17 (0.17, 0.18) </td>
   <td style="text-align:center;"> 0.12 (0.12, 0.13) </td>
   <td style="text-align:center;"> 0.3 (0.29, 0.31) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Positive Test </td>
   <td style="text-align:center;"> Outpatient </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = -1.95, logsd = 1.22 </td>
   <td style="text-align:center;"> 0.122 (0.12, 0.124) </td>
   <td style="text-align:center;"> 0.122 (0.120, 0.124) </td>
   <td style="text-align:center;"> 0.14 (0.14, 0.15) </td>
   <td style="text-align:center;"> 0.06 (0.06, 0.06) </td>
   <td style="text-align:center;"> 0.33 (0.32, 0.33) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Positive Test </td>
   <td style="text-align:center;"> Urgent Care </td>
   <td style="text-align:center;"> Generalized gamma </td>
   <td style="text-align:center;"> mu = -2.30, sigma = -0.00314, Q = -17.9 </td>
   <td style="text-align:center;"> 0.37 (0.366, 0.375) </td>
   <td style="text-align:center;"> 0.370 (0.366, 0.375) </td>
   <td style="text-align:center;"> 0.1 (0.1, 0.11) </td>
   <td style="text-align:center;"> 0.1 (0.1, 0.1) </td>
   <td style="text-align:center;"> 0.11 (0.11, 0.11) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Positive Test </td>
   <td style="text-align:center;"> Emergency </td>
   <td style="text-align:center;"> Generalized gamma </td>
   <td style="text-align:center;"> mu = -2.30, sigma = 0.00431, Q = -13.30 </td>
   <td style="text-align:center;"> 0.322 (0.318, 0.327) </td>
   <td style="text-align:center;"> 0.322 (0.318, 0.327) </td>
   <td style="text-align:center;"> 0.1 (0.1, 0.11) </td>
   <td style="text-align:center;"> 0.1 (0.1, 0.1) </td>
   <td style="text-align:center;"> 0.11 (0.11, 0.11) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Positive Test </td>
   <td style="text-align:center;"> Inpatient </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = -2.17, logsd = 0.761 </td>
   <td style="text-align:center;"> 0.032 (0.032, 0.033) </td>
   <td style="text-align:center;"> 0.032 (0.032, 0.033) </td>
   <td style="text-align:center;"> 0.11 (0.11, 0.12) </td>
   <td style="text-align:center;"> 0.07 (0.07, 0.07) </td>
   <td style="text-align:center;"> 0.19 (0.19, 0.19) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Positive Test </td>
   <td style="text-align:center;"> Ventilation </td>
   <td style="text-align:center;"> Exponential </td>
   <td style="text-align:center;"> rate = 0.141 </td>
   <td style="text-align:center;"> 0 (0, 0.001) </td>
   <td style="text-align:center;"> 0 (0, 0.001) </td>
   <td style="text-align:center;"> 4.93 (2.48, 10.03) </td>
   <td style="text-align:center;"> 2.05 (0.99, 3.89) </td>
   <td style="text-align:center;"> 9.86 (4.79, 18.76) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Positive Test </td>
   <td style="text-align:center;"> Death </td>
   <td style="text-align:center;"> Gamma </td>
   <td style="text-align:center;"> shape = 0.573, rate = 0.0382 </td>
   <td style="text-align:center;"> 0.001 (0, 0.001) </td>
   <td style="text-align:center;"> 0.001 (0, 0.001) </td>
   <td style="text-align:center;"> 7.63 (2.78, 16.64) </td>
   <td style="text-align:center;"> 2 (0.37, 5.86) </td>
   <td style="text-align:center;"> 20.23 (9.97, 37.94) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Virtual </td>
   <td style="text-align:center;"> Outpatient </td>
   <td style="text-align:center;"> Gamma </td>
   <td style="text-align:center;"> shape = 0.512, rate = 0.0450 </td>
   <td style="text-align:center;"> 0.16 (0.158, 0.161) </td>
   <td style="text-align:center;"> 0.12 (0.117, 0.122) </td>
   <td style="text-align:center;"> 5.28 (5.11, 5.45) </td>
   <td style="text-align:center;"> 1.21 (1.09, 1.33) </td>
   <td style="text-align:center;"> 15.11 (14.15, 16.15) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Virtual </td>
   <td style="text-align:center;"> Urgent Care </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = 0.0259, logsd = 1.95 </td>
   <td style="text-align:center;"> 0.124 (0.123, 0.126) </td>
   <td style="text-align:center;"> 0.114 (0.111, 0.116) </td>
   <td style="text-align:center;"> 1.03 (0.86, 1.21) </td>
   <td style="text-align:center;"> 0.28 (0.23, 0.33) </td>
   <td style="text-align:center;"> 3.83 (3.19, 4.55) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Virtual </td>
   <td style="text-align:center;"> Emergency </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = -0.0618, logsd = 1.82 </td>
   <td style="text-align:center;"> 0.125 (0.123, 0.126) </td>
   <td style="text-align:center;"> 0.117 (0.115, 0.119) </td>
   <td style="text-align:center;"> 0.94 (0.79, 1.12) </td>
   <td style="text-align:center;"> 0.27 (0.23, 0.32) </td>
   <td style="text-align:center;"> 3.21 (2.7, 3.82) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Virtual </td>
   <td style="text-align:center;"> Inpatient </td>
   <td style="text-align:center;"> Weibull </td>
   <td style="text-align:center;"> shape = 0.590, scale = 6.07 </td>
   <td style="text-align:center;"> 0.017 (0.013, 0.021) </td>
   <td style="text-align:center;"> 0.014 (0.01, 0.017) </td>
   <td style="text-align:center;"> 3.26 (1.94, 5.29) </td>
   <td style="text-align:center;"> 0.74 (0.36, 1.45) </td>
   <td style="text-align:center;"> 10.56 (7, 16.33) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Virtual </td>
   <td style="text-align:center;"> Ventilation </td>
   <td style="text-align:center;"> Gompertz </td>
   <td style="text-align:center;"> shape = 0.149, rate = 0.0000792 </td>
   <td style="text-align:center;"> 0 (0, 0.002) </td>
   <td style="text-align:center;"> 0 (0, 0.001) </td>
   <td style="text-align:center;"> 48.23 (0.02, 51.96) </td>
   <td style="text-align:center;"> 42.33 (0.01, 48.27) </td>
   <td style="text-align:center;"> 52.89 (0.04, 56.78) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Virtual </td>
   <td style="text-align:center;"> Death </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = 3.38, logsd = 0.342 </td>
   <td style="text-align:center;"> 0.001 (0, 0.003) </td>
   <td style="text-align:center;"> 0 (0, 0) </td>
   <td style="text-align:center;"> 29.2 (21.3, 41.2) </td>
   <td style="text-align:center;"> 23.22 (15.48, 33.35) </td>
   <td style="text-align:center;"> 36.85 (26.1, 55.55) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Outpatient </td>
   <td style="text-align:center;"> Urgent Care </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = -0.572, logsd = 2.27 </td>
   <td style="text-align:center;"> 0.154 (0.152, 0.155) </td>
   <td style="text-align:center;"> 0.142 (0.14, 0.144) </td>
   <td style="text-align:center;"> 0.56 (0.48, 0.67) </td>
   <td style="text-align:center;"> 0.12 (0.1, 0.14) </td>
   <td style="text-align:center;"> 2.62 (2.21, 3.1) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Outpatient </td>
   <td style="text-align:center;"> Emergency </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = 0.288, logsd = 2.02 </td>
   <td style="text-align:center;"> 0.088 (0.087, 0.089) </td>
   <td style="text-align:center;"> 0.078 (0.076, 0.08) </td>
   <td style="text-align:center;"> 1.33 (1.09, 1.63) </td>
   <td style="text-align:center;"> 0.34 (0.28, 0.41) </td>
   <td style="text-align:center;"> 5.19 (4.24, 6.29) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Outpatient </td>
   <td style="text-align:center;"> Inpatient </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = 0.181, logsd = 2.30 </td>
   <td style="text-align:center;"> 0.027 (0.023, 0.032) </td>
   <td style="text-align:center;"> 0.023 (0.019, 0.028) </td>
   <td style="text-align:center;"> 1.2 (0.8, 1.85) </td>
   <td style="text-align:center;"> 0.25 (0.17, 0.39) </td>
   <td style="text-align:center;"> 5.65 (3.78, 8.59) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Outpatient </td>
   <td style="text-align:center;"> Ventilation </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = -0.574, logsd = 1.82 </td>
   <td style="text-align:center;"> 0.002 (0.001, 0.004) </td>
   <td style="text-align:center;"> 0.002 (0.001, 0.004) </td>
   <td style="text-align:center;"> 0.56 (0.16, 1.77) </td>
   <td style="text-align:center;"> 0.17 (0.04, 0.61) </td>
   <td style="text-align:center;"> 1.92 (0.51, 7.84) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Outpatient </td>
   <td style="text-align:center;"> Death </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = 2.02, logsd = 1.31 </td>
   <td style="text-align:center;"> 0.004 (0.003, 0.007) </td>
   <td style="text-align:center;"> 0.003 (0.002, 0.005) </td>
   <td style="text-align:center;"> 7.55 (4.16, 12.9) </td>
   <td style="text-align:center;"> 3.12 (1.58, 5.88) </td>
   <td style="text-align:center;"> 18.23 (9.65, 35.48) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Urgent Care </td>
   <td style="text-align:center;"> Emergency </td>
   <td style="text-align:center;"> Generalized gamma </td>
   <td style="text-align:center;"> mu = -2.29, sigma = 0.132, Q = -15.80 </td>
   <td style="text-align:center;"> 0.082 (0.081, 0.083) </td>
   <td style="text-align:center;"> 0.075 (0.073, 0.083) </td>
   <td style="text-align:center;"> 0.41 (0.38, 0.42) </td>
   <td style="text-align:center;"> 0.18 (0.17, 0.18) </td>
   <td style="text-align:center;"> 1.75 (1.54, 1.84) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Urgent Care </td>
   <td style="text-align:center;"> Inpatient </td>
   <td style="text-align:center;"> Generalized gamma </td>
   <td style="text-align:center;"> mu = -2.29, sigma = 0.146, Q = -12.70 </td>
   <td style="text-align:center;"> 0.014 (0.014, 0.015) </td>
   <td style="text-align:center;"> 0.013 (0.013, 0.014) </td>
   <td style="text-align:center;"> 0.34 (0.27, 0.35) </td>
   <td style="text-align:center;"> 0.16 (0.14, 0.17) </td>
   <td style="text-align:center;"> 1.24 (0.79, 1.28) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Urgent Care </td>
   <td style="text-align:center;"> Ventilation </td>
   <td style="text-align:center;"> NA/No events </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Urgent Care </td>
   <td style="text-align:center;"> Death </td>
   <td style="text-align:center;"> Exponential </td>
   <td style="text-align:center;"> rate = 0.250 </td>
   <td style="text-align:center;"> 0 (0, 0.001) </td>
   <td style="text-align:center;"> 0 (0, 0.001) </td>
   <td style="text-align:center;"> 2.77 (0.44, 20.59) </td>
   <td style="text-align:center;"> 1.15 (0.16, 9.51) </td>
   <td style="text-align:center;"> 5.54 (0.79, 45.81) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Emergency </td>
   <td style="text-align:center;"> Inpatient </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = 0.362, logsd = 2.16 </td>
   <td style="text-align:center;"> 0.041 (0.041, 0.042) </td>
   <td style="text-align:center;"> 0.036 (0.034, 0.037) </td>
   <td style="text-align:center;"> 1.44 (1.13, 1.84) </td>
   <td style="text-align:center;"> 0.33 (0.27, 0.42) </td>
   <td style="text-align:center;"> 6.17 (4.76, 7.95) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Emergency </td>
   <td style="text-align:center;"> Ventilation </td>
   <td style="text-align:center;"> Weibull </td>
   <td style="text-align:center;"> shape = 0.491, scale = 3.40 </td>
   <td style="text-align:center;"> 0.001 (0.001, 0.002) </td>
   <td style="text-align:center;"> 0.001 (0.001, 0.002) </td>
   <td style="text-align:center;"> 1.61 (0.29, 6.25) </td>
   <td style="text-align:center;"> 0.27 (0.02, 1.89) </td>
   <td style="text-align:center;"> 6.62 (1.7, 26.96) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Emergency </td>
   <td style="text-align:center;"> Death </td>
   <td style="text-align:center;"> Gompertz </td>
   <td style="text-align:center;"> shape = 0.0496, rate = 0.0130 </td>
   <td style="text-align:center;"> 0.003 (0.002, 0.004) </td>
   <td style="text-align:center;"> 0.001 (0, 0.001) </td>
   <td style="text-align:center;"> 26.05 (15.88, 32.51) </td>
   <td style="text-align:center;"> 14.91 (7.74, 22.21) </td>
   <td style="text-align:center;"> 37.05 (28.01, 43.62) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Inpatient </td>
   <td style="text-align:center;"> Ventilation </td>
   <td style="text-align:center;"> Generalized gamma </td>
   <td style="text-align:center;"> mu = 0.095, sigma = 1.94, Q = 0.00 </td>
   <td style="text-align:center;"> 0.068 (0.055, 0.085) </td>
   <td style="text-align:center;"> 0.062 (0.049, 0.078) </td>
   <td style="text-align:center;"> 1.1 (0.07, 1.13) </td>
   <td style="text-align:center;"> 0.3 (0.29, 0.31) </td>
   <td style="text-align:center;"> 7.82 (5.39, 10.88) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Inpatient </td>
   <td style="text-align:center;"> Death </td>
   <td style="text-align:center;"> Gompertz </td>
   <td style="text-align:center;"> shape = 0.0148, rate = 0.0347 </td>
   <td style="text-align:center;"> 0.055 (0.044, 0.07) </td>
   <td style="text-align:center;"> 0.024 (0.016, 0.034) </td>
   <td style="text-align:center;"> 17.5 (2.44, 23.52) </td>
   <td style="text-align:center;"> 4.06 (3.91, 4.22) </td>
   <td style="text-align:center;"> 31.38 (23.53, 44.89) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Ventilation </td>
   <td style="text-align:center;"> Death </td>
   <td style="text-align:center;"> Gamma </td>
   <td style="text-align:center;"> shape = 0.538, rate = 0.0471 </td>
   <td style="text-align:center;"> 0.345 (0.254, 0.457) </td>
   <td style="text-align:center;"> 0.257 (0.184, 0.348) </td>
   <td style="text-align:center;"> 5.52 (2.87, 9.58) </td>
   <td style="text-align:center;"> 1.35 (0.40, 3.19) </td>
   <td style="text-align:center;"> 15.28 (9.02, 24.68) </td>
  </tr>
</tbody>
</table>

```r
kable(test.table, col.names = c("Starting_State", "First_Event", "Distribution", "Parameters_Estimate", "Total Probability", "Probability_at_t = 15", "Median_Time_To_Event", "25th%_Time", "75th%_Time"), align = "c") %>%
  kable_styling(bootstrap_options = c("striped", "hover"), full_width = F)
```

<table class="table table-striped table-hover" style="width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:center;"> Starting_State </th>
   <th style="text-align:center;"> First_Event </th>
   <th style="text-align:center;"> Distribution </th>
   <th style="text-align:center;"> Parameters_Estimate </th>
   <th style="text-align:center;"> Total Probability </th>
   <th style="text-align:center;"> Probability_at_t = 15 </th>
   <th style="text-align:center;"> Median_Time_To_Event </th>
   <th style="text-align:center;"> 25th%_Time </th>
   <th style="text-align:center;"> 75th%_Time </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Symptom Onset </td>
   <td style="text-align:center;"> Virtual </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = 1.14, 
logsd = 0.804 </td>
   <td style="text-align:center;"> 0.081 
(0.08, 0.083) </td>
   <td style="text-align:center;"> 0.079 (0.078, 0.081) </td>
   <td style="text-align:center;"> 3.12 (3.07, 3.18) </td>
   <td style="text-align:center;"> 1.82 (1.78, 1.85) </td>
   <td style="text-align:center;"> 5.37 (5.26, 5.47) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Symptom Onset </td>
   <td style="text-align:center;"> Outpatient </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = 1.28, logsd = 0.781 </td>
   <td style="text-align:center;"> 0.127 (0.125, 0.129) </td>
   <td style="text-align:center;"> 0.123 (0.121, 0.125) </td>
   <td style="text-align:center;"> 3.59 (3.53, 3.66) </td>
   <td style="text-align:center;"> 2.12 (2.08, 2.16) </td>
   <td style="text-align:center;"> 6.09 (5.96, 6.2) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Symptom Onset </td>
   <td style="text-align:center;"> Urgent Care </td>
   <td style="text-align:center;"> Generalized gamma </td>
   <td style="text-align:center;"> mu = 0.940, sigma = 0.707, Q = -0.440 </td>
   <td style="text-align:center;"> 0.368 (0.364, 0.373) </td>
   <td style="text-align:center;"> 0.359 (0.354, 0.363) </td>
   <td style="text-align:center;"> 2.85 (2.8, 2.9) </td>
   <td style="text-align:center;"> 1.78 (1.75, 1.82) </td>
   <td style="text-align:center;"> 4.77 (4.67, 4.87) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Symptom Onset </td>
   <td style="text-align:center;"> Emergency </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = 1.23, logsd = 0.766 </td>
   <td style="text-align:center;"> 0.289 (0.285, 0.293) </td>
   <td style="text-align:center;"> 0.281 (0.277, 0.285) </td>
   <td style="text-align:center;"> 3.42 (3.36, 3.48) </td>
   <td style="text-align:center;"> 2.04 (2, 2.08) </td>
   <td style="text-align:center;"> 5.73 (5.61, 5.84) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Symptom Onset </td>
   <td style="text-align:center;"> Inpatient </td>
   <td style="text-align:center;"> Generalized gamma </td>
   <td style="text-align:center;"> mu = 1.73, sigma = 0.761, Q = 0.487 </td>
   <td style="text-align:center;"> 0.034 (0.033, 0.035) </td>
   <td style="text-align:center;"> 0.032 (0.031, 0.033) </td>
   <td style="text-align:center;"> 4.97 (4.8, 5.16) </td>
   <td style="text-align:center;"> 2.83 (2.74, 2.9) </td>
   <td style="text-align:center;"> 8.21 (7.98, 8.48) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Symptom Onset </td>
   <td style="text-align:center;"> Ventilation </td>
   <td style="text-align:center;"> NA/No events </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Symptom Onset </td>
   <td style="text-align:center;"> Death </td>
   <td style="text-align:center;"> Exponential </td>
   <td style="text-align:center;"> rate = 0.125 </td>
   <td style="text-align:center;"> 0 (0, 0.001) </td>
   <td style="text-align:center;"> 0 (0, 0.001) </td>
   <td style="text-align:center;"> 5.55 (2.54, 11.99) </td>
   <td style="text-align:center;"> 2.3 (1.06, 5.33) </td>
   <td style="text-align:center;"> 11.09 (5.11, 25.69) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Positive Test </td>
   <td style="text-align:center;"> Virtual </td>
   <td style="text-align:center;"> Generalized gamma </td>
   <td style="text-align:center;"> mu = -2.30, sigma = 0.0443, Q = -18.30 </td>
   <td style="text-align:center;"> 0.072 (0.07, 0.073) </td>
   <td style="text-align:center;"> 0.072 (0.07, 0.073) </td>
   <td style="text-align:center;"> 0.17 (0.17, 0.18) </td>
   <td style="text-align:center;"> 0.12 (0.12, 0.13) </td>
   <td style="text-align:center;"> 0.3 (0.29, 0.31) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Positive Test </td>
   <td style="text-align:center;"> Outpatient </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = -1.95, logsd = 1.22 </td>
   <td style="text-align:center;"> 0.122 (0.12, 0.124) </td>
   <td style="text-align:center;"> 0.122 (0.120, 0.124) </td>
   <td style="text-align:center;"> 0.14 (0.14, 0.15) </td>
   <td style="text-align:center;"> 0.06 (0.06, 0.06) </td>
   <td style="text-align:center;"> 0.33 (0.32, 0.33) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Positive Test </td>
   <td style="text-align:center;"> Urgent Care </td>
   <td style="text-align:center;"> Generalized gamma </td>
   <td style="text-align:center;"> mu = -2.30, sigma = -0.00314, Q = -17.9 </td>
   <td style="text-align:center;"> 0.37 (0.366, 0.375) </td>
   <td style="text-align:center;"> 0.370 (0.366, 0.375) </td>
   <td style="text-align:center;"> 0.1 (0.1, 0.11) </td>
   <td style="text-align:center;"> 0.1 (0.1, 0.1) </td>
   <td style="text-align:center;"> 0.11 (0.11, 0.11) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Positive Test </td>
   <td style="text-align:center;"> Emergency </td>
   <td style="text-align:center;"> Generalized gamma </td>
   <td style="text-align:center;"> mu = -2.30, sigma = 0.00431, Q = -13.30 </td>
   <td style="text-align:center;"> 0.322 (0.318, 0.327) </td>
   <td style="text-align:center;"> 0.322 (0.318, 0.327) </td>
   <td style="text-align:center;"> 0.1 (0.1, 0.11) </td>
   <td style="text-align:center;"> 0.1 (0.1, 0.1) </td>
   <td style="text-align:center;"> 0.11 (0.11, 0.11) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Positive Test </td>
   <td style="text-align:center;"> Inpatient </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = -2.17, logsd = 0.761 </td>
   <td style="text-align:center;"> 0.032 (0.032, 0.033) </td>
   <td style="text-align:center;"> 0.032 (0.032, 0.033) </td>
   <td style="text-align:center;"> 0.11 (0.11, 0.12) </td>
   <td style="text-align:center;"> 0.07 (0.07, 0.07) </td>
   <td style="text-align:center;"> 0.19 (0.19, 0.19) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Positive Test </td>
   <td style="text-align:center;"> Ventilation </td>
   <td style="text-align:center;"> Exponential </td>
   <td style="text-align:center;"> rate = 0.141 </td>
   <td style="text-align:center;"> 0 (0, 0.001) </td>
   <td style="text-align:center;"> 0 (0, 0.001) </td>
   <td style="text-align:center;"> 4.93 (2.48, 10.03) </td>
   <td style="text-align:center;"> 2.05 (0.99, 3.89) </td>
   <td style="text-align:center;"> 9.86 (4.79, 18.76) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Positive Test </td>
   <td style="text-align:center;"> Death </td>
   <td style="text-align:center;"> Gamma </td>
   <td style="text-align:center;"> shape = 0.573, rate = 0.0382 </td>
   <td style="text-align:center;"> 0.001 (0, 0.001) </td>
   <td style="text-align:center;"> 0.001 (0, 0.001) </td>
   <td style="text-align:center;"> 7.63 (2.78, 16.64) </td>
   <td style="text-align:center;"> 2 (0.37, 5.86) </td>
   <td style="text-align:center;"> 20.23 (9.97, 37.94) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Virtual </td>
   <td style="text-align:center;"> Outpatient </td>
   <td style="text-align:center;"> Gamma </td>
   <td style="text-align:center;"> shape = 0.512, rate = 0.0450 </td>
   <td style="text-align:center;"> 0.16 (0.158, 0.161) </td>
   <td style="text-align:center;"> 0.12 (0.117, 0.122) </td>
   <td style="text-align:center;"> 5.28 (5.11, 5.45) </td>
   <td style="text-align:center;"> 1.21 (1.09, 1.33) </td>
   <td style="text-align:center;"> 15.11 (14.15, 16.15) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Virtual </td>
   <td style="text-align:center;"> Urgent Care </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = 0.0259, logsd = 1.95 </td>
   <td style="text-align:center;"> 0.124 (0.123, 0.126) </td>
   <td style="text-align:center;"> 0.114 (0.111, 0.116) </td>
   <td style="text-align:center;"> 1.03 (0.86, 1.21) </td>
   <td style="text-align:center;"> 0.28 (0.23, 0.33) </td>
   <td style="text-align:center;"> 3.83 (3.19, 4.55) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Virtual </td>
   <td style="text-align:center;"> Emergency </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = -0.0618, logsd = 1.82 </td>
   <td style="text-align:center;"> 0.125 (0.123, 0.126) </td>
   <td style="text-align:center;"> 0.117 (0.115, 0.119) </td>
   <td style="text-align:center;"> 0.94 (0.79, 1.12) </td>
   <td style="text-align:center;"> 0.27 (0.23, 0.32) </td>
   <td style="text-align:center;"> 3.21 (2.7, 3.82) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Virtual </td>
   <td style="text-align:center;"> Inpatient </td>
   <td style="text-align:center;"> Weibull </td>
   <td style="text-align:center;"> shape = 0.590, scale = 6.07 </td>
   <td style="text-align:center;"> 0.017 (0.013, 0.021) </td>
   <td style="text-align:center;"> 0.014 (0.01, 0.017) </td>
   <td style="text-align:center;"> 3.26 (1.94, 5.29) </td>
   <td style="text-align:center;"> 0.74 (0.36, 1.45) </td>
   <td style="text-align:center;"> 10.56 (7, 16.33) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Virtual </td>
   <td style="text-align:center;"> Ventilation </td>
   <td style="text-align:center;"> Gompertz </td>
   <td style="text-align:center;"> shape = 0.149, rate = 0.0000792 </td>
   <td style="text-align:center;"> 0 (0, 0.002) </td>
   <td style="text-align:center;"> 0 (0, 0.001) </td>
   <td style="text-align:center;"> 48.23 (0.02, 51.96) </td>
   <td style="text-align:center;"> 42.33 (0.01, 48.27) </td>
   <td style="text-align:center;"> 52.89 (0.04, 56.78) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Virtual </td>
   <td style="text-align:center;"> Death </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = 3.38, logsd = 0.342 </td>
   <td style="text-align:center;"> 0.001 (0, 0.003) </td>
   <td style="text-align:center;"> 0 (0, 0) </td>
   <td style="text-align:center;"> 29.2 (21.3, 41.2) </td>
   <td style="text-align:center;"> 23.22 (15.48, 33.35) </td>
   <td style="text-align:center;"> 36.85 (26.1, 55.55) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Outpatient </td>
   <td style="text-align:center;"> Urgent Care </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = -0.572, logsd = 2.27 </td>
   <td style="text-align:center;"> 0.154 (0.152, 0.155) </td>
   <td style="text-align:center;"> 0.142 (0.14, 0.144) </td>
   <td style="text-align:center;"> 0.56 (0.48, 0.67) </td>
   <td style="text-align:center;"> 0.12 (0.1, 0.14) </td>
   <td style="text-align:center;"> 2.62 (2.21, 3.1) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Outpatient </td>
   <td style="text-align:center;"> Emergency </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = 0.288, logsd = 2.02 </td>
   <td style="text-align:center;"> 0.088 (0.087, 0.089) </td>
   <td style="text-align:center;"> 0.078 (0.076, 0.08) </td>
   <td style="text-align:center;"> 1.33 (1.09, 1.63) </td>
   <td style="text-align:center;"> 0.34 (0.28, 0.41) </td>
   <td style="text-align:center;"> 5.19 (4.24, 6.29) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Outpatient </td>
   <td style="text-align:center;"> Inpatient </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = 0.181, logsd = 2.30 </td>
   <td style="text-align:center;"> 0.027 (0.023, 0.032) </td>
   <td style="text-align:center;"> 0.023 (0.019, 0.028) </td>
   <td style="text-align:center;"> 1.2 (0.8, 1.85) </td>
   <td style="text-align:center;"> 0.25 (0.17, 0.39) </td>
   <td style="text-align:center;"> 5.65 (3.78, 8.59) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Outpatient </td>
   <td style="text-align:center;"> Ventilation </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = -0.574, logsd = 1.82 </td>
   <td style="text-align:center;"> 0.002 (0.001, 0.004) </td>
   <td style="text-align:center;"> 0.002 (0.001, 0.004) </td>
   <td style="text-align:center;"> 0.56 (0.16, 1.77) </td>
   <td style="text-align:center;"> 0.17 (0.04, 0.61) </td>
   <td style="text-align:center;"> 1.92 (0.51, 7.84) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Outpatient </td>
   <td style="text-align:center;"> Death </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = 2.02, logsd = 1.31 </td>
   <td style="text-align:center;"> 0.004 (0.003, 0.007) </td>
   <td style="text-align:center;"> 0.003 (0.002, 0.005) </td>
   <td style="text-align:center;"> 7.55 (4.16, 12.9) </td>
   <td style="text-align:center;"> 3.12 (1.58, 5.88) </td>
   <td style="text-align:center;"> 18.23 (9.65, 35.48) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Urgent Care </td>
   <td style="text-align:center;"> Emergency </td>
   <td style="text-align:center;"> Generalized gamma </td>
   <td style="text-align:center;"> mu = -2.29, sigma = 0.132, Q = -15.80 </td>
   <td style="text-align:center;"> 0.082 (0.081, 0.083) </td>
   <td style="text-align:center;"> 0.075 (0.073, 0.083) </td>
   <td style="text-align:center;"> 0.41 (0.38, 0.42) </td>
   <td style="text-align:center;"> 0.18 (0.17, 0.18) </td>
   <td style="text-align:center;"> 1.75 (1.54, 1.84) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Urgent Care </td>
   <td style="text-align:center;"> Inpatient </td>
   <td style="text-align:center;"> Generalized gamma </td>
   <td style="text-align:center;"> mu = -2.29, sigma = 0.146, Q = -12.70 </td>
   <td style="text-align:center;"> 0.014 (0.014, 0.015) </td>
   <td style="text-align:center;"> 0.013 (0.013, 0.014) </td>
   <td style="text-align:center;"> 0.34 (0.27, 0.35) </td>
   <td style="text-align:center;"> 0.16 (0.14, 0.17) </td>
   <td style="text-align:center;"> 1.24 (0.79, 1.28) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Urgent Care </td>
   <td style="text-align:center;"> Ventilation </td>
   <td style="text-align:center;"> NA/No events </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Urgent Care </td>
   <td style="text-align:center;"> Death </td>
   <td style="text-align:center;"> Exponential </td>
   <td style="text-align:center;"> rate = 0.250 </td>
   <td style="text-align:center;"> 0 (0, 0.001) </td>
   <td style="text-align:center;"> 0 (0, 0.001) </td>
   <td style="text-align:center;"> 2.77 (0.44, 20.59) </td>
   <td style="text-align:center;"> 1.15 (0.16, 9.51) </td>
   <td style="text-align:center;"> 5.54 (0.79, 45.81) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Emergency </td>
   <td style="text-align:center;"> Inpatient </td>
   <td style="text-align:center;"> Log normal </td>
   <td style="text-align:center;"> logmean = 0.362, logsd = 2.16 </td>
   <td style="text-align:center;"> 0.041 (0.041, 0.042) </td>
   <td style="text-align:center;"> 0.036 (0.034, 0.037) </td>
   <td style="text-align:center;"> 1.44 (1.13, 1.84) </td>
   <td style="text-align:center;"> 0.33 (0.27, 0.42) </td>
   <td style="text-align:center;"> 6.17 (4.76, 7.95) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Emergency </td>
   <td style="text-align:center;"> Ventilation </td>
   <td style="text-align:center;"> Weibull </td>
   <td style="text-align:center;"> shape = 0.491, scale = 3.40 </td>
   <td style="text-align:center;"> 0.001 (0.001, 0.002) </td>
   <td style="text-align:center;"> 0.001 (0.001, 0.002) </td>
   <td style="text-align:center;"> 1.61 (0.29, 6.25) </td>
   <td style="text-align:center;"> 0.27 (0.02, 1.89) </td>
   <td style="text-align:center;"> 6.62 (1.7, 26.96) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Emergency </td>
   <td style="text-align:center;"> Death </td>
   <td style="text-align:center;"> Gompertz </td>
   <td style="text-align:center;"> shape = 0.0496, rate = 0.0130 </td>
   <td style="text-align:center;"> 0.003 (0.002, 0.004) </td>
   <td style="text-align:center;"> 0.001 (0, 0.001) </td>
   <td style="text-align:center;"> 26.05 (15.88, 32.51) </td>
   <td style="text-align:center;"> 14.91 (7.74, 22.21) </td>
   <td style="text-align:center;"> 37.05 (28.01, 43.62) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Inpatient </td>
   <td style="text-align:center;"> Ventilation </td>
   <td style="text-align:center;"> Generalized gamma </td>
   <td style="text-align:center;"> mu = 0.095, sigma = 1.94, Q = 0.00 </td>
   <td style="text-align:center;"> 0.068 (0.055, 0.085) </td>
   <td style="text-align:center;"> 0.062 (0.049, 0.078) </td>
   <td style="text-align:center;"> 1.1 (0.07, 1.13) </td>
   <td style="text-align:center;"> 0.3 (0.29, 0.31) </td>
   <td style="text-align:center;"> 7.82 (5.39, 10.88) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Inpatient </td>
   <td style="text-align:center;"> Death </td>
   <td style="text-align:center;"> Gompertz </td>
   <td style="text-align:center;"> shape = 0.0148, rate = 0.0347 </td>
   <td style="text-align:center;"> 0.055 (0.044, 0.07) </td>
   <td style="text-align:center;"> 0.024 (0.016, 0.034) </td>
   <td style="text-align:center;"> 17.5 (2.44, 23.52) </td>
   <td style="text-align:center;"> 4.06 (3.91, 4.22) </td>
   <td style="text-align:center;"> 31.38 (23.53, 44.89) </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Ventilation </td>
   <td style="text-align:center;"> Death </td>
   <td style="text-align:center;"> Gamma </td>
   <td style="text-align:center;"> shape = 0.538, rate = 0.0471 </td>
   <td style="text-align:center;"> 0.345 (0.254, 0.457) </td>
   <td style="text-align:center;"> 0.257 (0.184, 0.348) </td>
   <td style="text-align:center;"> 5.52 (2.87, 9.58) </td>
   <td style="text-align:center;"> 1.35 (0.40, 3.19) </td>
   <td style="text-align:center;"> 15.28 (9.02, 24.68) </td>
  </tr>
</tbody>
</table>

## Including Plots

You can also embed plots, for example:

![](Test_files/figure-html/pressure-1.png)<!-- -->

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
