Parameterizing healthcare utilization transitions of respiratory
pathogens using EHR data
================



## Background and motivation

Knowledge of the transitions between healthcare utilization states, such
as virtual care, urgent care, or hospitalization, is important for the
effectiveness of prediction models and public health planning
strategies. Yet, most of the distributions for such transitions for
respiratory diseases remain unknown. Using Kaiser Permanente electronic
health records, we parameterized time-to-event transition distributions
for COVID-19, Influenza, and RSV. This will allow for better informed
prediction models, as well as enable us to answer questions about how
people infected with respiratory diseases are moving through the
healthcare system and who is accessing certain types of care.

<img width="1465" alt="Screenshot 2024-12-15 at 2 36 31 PM" src="https://github.com/user-attachments/assets/72a42306-1dea-4567-bdbd-9a0c7e556e50" />
The "healthcare utilization cascade."



## Types of analysis

For all three pathogens, we parameterized two types of transitions — the
*first event* to occur following a *starting event*, as well as *outcome
or more severe* for each outcome from a *starting event*. The first
transition type can help answer questions about how people are moving
through the healthcare cascade (link presentation or video). The
*outcome or more severe* transition type can inform prediction and
forecast models by answering how many people will seek at least a
certain level of care in the healthcare cascade.

The *outcome or more severe* analysis was further parameterized by
certain demographic covariates, such as age, gender, and vaccination
status. Some covariates, such as age and Charlson weight, have large
effects on the probability of needing any or higher levels of care. Yet,
no variables have a meaningful impact — on the order of around half a
day — on the rate of seeking such care. We provide the rate estimates
for *Outpatient or worse* and *Inpatient or worse* for reference, though
under the expectations that the rates don’t differ enough to merit
inclusion into most models.

## Data Use

The tables containing the parameterized distributions, probability of
occurence, and time-to-event estimates (examples below) for COVID-19,
Influenza, and RSV are provided in the *Parameter_Tables* folder. The
methods and further discussion of these results will be provided in an
upcoming paper (link will be provided here when published). To cite,
please…

## Methods

We used the flexsurv package in R, which allowed us to create parametric
competing risks mixture models for each type of analysis. We employed a
competing risk mixture model because, for each model, there are multiple
states that someone can move to, some of which might occur before future
events. This package is also useful because it allows for flexibility in
distributions. Using AIC, we compared the models’ performance using
different distributions to find the best fitting distribution for each
transition of interest.

<img width="862" alt="inclusion_methods" src="https://github.com/user-attachments/assets/8c84d036-5b5b-408d-8ab6-333597b808bb" /> 

Graphical representation of inclusions criteria. 

Above shows a figure describing our inclusion criteria for acute
respiratory infection events. We looked between -7 and +30 days of a
positive test to find events. From those events, we looked 60 days out
to either the first event, or most severe event.

This criteria allowed us to restrict ARI healthcare events to being
related/caused by COVID infections, while still including healthcare
events that might take more than 30 days (like death) after the initial
event.

## Example Outputs

Below are example outputs for the first event and outcome or worse
analyses (along with the stratified estimates) for COVID-19.

## First Event

The “First Event” following a “Starting State” for COVID Infections:

*For example, there is a 36.8% chance that the first event following
symptom onset is an urgent care visit. The median time to these urgent
care visits is 2.85 days following symptom onset.*

<table>
<caption>
The first event following every state for COVID-19 infections
</caption>
<thead>
<tr>
<th style="text-align:center;">
Starting State
</th>
<th style="text-align:center;">
First Event
</th>
<th style="text-align:center;">
Distribution
</th>
<th style="text-align:center;">
Parameter 1
</th>
<th style="text-align:center;">
Parameter 2
</th>
<th style="text-align:center;">
Parameter 3
</th>
<th style="text-align:center;">
Total Probability
</th>
<th style="text-align:center;">
Probability at t = 15
</th>
<th style="text-align:center;">
Median Time To Event
</th>
<th style="text-align:center;">
25th% Time
</th>
<th style="text-align:center;">
75th% Time
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
Symptom Onset
</td>
<td style="text-align:center;">
Virtual
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 1.14
</td>
<td style="text-align:center;">
logsd = 0.804
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.081 (0.080, 0.083)
</td>
<td style="text-align:center;">
0.079 (0.078, 0.081)
</td>
<td style="text-align:center;">
3.12 (3.07, 3.18)
</td>
<td style="text-align:center;">
1.82 (1.78, 1.85)
</td>
<td style="text-align:center;">
5.37 (5.26, 5.47)
</td>
</tr>
<tr>
<td style="text-align:center;">
Symptom Onset
</td>
<td style="text-align:center;">
Outpatient
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 1.28
</td>
<td style="text-align:center;">
logsd = 0.781
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.127 (0.125, 0.129)
</td>
<td style="text-align:center;">
0.123 (0.121, 0.125)
</td>
<td style="text-align:center;">
3.59 (3.53, 3.66)
</td>
<td style="text-align:center;">
2.12 (2.08, 2.16)
</td>
<td style="text-align:center;">
6.09 (5.96, 6.20)
</td>
</tr>
<tr>
<td style="text-align:center;">
Symptom Onset
</td>
<td style="text-align:center;">
Urgent Care
</td>
<td style="text-align:center;">
Generalized gamma
</td>
<td style="text-align:center;">
mu = 0.940
</td>
<td style="text-align:center;">
sigma = 0.707
</td>
<td style="text-align:center;">
Q = -0.440
</td>
<td style="text-align:center;">
0.368 (0.364, 0.373)
</td>
<td style="text-align:center;">
0.359 (0.354, 0.363)
</td>
<td style="text-align:center;">
2.85 (2.80, 2.90)
</td>
<td style="text-align:center;">
1.78 (1.75, 1.82)
</td>
<td style="text-align:center;">
4.77 (4.67, 4.87)
</td>
</tr>
<tr>
<td style="text-align:center;">
Symptom Onset
</td>
<td style="text-align:center;">
Emergency
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 1.23
</td>
<td style="text-align:center;">
logsd = 0.766
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.289 (0.285, 0.293)
</td>
<td style="text-align:center;">
0.281 (0.277, 0.285)
</td>
<td style="text-align:center;">
3.42 (3.36, 3.48)
</td>
<td style="text-align:center;">
2.04 (2.00, 2.08)
</td>
<td style="text-align:center;">
5.73 (5.61, 5.84)
</td>
</tr>
<tr>
<td style="text-align:center;">
Symptom Onset
</td>
<td style="text-align:center;">
Inpatient
</td>
<td style="text-align:center;">
Generalized gamma
</td>
<td style="text-align:center;">
mu = 1.73
</td>
<td style="text-align:center;">
sigma = 0.761
</td>
<td style="text-align:center;">
Q = 0.487
</td>
<td style="text-align:center;">
0.034 (0.033, 0.035)
</td>
<td style="text-align:center;">
0.032 (0.031, 0.033)
</td>
<td style="text-align:center;">
4.97 (4.80, 5.16)
</td>
<td style="text-align:center;">
2.83 (2.74, 2.90)
</td>
<td style="text-align:center;">
8.21 (7.98, 8.48)
</td>
</tr>
<tr>
<td style="text-align:center;">
Symptom Onset
</td>
<td style="text-align:center;">
Ventilation
</td>
<td style="text-align:center;">
NA/No events
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
</tr>
<tr>
<td style="text-align:center;">
Symptom Onset
</td>
<td style="text-align:center;">
Death
</td>
<td style="text-align:center;">
Exponential
</td>
<td style="text-align:center;">
rate = 0.125
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.000 (0.000, 0.001)
</td>
<td style="text-align:center;">
0.000 (0.000, 0.001)
</td>
<td style="text-align:center;">
5.55 (2.54, 11.99)
</td>
<td style="text-align:center;">
2.30 (1.06, 5.33)
</td>
<td style="text-align:center;">
11.09 (5.11, 25.69)
</td>
</tr>
<tr>
<td style="text-align:center;">
Positive Test
</td>
<td style="text-align:center;">
Virtual
</td>
<td style="text-align:center;">
Generalized gamma
</td>
<td style="text-align:center;">
mu = -2.30
</td>
<td style="text-align:center;">
sigma = 0.0443
</td>
<td style="text-align:center;">
Q = -18.30
</td>
<td style="text-align:center;">
0.072 (0.070, 0.073)
</td>
<td style="text-align:center;">
0.072 (0.070, 0.073)
</td>
<td style="text-align:center;">
0.17 (0.17, 0.18)
</td>
<td style="text-align:center;">
0.12 (0.12, 0.13)
</td>
<td style="text-align:center;">
0.30 (0.29, 0.31)
</td>
</tr>
<tr>
<td style="text-align:center;">
Positive Test
</td>
<td style="text-align:center;">
Outpatient
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = -1.95
</td>
<td style="text-align:center;">
logsd = 1.22
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.122 (0.120, 0.124)
</td>
<td style="text-align:center;">
0.122 (0.120, 0.124)
</td>
<td style="text-align:center;">
0.14 (0.14, 0.15)
</td>
<td style="text-align:center;">
0.06 (0.06, 0.06)
</td>
<td style="text-align:center;">
0.33 (0.32, 0.33)
</td>
</tr>
<tr>
<td style="text-align:center;">
Positive Test
</td>
<td style="text-align:center;">
Urgent Care
</td>
<td style="text-align:center;">
Generalized gamma
</td>
<td style="text-align:center;">
mu = -2.30
</td>
<td style="text-align:center;">
sigma = -0.00314
</td>
<td style="text-align:center;">
Q = -17.9
</td>
<td style="text-align:center;">
0.370 (0.366, 0.375)
</td>
<td style="text-align:center;">
0.370 (0.366, 0.375)
</td>
<td style="text-align:center;">
0.10 (0.10, 0.11)
</td>
<td style="text-align:center;">
0.10 (0.10, 0.10)
</td>
<td style="text-align:center;">
0.11 (0.11, 0.11)
</td>
</tr>
<tr>
<td style="text-align:center;">
Positive Test
</td>
<td style="text-align:center;">
Emergency
</td>
<td style="text-align:center;">
Generalized gamma
</td>
<td style="text-align:center;">
mu = -2.30
</td>
<td style="text-align:center;">
sigma = 0.00431
</td>
<td style="text-align:center;">
Q = -13.30
</td>
<td style="text-align:center;">
0.322 (0.318, 0.327)
</td>
<td style="text-align:center;">
0.322 (0.318, 0.327)
</td>
<td style="text-align:center;">
0.10 (0.10, 0.11)
</td>
<td style="text-align:center;">
0.10 (0.10, 0.10)
</td>
<td style="text-align:center;">
0.11 (0.11, 0.11)
</td>
</tr>
<tr>
<td style="text-align:center;">
Positive Test
</td>
<td style="text-align:center;">
Inpatient
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = -2.17
</td>
<td style="text-align:center;">
logsd = 0.761
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.032 (0.032, 0.033)
</td>
<td style="text-align:center;">
0.032 (0.032, 0.033)
</td>
<td style="text-align:center;">
0.11 (0.11, 0.12)
</td>
<td style="text-align:center;">
0.07 (0.07, 0.07)
</td>
<td style="text-align:center;">
0.19 (0.19, 0.19)
</td>
</tr>
<tr>
<td style="text-align:center;">
Positive Test
</td>
<td style="text-align:center;">
Ventilation
</td>
<td style="text-align:center;">
Exponential
</td>
<td style="text-align:center;">
rate = 0.141
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.000 (0.000, 0.001)
</td>
<td style="text-align:center;">
0.000 (0.000, 0.001)
</td>
<td style="text-align:center;">
4.93 (2.48, 10.03)
</td>
<td style="text-align:center;">
2.05 (0.99, 3.89)
</td>
<td style="text-align:center;">
9.86 (4.79, 18.76)
</td>
</tr>
<tr>
<td style="text-align:center;">
Positive Test
</td>
<td style="text-align:center;">
Death
</td>
<td style="text-align:center;">
Gamma
</td>
<td style="text-align:center;">
shape = 0.573
</td>
<td style="text-align:center;">
rate = 0.0382
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.001 (0.000, 0.001)
</td>
<td style="text-align:center;">
0.001 (0.000, 0.001)
</td>
<td style="text-align:center;">
7.63 (2.78, 16.64)
</td>
<td style="text-align:center;">
2.00 (0.37, 5.86)
</td>
<td style="text-align:center;">
20.23 (9.97, 37.94)
</td>
</tr>
<tr>
<td style="text-align:center;">
Virtual
</td>
<td style="text-align:center;">
Outpatient
</td>
<td style="text-align:center;">
Gamma
</td>
<td style="text-align:center;">
shape = 0.512
</td>
<td style="text-align:center;">
rate = 0.0450
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.160 (0.158, 0.161)
</td>
<td style="text-align:center;">
0.120 (0.117, 0.122)
</td>
<td style="text-align:center;">
5.28 (5.11, 5.45)
</td>
<td style="text-align:center;">
1.21 (1.09, 1.33)
</td>
<td style="text-align:center;">
15.11 (14.15, 16.15)
</td>
</tr>
<tr>
<td style="text-align:center;">
Virtual
</td>
<td style="text-align:center;">
Urgent Care
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 0.0259
</td>
<td style="text-align:center;">
logsd = 1.95
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.124 (0.123, 0.126)
</td>
<td style="text-align:center;">
0.114 (0.111, 0.116)
</td>
<td style="text-align:center;">
1.03 (0.86, 1.21)
</td>
<td style="text-align:center;">
0.28 (0.23, 0.33)
</td>
<td style="text-align:center;">
3.83 (3.19, 4.55)
</td>
</tr>
<tr>
<td style="text-align:center;">
Virtual
</td>
<td style="text-align:center;">
Emergency
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = -0.0618
</td>
<td style="text-align:center;">
logsd = 1.82
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.125 (0.123, 0.126)
</td>
<td style="text-align:center;">
0.117 (0.115, 0.119)
</td>
<td style="text-align:center;">
0.94 (0.79, 1.12)
</td>
<td style="text-align:center;">
0.27 (0.23, 0.32)
</td>
<td style="text-align:center;">
3.21 (2.70, 3.82)
</td>
</tr>
<tr>
<td style="text-align:center;">
Virtual
</td>
<td style="text-align:center;">
Inpatient
</td>
<td style="text-align:center;">
Weibull
</td>
<td style="text-align:center;">
shape = 0.590
</td>
<td style="text-align:center;">
scale = 6.07
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.017 (0.013, 0.021)
</td>
<td style="text-align:center;">
0.014 (0.010, 0.017)
</td>
<td style="text-align:center;">
3.26 (1.94, 5.29)
</td>
<td style="text-align:center;">
0.74 (0.36, 1.45)
</td>
<td style="text-align:center;">
10.56 (7.00, 16.33)
</td>
</tr>
<tr>
<td style="text-align:center;">
Virtual
</td>
<td style="text-align:center;">
Ventilation
</td>
<td style="text-align:center;">
Gompertz
</td>
<td style="text-align:center;">
shape = 0.149
</td>
<td style="text-align:center;">
rate = 0.0000792
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.000 (0.000, 0.002)
</td>
<td style="text-align:center;">
0.000 (0.000, 0.001)
</td>
<td style="text-align:center;">
48.23 (0.02, 51.96)
</td>
<td style="text-align:center;">
42.33 (0.01, 48.27)
</td>
<td style="text-align:center;">
52.89 (0.04, 56.78)
</td>
</tr>
<tr>
<td style="text-align:center;">
Virtual
</td>
<td style="text-align:center;">
Death
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 3.38
</td>
<td style="text-align:center;">
logsd = 0.342
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.001 (0.000, 0.003)
</td>
<td style="text-align:center;">
0.000 (0.000, 0.000)
</td>
<td style="text-align:center;">
29.20 (21.30, 41.20)
</td>
<td style="text-align:center;">
23.22 (15.48, 33.35)
</td>
<td style="text-align:center;">
36.85 (26.10, 55.55)
</td>
</tr>
<tr>
<td style="text-align:center;">
Outpatient
</td>
<td style="text-align:center;">
Urgent Care
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = -0.572
</td>
<td style="text-align:center;">
logsd = 2.27
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.154 (0.152, 0.155)
</td>
<td style="text-align:center;">
0.142 (0.140, 0.144)
</td>
<td style="text-align:center;">
0.56 (0.48, 0.67)
</td>
<td style="text-align:center;">
0.12 (0.10, 0.14)
</td>
<td style="text-align:center;">
2.62 (2.21, 3.10)
</td>
</tr>
<tr>
<td style="text-align:center;">
Outpatient
</td>
<td style="text-align:center;">
Emergency
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 0.288
</td>
<td style="text-align:center;">
logsd = 2.02
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.088 (0.087, 0.089)
</td>
<td style="text-align:center;">
0.078 (0.076, 0.08)
</td>
<td style="text-align:center;">
1.33 (1.09, 1.63)
</td>
<td style="text-align:center;">
0.34 (0.28, 0.41)
</td>
<td style="text-align:center;">
5.19 (4.24, 6.29)
</td>
</tr>
<tr>
<td style="text-align:center;">
Outpatient
</td>
<td style="text-align:center;">
Inpatient
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 0.181
</td>
<td style="text-align:center;">
logsd = 2.30
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.027 (0.023, 0.032)
</td>
<td style="text-align:center;">
0.023 (0.019, 0.028)
</td>
<td style="text-align:center;">
1.20 (0.80, 1.85)
</td>
<td style="text-align:center;">
0.25 (0.17, 0.39)
</td>
<td style="text-align:center;">
5.65 (3.78, 8.59)
</td>
</tr>
<tr>
<td style="text-align:center;">
Outpatient
</td>
<td style="text-align:center;">
Ventilation
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = -0.574
</td>
<td style="text-align:center;">
logsd = 1.82
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.002 (0.001, 0.004)
</td>
<td style="text-align:center;">
0.002 (0.001, 0.004)
</td>
<td style="text-align:center;">
0.56 (0.16, 1.77)
</td>
<td style="text-align:center;">
0.17 (0.04, 0.61)
</td>
<td style="text-align:center;">
1.92 (0.51, 7.84)
</td>
</tr>
<tr>
<td style="text-align:center;">
Outpatient
</td>
<td style="text-align:center;">
Death
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 2.02
</td>
<td style="text-align:center;">
logsd = 1.31
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.004 (0.003, 0.007)
</td>
<td style="text-align:center;">
0.003 (0.002, 0.005)
</td>
<td style="text-align:center;">
7.55 (4.16, 12.9)
</td>
<td style="text-align:center;">
3.12 (1.58, 5.88)
</td>
<td style="text-align:center;">
18.23 (9.65, 35.48)
</td>
</tr>
<tr>
<td style="text-align:center;">
Urgent Care
</td>
<td style="text-align:center;">
Emergency
</td>
<td style="text-align:center;">
Generalized gamma
</td>
<td style="text-align:center;">
mu = -2.29
</td>
<td style="text-align:center;">
sigma = 0.132
</td>
<td style="text-align:center;">
Q = -15.80
</td>
<td style="text-align:center;">
0.082 (0.081, 0.083)
</td>
<td style="text-align:center;">
0.075 (0.073, 0.083)
</td>
<td style="text-align:center;">
0.41 (0.38, 0.42)
</td>
<td style="text-align:center;">
0.18 (0.17, 0.18)
</td>
<td style="text-align:center;">
1.75 (1.54, 1.84)
</td>
</tr>
<tr>
<td style="text-align:center;">
Urgent Care
</td>
<td style="text-align:center;">
Inpatient
</td>
<td style="text-align:center;">
Generalized gamma
</td>
<td style="text-align:center;">
mu = -2.29
</td>
<td style="text-align:center;">
sigma = 0.146
</td>
<td style="text-align:center;">
Q = -12.70
</td>
<td style="text-align:center;">
0.014 (0.014, 0.015)
</td>
<td style="text-align:center;">
0.013 (0.013, 0.014)
</td>
<td style="text-align:center;">
0.34 (0.27, 0.35)
</td>
<td style="text-align:center;">
0.16 (0.14, 0.17)
</td>
<td style="text-align:center;">
1.24 (0.79, 1.28)
</td>
</tr>
<tr>
<td style="text-align:center;">
Urgent Care
</td>
<td style="text-align:center;">
Ventilation
</td>
<td style="text-align:center;">
NA/No events
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
</tr>
<tr>
<td style="text-align:center;">
Urgent Care
</td>
<td style="text-align:center;">
Death
</td>
<td style="text-align:center;">
Exponential
</td>
<td style="text-align:center;">
rate = 0.250
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.000 (0.000, 0.001)
</td>
<td style="text-align:center;">
0.000 (0.000, 0.001)
</td>
<td style="text-align:center;">
2.77 (0.44, 20.59)
</td>
<td style="text-align:center;">
1.15 (0.16, 9.51)
</td>
<td style="text-align:center;">
5.54 (0.79, 45.81)
</td>
</tr>
<tr>
<td style="text-align:center;">
Emergency
</td>
<td style="text-align:center;">
Inpatient
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 0.362
</td>
<td style="text-align:center;">
logsd = 2.16
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.041 (0.041, 0.042)
</td>
<td style="text-align:center;">
0.036 (0.034, 0.037)
</td>
<td style="text-align:center;">
1.44 (1.13, 1.84)
</td>
<td style="text-align:center;">
0.33 (0.27, 0.42)
</td>
<td style="text-align:center;">
6.17 (4.76, 7.95)
</td>
</tr>
<tr>
<td style="text-align:center;">
Emergency
</td>
<td style="text-align:center;">
Ventilation
</td>
<td style="text-align:center;">
Weibull
</td>
<td style="text-align:center;">
shape = 0.491
</td>
<td style="text-align:center;">
scale = 3.40
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.001 (0.001, 0.002)
</td>
<td style="text-align:center;">
0.001 (0.001, 0.002)
</td>
<td style="text-align:center;">
1.61 (0.29, 6.25)
</td>
<td style="text-align:center;">
0.27 (0.02, 1.89)
</td>
<td style="text-align:center;">
6.62 (1.70, 26.96)
</td>
</tr>
<tr>
<td style="text-align:center;">
Emergency
</td>
<td style="text-align:center;">
Death
</td>
<td style="text-align:center;">
Gompertz
</td>
<td style="text-align:center;">
shape = 0.0496
</td>
<td style="text-align:center;">
rate = 0.0130
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.003 (0.002, 0.004)
</td>
<td style="text-align:center;">
0.001 (0.000, 0.001)
</td>
<td style="text-align:center;">
26.05 (15.88, 32.51)
</td>
<td style="text-align:center;">
14.91 (7.74, 22.21)
</td>
<td style="text-align:center;">
37.05 (28.01, 43.62)
</td>
</tr>
<tr>
<td style="text-align:center;">
Inpatient
</td>
<td style="text-align:center;">
Ventilation
</td>
<td style="text-align:center;">
Generalized gamma
</td>
<td style="text-align:center;">
mu = 0.095
</td>
<td style="text-align:center;">
sigma = 1.94
</td>
<td style="text-align:center;">
Q = 0.00
</td>
<td style="text-align:center;">
0.068 (0.055, 0.085)
</td>
<td style="text-align:center;">
0.062 (0.049, 0.078)
</td>
<td style="text-align:center;">
1.10 (0.07, 1.13)
</td>
<td style="text-align:center;">
0.30 (0.29, 0.31)
</td>
<td style="text-align:center;">
7.82 (5.39, 10.88)
</td>
</tr>
<tr>
<td style="text-align:center;">
Inpatient
</td>
<td style="text-align:center;">
Death
</td>
<td style="text-align:center;">
Gompertz
</td>
<td style="text-align:center;">
shape = 0.0148
</td>
<td style="text-align:center;">
rate = 0.0347
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.055 (0.044, 0.070)
</td>
<td style="text-align:center;">
0.024 (0.016, 0.034)
</td>
<td style="text-align:center;">
17.50 (2.44, 23.52)
</td>
<td style="text-align:center;">
4.06 (3.91, 4.22)
</td>
<td style="text-align:center;">
31.38 (23.53, 44.89)
</td>
</tr>
<tr>
<td style="text-align:center;">
Ventilation
</td>
<td style="text-align:center;">
Death
</td>
<td style="text-align:center;">
Gamma
</td>
<td style="text-align:center;">
shape = 0.538
</td>
<td style="text-align:center;">
rate = 0.0471
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.345 (0.254, 0.457)
</td>
<td style="text-align:center;">
0.257 (0.184, 0.348)
</td>
<td style="text-align:center;">
5.52 (2.87, 9.58)
</td>
<td style="text-align:center;">
1.35 (0.40, 3.19)
</td>
<td style="text-align:center;">
15.28 (9.02, 24.68)
</td>
</tr>
</tbody>
</table>

## Outcome or worse

The distribution of progressing to each outcome or more severe state
from each starting state:

*For example, there is a 48.3% chance that the of experiencing an urgent
care visit or worse event following symptom onset of a COVID-19
infection. The median time to this outcome is 4.04 days following
symptom onset.*

<table>
<caption>
Event or more severe following every state for COVID-19 infections
</caption>
<thead>
<tr>
<th style="text-align:center;">
Starting State
</th>
<th style="text-align:center;">
Outcome or worse
</th>
<th style="text-align:center;">
Distribution
</th>
<th style="text-align:center;">
Parameter 1
</th>
<th style="text-align:center;">
Parameter 2
</th>
<th style="text-align:center;">
Parameter 3
</th>
<th style="text-align:center;">
Total Probability
</th>
<th style="text-align:center;">
Probability at t = 15
</th>
<th style="text-align:center;">
Median Time To Event
</th>
<th style="text-align:center;">
25th% Time
</th>
<th style="text-align:center;">
75th% Time
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
Symptom Onset
</td>
<td style="text-align:center;">
Virtual
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 1.36
</td>
<td style="text-align:center;">
logsd = 0.886
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.700 (0.696, 0.704)
</td>
<td style="text-align:center;">
0.654 (0.651, 0.658)
</td>
<td style="text-align:center;">
3.90 (3.86, 3.94)
</td>
<td style="text-align:center;">
2.14 (2.13, 2.16)
</td>
<td style="text-align:center;">
7.11 (7.04, 7.18)
</td>
</tr>
<tr>
<td style="text-align:center;">
Symptom Onset
</td>
<td style="text-align:center;">
Outpatient
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 1.43
</td>
<td style="text-align:center;">
logsd = 0.934
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.563 (0.559, 0.567)
</td>
<td style="text-align:center;">
0.515 (0.510, 0.520)
</td>
<td style="text-align:center;">
4.17 (4.09, 4.24)
</td>
<td style="text-align:center;">
2.22 (2.18, 2.24)
</td>
<td style="text-align:center;">
7.82 (7.65, 7.99)
</td>
</tr>
<tr>
<td style="text-align:center;">
Symptom Onset
</td>
<td style="text-align:center;">
Urgent Care
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 1.40
</td>
<td style="text-align:center;">
logsd = 0.911
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.483 (0.479, 0.487)
</td>
<td style="text-align:center;">
0.447 (0.443, 0.451)
</td>
<td style="text-align:center;">
4.04 (3.99, 4.08)
</td>
<td style="text-align:center;">
2.18 (2.16, 2.20)
</td>
<td style="text-align:center;">
7.47 (7.38, 7.56)
</td>
</tr>
<tr>
<td style="text-align:center;">
Symptom Onset
</td>
<td style="text-align:center;">
Emergency
</td>
<td style="text-align:center;">
Generalized gamma
</td>
<td style="text-align:center;">
mu = 1.47
</td>
<td style="text-align:center;">
sigma = 0.928
</td>
<td style="text-align:center;">
Q = -0.139
</td>
<td style="text-align:center;">
0.279 (0.275, 0.283)
</td>
<td style="text-align:center;">
0.240 (0.246, 0.253)
</td>
<td style="text-align:center;">
4.49 (4.42, 4.57)
</td>
<td style="text-align:center;">
2.42 (2.37, 2.43)
</td>
<td style="text-align:center;">
8.51 (8.37, 8.65)
</td>
</tr>
<tr>
<td style="text-align:center;">
Symptom Onset
</td>
<td style="text-align:center;">
Inpatient
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 1.93
</td>
<td style="text-align:center;">
logsd = 0.971
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.079 (0.077, 0.081)
</td>
<td style="text-align:center;">
0.063 (0.061, 0.065)
</td>
<td style="text-align:center;">
6.83 (6.64, 7.04)
</td>
<td style="text-align:center;">
3.55 (3.45, 3.67)
</td>
<td style="text-align:center;">
13.17 (12.7, 3.57)
</td>
</tr>
<tr>
<td style="text-align:center;">
Symptom Onset
</td>
<td style="text-align:center;">
Ventilation
</td>
<td style="text-align:center;">
Gompertz
</td>
<td style="text-align:center;">
shape = 0.0387
</td>
<td style="text-align:center;">
rate = 0.0190
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.017 (0.016, 0.018)
</td>
<td style="text-align:center;">
0.005 (0.005, 0.006)
</td>
<td style="text-align:center;">
22.82 (21.67, 23.99)
</td>
<td style="text-align:center;">
11.95 (11.30, 12.73)
</td>
<td style="text-align:center;">
34.78 (33.4, 36.02)
</td>
</tr>
<tr>
<td style="text-align:center;">
Symptom Onset
</td>
<td style="text-align:center;">
Death
</td>
<td style="text-align:center;">
Generalized gamma
</td>
<td style="text-align:center;">
shape = 0.0487
</td>
<td style="text-align:center;">
rate = 0.0128
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.015 (0.010, 0.015)
</td>
<td style="text-align:center;">
0.004 (0.003, 0.004)
</td>
<td style="text-align:center;">
26.48 (22.1, 32.96)
</td>
<td style="text-align:center;">
15.16 (14.00, 15.81)
</td>
<td style="text-align:center;">
37.67 (30.50, 40.98)
</td>
</tr>
<tr>
<td style="text-align:center;">
Positive Test
</td>
<td style="text-align:center;">
Virtual
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = -1.58
</td>
<td style="text-align:center;">
logsd = 1.56
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.653 (0.650, 0.656)
</td>
<td style="text-align:center;">
0.651 (0.648, 0.654)
</td>
<td style="text-align:center;">
0.21 (0.20, 0.21)
</td>
<td style="text-align:center;">
0.07 (0.07, 0.07)
</td>
<td style="text-align:center;">
0.59 (0.58, 0.69)
</td>
</tr>
<tr>
<td style="text-align:center;">
Positive Test
</td>
<td style="text-align:center;">
Outpatient
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = -1.75
</td>
<td style="text-align:center;">
logsd = 1.53
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.540 (0.534, 0.547)
</td>
<td style="text-align:center;">
0.540 (0.533, 0.545)
</td>
<td style="text-align:center;">
0.17 (0.17, 0.18)
</td>
<td style="text-align:center;">
0.06 (0.06, 0.06)
</td>
<td style="text-align:center;">
0.49 (0.47, 0.50)
</td>
</tr>
<tr>
<td style="text-align:center;">
Positive Test
</td>
<td style="text-align:center;">
Urgent Care
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = -1.89
</td>
<td style="text-align:center;">
logsd = 1.33
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.469 (0.463, 0.474)
</td>
<td style="text-align:center;">
0.469 (0.463, 0.474)
</td>
<td style="text-align:center;">
0.15 (0.15, 0.16)
</td>
<td style="text-align:center;">
0.06 (0.06, 0.06)
</td>
<td style="text-align:center;">
0.37 (0.36, 0.38)
</td>
</tr>
<tr>
<td style="text-align:center;">
Positive Test
</td>
<td style="text-align:center;">
Emergency
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = -1.84
</td>
<td style="text-align:center;">
logsd = 1.37
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.280 (0.277, 0.284)
</td>
<td style="text-align:center;">
0.280 (0.277, 0.284)
</td>
<td style="text-align:center;">
0.16 (0.16, 0.16)
</td>
<td style="text-align:center;">
0.06 (0.06, 0.06)
</td>
<td style="text-align:center;">
0.40 (0.39, 0.41)
</td>
</tr>
<tr>
<td style="text-align:center;">
Positive Test
</td>
<td style="text-align:center;">
Inpatient
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = -1.02
</td>
<td style="text-align:center;">
logsd = 2.14
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.073 (0.071, 0.074)
</td>
<td style="text-align:center;">
0.070 (0.068, 0.071)
</td>
<td style="text-align:center;">
0.36 (0.35, 0.37)
</td>
<td style="text-align:center;">
0.09 (0.08, 0.09)
</td>
<td style="text-align:center;">
1.52 (1.47, 1.58)
</td>
</tr>
<tr>
<td style="text-align:center;">
Positive Test
</td>
<td style="text-align:center;">
Ventilation
</td>
<td style="text-align:center;">
Gamma
</td>
<td style="text-align:center;">
shape = 0.900
</td>
<td style="text-align:center;">
rate = 0.0462
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.016 (0.010, 0.017)
</td>
<td style="text-align:center;">
0.009 (0.000, 0.009)
</td>
<td style="text-align:center;">
12.92 (12.50, 13.33)
</td>
<td style="text-align:center;">
5.01 (4.85, 5.25)
</td>
<td style="text-align:center;">
27.02 (26.30, 27.74)
</td>
</tr>
<tr>
<td style="text-align:center;">
Positive Test
</td>
<td style="text-align:center;">
Death
</td>
<td style="text-align:center;">
Gompertz
</td>
<td style="text-align:center;">
shape = 0.0270
</td>
<td style="text-align:center;">
rate = 0.0270
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.014 (0.010, 0.014)
</td>
<td style="text-align:center;">
0.005 (0.000, 0.006)
</td>
<td style="text-align:center;">
19.48 (16.80, 23.40)
</td>
<td style="text-align:center;">
9.36 (8.88, 9.64)
</td>
<td style="text-align:center;">
32.17 (26.2, 41.62)
</td>
</tr>
<tr>
<td style="text-align:center;">
Virtual
</td>
<td style="text-align:center;">
Outpatient
</td>
<td style="text-align:center;">
Gamma
</td>
<td style="text-align:center;">
shape = 0.431
</td>
<td style="text-align:center;">
rate = 0.0398
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.271 (0.260, 0.275)
</td>
<td style="text-align:center;">
0.207 (0.200, 0.211)
</td>
<td style="text-align:center;">
4.28 (4.05, 4.50)
</td>
<td style="text-align:center;">
0.78 (0.70, 0.83)
</td>
<td style="text-align:center;">
13.94 (13.40, 14.45)
</td>
</tr>
<tr>
<td style="text-align:center;">
Virtual
</td>
<td style="text-align:center;">
Urgent Care
</td>
<td style="text-align:center;">
Generalized gamma
</td>
<td style="text-align:center;">
mu = 0.892
</td>
<td style="text-align:center;">
sigma = 2.09
</td>
<td style="text-align:center;">
Q = 0.314
</td>
<td style="text-align:center;">
0.182 (0.170, 0.185)
</td>
<td style="text-align:center;">
0.153 (0.150, 0.157)
</td>
<td style="text-align:center;">
1.96 (1.89, 2.02)
</td>
<td style="text-align:center;">
0.45 (0.43, 0.46)
</td>
<td style="text-align:center;">
7.78 (7.44, 8.14)
</td>
</tr>
<tr>
<td style="text-align:center;">
Virtual
</td>
<td style="text-align:center;">
Emergency
</td>
<td style="text-align:center;">
Generalized gamma
</td>
<td style="text-align:center;">
mu = 0.856
</td>
<td style="text-align:center;">
sigma = 2.04
</td>
<td style="text-align:center;">
Q = 0.301
</td>
<td style="text-align:center;">
0.122 (0.120, 0.123)
</td>
<td style="text-align:center;">
0.104 (0.102, 0.105)
</td>
<td style="text-align:center;">
1.91 (1.75, 2.09)
</td>
<td style="text-align:center;">
0.45 (0.44, 0.47)
</td>
<td style="text-align:center;">
7.38 (6.93, 7.91)
</td>
</tr>
<tr>
<td style="text-align:center;">
Virtual
</td>
<td style="text-align:center;">
Inpatient
</td>
<td style="text-align:center;">
Gamma
</td>
<td style="text-align:center;">
shape = 0.543
</td>
<td style="text-align:center;">
rate = 0.0423
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.043 (0.040, 0.044)
</td>
<td style="text-align:center;">
0.031 (0.030, 0.031)
</td>
<td style="text-align:center;">
6.26 (5.97, 6.56)
</td>
<td style="text-align:center;">
1.54 (1.51, 1.59)
</td>
<td style="text-align:center;">
17.19 (16.60, 17.78)
</td>
</tr>
<tr>
<td style="text-align:center;">
Virtual
</td>
<td style="text-align:center;">
Ventilation
</td>
<td style="text-align:center;">
Gompertz
</td>
<td style="text-align:center;">
shape = 0.0306
</td>
<td style="text-align:center;">
rate = 0.0227
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.011 (0.010, 0.011)
</td>
<td style="text-align:center;">
0.004 (0.000, 0.005)
</td>
<td style="text-align:center;">
21.58 (17.5, 26.38)
</td>
<td style="text-align:center;">
10.72 (8.80, 12.39)
</td>
<td style="text-align:center;">
34.46 (27.80, 46.30)
</td>
</tr>
<tr>
<td style="text-align:center;">
Virtual
</td>
<td style="text-align:center;">
Death
</td>
<td style="text-align:center;">
Gompertz
</td>
<td style="text-align:center;">
shape = 0.0384
</td>
<td style="text-align:center;">
rate = 0.0179
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.009 (0.000, 0.009)
</td>
<td style="text-align:center;">
0.003 (0.000, 0.003)
</td>
<td style="text-align:center;">
23.67 (19.00, 30.08)
</td>
<td style="text-align:center;">
12.48 (12.10, 14.19)
</td>
<td style="text-align:center;">
35.86 (29.20, 48.04)
</td>
</tr>
<tr>
<td style="text-align:center;">
Outpatient
</td>
<td style="text-align:center;">
Urgent Care
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 0.0985
</td>
<td style="text-align:center;">
logsd = 2.36
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.260 (0.200, 0.264)
</td>
<td style="text-align:center;">
0.226 (0.220, 0.229)
</td>
<td style="text-align:center;">
1.10 (1.09, 1.12)
</td>
<td style="text-align:center;">
0.23 (0.21, 0.23)
</td>
<td style="text-align:center;">
5.42 (5.28, 5.55)
</td>
</tr>
<tr>
<td style="text-align:center;">
Outpatient
</td>
<td style="text-align:center;">
Emergency
</td>
<td style="text-align:center;">
Generalized gamma
</td>
<td style="text-align:center;">
mu = 1.37
</td>
<td style="text-align:center;">
sigma = 2.03
</td>
<td style="text-align:center;">
Q = 0.693
</td>
<td style="text-align:center;">
0.166 (0.160, 0.168)
</td>
<td style="text-align:center;">
0.137 (0.130, 0.139)
</td>
<td style="text-align:center;">
2.41 (2.11, 2.76)
</td>
<td style="text-align:center;">
0.49 (0.45, 0.52)
</td>
<td style="text-align:center;">
9.35 (8.74, 10.31)
</td>
</tr>
<tr>
<td style="text-align:center;">
Outpatient
</td>
<td style="text-align:center;">
Inpatient
</td>
<td style="text-align:center;">
Gamma
</td>
<td style="text-align:center;">
shape = 0.4580
</td>
<td style="text-align:center;">
rate = 0.0393
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.088 (0.080, 0.090)
</td>
<td style="text-align:center;">
0.066 (0.060, 0.067)
</td>
<td style="text-align:center;">
4.88 (4.67, 5.10)
</td>
<td style="text-align:center;">
0.97 (0.90, 0.97)
</td>
<td style="text-align:center;">
15.15 (14.6, 15.66)
</td>
</tr>
<tr>
<td style="text-align:center;">
Outpatient
</td>
<td style="text-align:center;">
Ventilation
</td>
<td style="text-align:center;">
Gamma
</td>
<td style="text-align:center;">
shape = 0.824
</td>
<td style="text-align:center;">
rate = 0.0448
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.035 (0.030, 0.035)
</td>
<td style="text-align:center;">
0.020 (0.020, 0.021)
</td>
<td style="text-align:center;">
11.69 (11.3, 11.97)
</td>
<td style="text-align:center;">
4.26 (4.13, 4.72)
</td>
<td style="text-align:center;">
25.43 (23.8, 27.00)
</td>
</tr>
<tr>
<td style="text-align:center;">
Outpatient
</td>
<td style="text-align:center;">
Death
</td>
<td style="text-align:center;">
Gompertz
</td>
<td style="text-align:center;">
shape = 0.0237
</td>
<td style="text-align:center;">
rate = 0.0299
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.029 (0.020, 0.030)
</td>
<td style="text-align:center;">
0.012 (0.010, 0.014)
</td>
<td style="text-align:center;">
18.50 (15.4, 22.05)
</td>
<td style="text-align:center;">
8.68 (7.61, 10.15)
</td>
<td style="text-align:center;">
31.32 (26.00, 38.78)
</td>
</tr>
<tr>
<td style="text-align:center;">
Urgent Care
</td>
<td style="text-align:center;">
Emergency
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 0.0297
</td>
<td style="text-align:center;">
logsd = 2.10
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.094 (0.092, 0.095)
</td>
<td style="text-align:center;">
0.084 (0.083, 0.086)
</td>
<td style="text-align:center;">
1.03 (1.01, 1.05)
</td>
<td style="text-align:center;">
0.25 (0.25, 0.25)
</td>
<td style="text-align:center;">
4.24 (4.12, 4.38)
</td>
</tr>
<tr>
<td style="text-align:center;">
Urgent Care
</td>
<td style="text-align:center;">
Inpatient
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 0.124
</td>
<td style="text-align:center;">
logsd = 2.28
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.027 (0.020, 0.027)
</td>
<td style="text-align:center;">
0.024 (0.020, 0.024)
</td>
<td style="text-align:center;">
1.13 (0.90, 1.44)
</td>
<td style="text-align:center;">
0.24 (0.20, 0.30)
</td>
<td style="text-align:center;">
5.28 (4.21, 6.74)
</td>
</tr>
<tr>
<td style="text-align:center;">
Urgent Care
</td>
<td style="text-align:center;">
Ventilation
</td>
<td style="text-align:center;">
Gompertz
</td>
<td style="text-align:center;">
shape = 0.0284
</td>
<td style="text-align:center;">
rate = 0.0256
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.005 (0.000, 0.007)
</td>
<td style="text-align:center;">
0.002 (0.000, 0.003)
</td>
<td style="text-align:center;">
20.08 (14.80, 25.82)
</td>
<td style="text-align:center;">
9.75 (7.14, 13.52)
</td>
<td style="text-align:center;">
32.79 (26.10, 39.37)
</td>
</tr>
<tr>
<td style="text-align:center;">
Urgent Care
</td>
<td style="text-align:center;">
Death
</td>
<td style="text-align:center;">
Gompertz
</td>
<td style="text-align:center;">
shape = 0.0447
</td>
<td style="text-align:center;">
rate = 0.0157
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.004 (0.000, 0.005)
</td>
<td style="text-align:center;">
0.001 (0.000, 0.002)
</td>
<td style="text-align:center;">
24.35 (17.50, 30.59)
</td>
<td style="text-align:center;">
13.36 (10.80, 17.87)
</td>
<td style="text-align:center;">
35.73 (28.50, 43.37)
</td>
</tr>
<tr>
<td style="text-align:center;">
Emergency
</td>
<td style="text-align:center;">
Inpatient
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 0.3273
</td>
<td style="text-align:center;">
logsd = 2.2076
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.095 (0.090, 0.097)
</td>
<td style="text-align:center;">
0.082 (0.080, 0.083)
</td>
<td style="text-align:center;">
1.39 (1.36, 1.41)
</td>
<td style="text-align:center;">
0.31 (0.30, 0.32)
</td>
<td style="text-align:center;">
6.16 (5.96, 6.35)
</td>
</tr>
<tr>
<td style="text-align:center;">
Emergency
</td>
<td style="text-align:center;">
Ventilation
</td>
<td style="text-align:center;">
Gompertz
</td>
<td style="text-align:center;">
shape = 0.0207
</td>
<td style="text-align:center;">
rate = 0.0329
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.028 (0.020, 0.029)
</td>
<td style="text-align:center;">
0.012 (0.010, 0.014)
</td>
<td style="text-align:center;">
17.48 (15.20, 20.35)
</td>
<td style="text-align:center;">
8.04 (7.63, 9.20)
</td>
<td style="text-align:center;">
30.28 (26.10, 36.73)
</td>
</tr>
<tr>
<td style="text-align:center;">
Emergency
</td>
<td style="text-align:center;">
Death
</td>
<td style="text-align:center;">
Gompertz
</td>
<td style="text-align:center;">
shape = 0.0269
</td>
<td style="text-align:center;">
rate = 0.0272
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.025 (0.020, 0.025)
</td>
<td style="text-align:center;">
0.010 (0.000, 0.011)
</td>
<td style="text-align:center;">
19.40 (16.50, 22.48)
</td>
<td style="text-align:center;">
9.31 (8.15, 10.82)
</td>
<td style="text-align:center;">
32.09 (27.20, 38.70)
</td>
</tr>
<tr>
<td style="text-align:center;">
Inpatient
</td>
<td style="text-align:center;">
Ventilation
</td>
<td style="text-align:center;">
Generalized gamma
</td>
<td style="text-align:center;">
mu = 3.21
</td>
<td style="text-align:center;">
sigma = 0.794
</td>
<td style="text-align:center;">
Q = 2.01
</td>
<td style="text-align:center;">
0.172 (0.170, 0.174)
</td>
<td style="text-align:center;">
0.096 (0.090, 0.099)
</td>
<td style="text-align:center;">
12.40 (11.80, 13.11)
</td>
<td style="text-align:center;">
4.06 (4.00, 4.18)
</td>
<td style="text-align:center;">
25.24 (24.20, 26.81)
</td>
</tr>
<tr>
<td style="text-align:center;">
Inpatient
</td>
<td style="text-align:center;">
Death
</td>
<td style="text-align:center;">
Gamma
</td>
<td style="text-align:center;">
shape = 1.49
</td>
<td style="text-align:center;">
rate = 0.0748
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.141 (0.130, 0.142)
</td>
<td style="text-align:center;">
0.067 (0.060, 0.069)
</td>
<td style="text-align:center;">
15.70 (15.30, 16.11)
</td>
<td style="text-align:center;">
8.03 (7.85, 8.18)
</td>
<td style="text-align:center;">
27.31 (26.70, 27.88)
</td>
</tr>
<tr>
<td style="text-align:center;">
Ventilation
</td>
<td style="text-align:center;">
Death
</td>
<td style="text-align:center;">
Gamma
</td>
<td style="text-align:center;">
shape = 0.528
</td>
<td style="text-align:center;">
rate = 0.0481
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
0.502 (0.443, 0.556)
</td>
<td style="text-align:center;">
0.379 (0.332, 0.432)
</td>
<td style="text-align:center;">
5.24 (4.95, 5.48)
</td>
<td style="text-align:center;">
1.25 (1.00, 1.47)
</td>
<td style="text-align:center;">
14.66 (12.86, 21.64)
</td>
</tr>
</tbody>
</table>

## Probabilities stratified by covariates

All of the *Event or more severe state* outcomes were stratified by
available demographic variables. Presented here are the probabilities of
each outcome stratified by various covariates.

<table>
<caption>
Event or more severe following symptom onset for COVID-19 infections by
demographic covariates
</caption>
<thead>
<tr>
<th style="text-align:center;">
Characteristic
</th>
<th style="text-align:center;">
Group
</th>
<th style="text-align:center;">
Virtual +
</th>
<th style="text-align:center;">
Outpatient +
</th>
<th style="text-align:center;">
Urgent Care +
</th>
<th style="text-align:center;">
Emergency +
</th>
<th style="text-align:center;">
Inpatient +
</th>
<th style="text-align:center;">
Ventilation +
</th>
<th style="text-align:center;">
Death
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
Age (%)
</td>
<td style="text-align:center;">
0-17
</td>
<td style="text-align:center;">
0.69 (0.675, 0.705)
</td>
<td style="text-align:center;">
0.589 (0.575, 0.603)
</td>
<td style="text-align:center;">
0.477 (0.461, 0.492)
</td>
<td style="text-align:center;">
0.257 (0.244, 0.271)
</td>
<td style="text-align:center;">
0.017 (0.014, 0.022)
</td>
<td style="text-align:center;">
0 (0, 0.002)
</td>
<td style="text-align:center;">
NA
</td>
</tr>
<tr>
<td style="text-align:center;">
Age (%)
</td>
<td style="text-align:center;">
18-49
</td>
<td style="text-align:center;">
0.588 (0.581, 0.594)
</td>
<td style="text-align:center;">
0.412 (0.406, 0.418)
</td>
<td style="text-align:center;">
0.358 (0.351, 0.364)
</td>
<td style="text-align:center;">
0.158 (0.153, 0.162)
</td>
<td style="text-align:center;">
0.018 (0.017, 0.02)
</td>
<td style="text-align:center;">
0.002 (0.001, 0.003)
</td>
<td style="text-align:center;">
0.001 (0, 0.001)
</td>
</tr>
<tr>
<td style="text-align:center;">
Age (%)
</td>
<td style="text-align:center;">
50-59
</td>
<td style="text-align:center;">
0.684 (0.673, 0.693)
</td>
<td style="text-align:center;">
0.499 (0.493, 0.505)
</td>
<td style="text-align:center;">
0.435 (0.425, 0.446)
</td>
<td style="text-align:center;">
0.204 (0.195, 0.213)
</td>
<td style="text-align:center;">
0.036 (0.032, 0.04)
</td>
<td style="text-align:center;">
0.004 (0.003, 0.006)
</td>
<td style="text-align:center;">
0.003 (0.002, 0.005)
</td>
</tr>
<tr>
<td style="text-align:center;">
Age (%)
</td>
<td style="text-align:center;">
60-69
</td>
<td style="text-align:center;">
0.76 (0.751, 0.769)
</td>
<td style="text-align:center;">
0.618 (0.612, 0.624)
</td>
<td style="text-align:center;">
0.529 (0.519, 0.54)
</td>
<td style="text-align:center;">
0.283 (0.274, 0.294)
</td>
<td style="text-align:center;">
0.079 (0.073, 0.086)
</td>
<td style="text-align:center;">
0.014 (0.014, 0.015)
</td>
<td style="text-align:center;">
0.009 (0.009, 0.01)
</td>
</tr>
<tr>
<td style="text-align:center;">
Age (%)
</td>
<td style="text-align:center;">
70-79
</td>
<td style="text-align:center;">
0.838 (0.83, 0.846)
</td>
<td style="text-align:center;">
0.734 (0.729, 0.738)
</td>
<td style="text-align:center;">
0.649 (0.638, 0.66)
</td>
<td style="text-align:center;">
0.446 (0.435, 0.458)
</td>
<td style="text-align:center;">
0.163 (0.154, 0.171)
</td>
<td style="text-align:center;">
0.033 (0.032, 0.034)
</td>
<td style="text-align:center;">
0.025 (0.024, 0.026)
</td>
</tr>
<tr>
<td style="text-align:center;">
Age (%)
</td>
<td style="text-align:center;">
80-89
</td>
<td style="text-align:center;">
0.884 (0.874, 0.892)
</td>
<td style="text-align:center;">
0.816 (0.812, 0.82)
</td>
<td style="text-align:center;">
0.749 (0.737, 0.763)
</td>
<td style="text-align:center;">
0.626 (0.61, 0.639)
</td>
<td style="text-align:center;">
0.289 (0.275, 0.302)
</td>
<td style="text-align:center;">
0.07 (0.068, 0.072)
</td>
<td style="text-align:center;">
0.064 (0.062, 0.066)
</td>
</tr>
<tr>
<td style="text-align:center;">
Age (%)
</td>
<td style="text-align:center;">
90+
</td>
<td style="text-align:center;">
0.909 (0.889, 0.924)
</td>
<td style="text-align:center;">
0.85 (0.836, 0.864)
</td>
<td style="text-align:center;">
0.796 (0.77, 0.818)
</td>
<td style="text-align:center;">
0.736 (0.71, 0.76)
</td>
<td style="text-align:center;">
0.421 (0.395, 0.45)
</td>
<td style="text-align:center;">
0.137 (0.132, 0.142)
</td>
<td style="text-align:center;">
0.133 (0.129, 0.137)
</td>
</tr>
<tr>
<td style="text-align:center;">
GENDER (%)
</td>
<td style="text-align:center;">
Female
</td>
<td style="text-align:center;">
0.701 (0.697, 0.704)
</td>
<td style="text-align:center;">
0.552 (0.548, 0.557)
</td>
<td style="text-align:center;">
0.468 (0.464, 0.472)
</td>
<td style="text-align:center;">
0.26 (0.26, 0.267)
</td>
<td style="text-align:center;">
0.067 (0.065, 0.068)
</td>
<td style="text-align:center;">
0.013 (0.012, 0.013)
</td>
<td style="text-align:center;">
0.011 (0.01, 0.011)
</td>
</tr>
<tr>
<td style="text-align:center;">
GENDER (%)
</td>
<td style="text-align:center;">
Male
</td>
<td style="text-align:center;">
0.699 (0.694, 0.705)
</td>
<td style="text-align:center;">
0.577 (0.57, 0.583)
</td>
<td style="text-align:center;">
0.507 (0.501, 0.513)
</td>
<td style="text-align:center;">
0.301 (0.296, 0.306)
</td>
<td style="text-align:center;">
0.099 (0.096, 0.102)
</td>
<td style="text-align:center;">
0.023 (0.022, 0.023)
</td>
<td style="text-align:center;">
0.021 (0.02, 0.021)
</td>
</tr>
<tr>
<td style="text-align:center;">
Race/ethnicity (%)
</td>
<td style="text-align:center;">
Asian
</td>
<td style="text-align:center;">
0.676 (0.67, 0.682)
</td>
<td style="text-align:center;">
0.528 (0.522, 0.534)
</td>
<td style="text-align:center;">
0.45 (0.444, 0.456)
</td>
<td style="text-align:center;">
0.244 (0.238, 0.25)
</td>
<td style="text-align:center;">
0.073 (0.07, 0.076)
</td>
<td style="text-align:center;">
0.01 (0.01, 0.017)
</td>
<td style="text-align:center;">
0.011 (0.009, 0.014)
</td>
</tr>
<tr>
<td style="text-align:center;">
Race/ethnicity (%)
</td>
<td style="text-align:center;">
Black
</td>
<td style="text-align:center;">
0.714 (0.709, 0.718)
</td>
<td style="text-align:center;">
0.587 (0.582, 0.592)
</td>
<td style="text-align:center;">
0.506 (0.501, 0.511)
</td>
<td style="text-align:center;">
0.322 (0.317, 0.327)
</td>
<td style="text-align:center;">
0.091 (0.088, 0.093)
</td>
<td style="text-align:center;">
0.02 (0.019, 0.021)
</td>
<td style="text-align:center;">
0.017 (0.016, 0.018)
</td>
</tr>
<tr>
<td style="text-align:center;">
Race/ethnicity (%)
</td>
<td style="text-align:center;">
Hispanic
</td>
<td style="text-align:center;">
0.688 (0.683, 0.692)
</td>
<td style="text-align:center;">
0.54 (0.535, 0.545)
</td>
<td style="text-align:center;">
0.46 (0.455, 0.465)
</td>
<td style="text-align:center;">
0.239 (0.235, 0.244)
</td>
<td style="text-align:center;">
0.055 (0.053, 0.056)
</td>
<td style="text-align:center;">
0.011 (0.011, 0.011)
</td>
<td style="text-align:center;">
0.01 (0.009, 0.01)
</td>
</tr>
<tr>
<td style="text-align:center;">
Race/ethnicity (%)
</td>
<td style="text-align:center;">
Multiple
</td>
<td style="text-align:center;">
0.63 (0.559, 0.695)
</td>
<td style="text-align:center;">
0.483 (0.401, 0.563)
</td>
<td style="text-align:center;">
0.424 (0.347, 0.498)
</td>
<td style="text-align:center;">
0.242 (0.186, 0.312)
</td>
<td style="text-align:center;">
0.042 (0.021, 0.083)
</td>
<td style="text-align:center;">
0.006 (0.001, 0.042)
</td>
<td style="text-align:center;">
0.007 (0.001, 0.049)
</td>
</tr>
<tr>
<td style="text-align:center;">
Race/ethnicity (%)
</td>
<td style="text-align:center;">
Native Am Alaskan
</td>
<td style="text-align:center;">
0.814 (0.727, 0.88)
</td>
<td style="text-align:center;">
0.659 (0.558, 0.746)
</td>
<td style="text-align:center;">
0.577 (0.479, 0.667)
</td>
<td style="text-align:center;">
0.309 (0.225, 0.405)
</td>
<td style="text-align:center;">
0.144 (0.083, 0.223)
</td>
<td style="text-align:center;">
0.031 (0.011, 0.093)
</td>
<td style="text-align:center;">
0.032 (0.011, 0.096)
</td>
</tr>
<tr>
<td style="text-align:center;">
Race/ethnicity (%)
</td>
<td style="text-align:center;">
Other
</td>
<td style="text-align:center;">
0.641 (0.634, 0.649)
</td>
<td style="text-align:center;">
0.492 (0.509, 0.509)
</td>
<td style="text-align:center;">
0.418 (0.409, 0.426)
</td>
<td style="text-align:center;">
0.151 (0.128, 0.178)
</td>
<td style="text-align:center;">
0.018 (0.01, 0.031)
</td>
<td style="text-align:center;">
NA
</td>
<td style="text-align:center;">
NA
</td>
</tr>
<tr>
<td style="text-align:center;">
Race/ethnicity (%)
</td>
<td style="text-align:center;">
Pacific Islander
</td>
<td style="text-align:center;">
0.669 (0.626, 0.709)
</td>
<td style="text-align:center;">
0.511 (0.465, 0.559)
</td>
<td style="text-align:center;">
0.429 (0.386, 0.469)
</td>
<td style="text-align:center;">
0.238 (0.201, 0.279)
</td>
<td style="text-align:center;">
0.069 (0.049, 0.098)
</td>
<td style="text-align:center;">
0.025 (0.013, 0.045)
</td>
<td style="text-align:center;">
0.015 (0.007, 0.034)
</td>
</tr>
<tr>
<td style="text-align:center;">
Race/ethnicity (%)
</td>
<td style="text-align:center;">
Unknown
</td>
<td style="text-align:center;">
0.536 (0.53, 0.541)
</td>
<td style="text-align:center;">
0.396 (0.39, 0.402)
</td>
<td style="text-align:center;">
0.326 (0.321, 0.331)
</td>
<td style="text-align:center;">
0.069 (0.056, 0.083)
</td>
<td style="text-align:center;">
0.006 (0.003, 0.011)
</td>
<td style="text-align:center;">
0.001 (0, 0.007)
</td>
<td style="text-align:center;">
0.001 (0, 0.006)
</td>
</tr>
<tr>
<td style="text-align:center;">
Race/ethnicity (%)
</td>
<td style="text-align:center;">
White
</td>
<td style="text-align:center;">
0.746 (0.742, 0.75)
</td>
<td style="text-align:center;">
0.632 (0.627, 0.637)
</td>
<td style="text-align:center;">
0.546 (0.541, 0.551)
</td>
<td style="text-align:center;">
0.369 (0.363, 0.374)
</td>
<td style="text-align:center;">
0.138 (0.134, 0.141)
</td>
<td style="text-align:center;">
0.03 (0.029, 0.03)
</td>
<td style="text-align:center;">
0.027 (0.026, 0.027)
</td>
</tr>
<tr>
<td style="text-align:center;">
COVID Vaccinations (%)
</td>
<td style="text-align:center;">
\<3
</td>
<td style="text-align:center;">
0.684 (0.68, 0.687)
</td>
<td style="text-align:center;">
0.558 (0.554, 0.562)
</td>
<td style="text-align:center;">
0.485 (0.48, 0.489)
</td>
<td style="text-align:center;">
0.258 (0.254, 0.261)
</td>
<td style="text-align:center;">
0.062 (0.061, 0.064)
</td>
<td style="text-align:center;">
0.013 (0.012, 0.015)
</td>
<td style="text-align:center;">
0.012 (0.01, 0.014)
</td>
</tr>
<tr>
<td style="text-align:center;">
COVID Vaccinations (%)
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
0.728 (0.723, 0.733)
</td>
<td style="text-align:center;">
0.613 (0.607, 0.619)
</td>
<td style="text-align:center;">
0.536 (0.53, 0.542)
</td>
<td style="text-align:center;">
0.333 (0.327, 0.338)
</td>
<td style="text-align:center;">
0.077 (0.074, 0.079)
</td>
<td style="text-align:center;">
0.014 (0.013, 0.015)
</td>
<td style="text-align:center;">
0.01 (0.01, 0.019)
</td>
</tr>
<tr>
<td style="text-align:center;">
COVID Vaccinations (%)
</td>
<td style="text-align:center;">
3+
</td>
<td style="text-align:center;">
0.7 (0.695, 0.705)
</td>
<td style="text-align:center;">
0.556 (0.549, 0.562)
</td>
<td style="text-align:center;">
0.474 (0.468, 0.48)
</td>
<td style="text-align:center;">
0.275 (0.27, 0.281)
</td>
<td style="text-align:center;">
0.085 (0.082, 0.087)
</td>
<td style="text-align:center;">
0.018 (0.017, 0.018)
</td>
<td style="text-align:center;">
0.015 (0.015, 0.016)
</td>
</tr>
<tr>
<td style="text-align:center;">
NDI_group (%)
</td>
<td style="text-align:center;">
"\<-1"
</td>
<td style="text-align:center;">
0.713 (0.695, 0.73)
</td>
<td style="text-align:center;">
0.59 (0.586, 0.594)
</td>
<td style="text-align:center;">
0.499 (0.494, 0.503)
</td>
<td style="text-align:center;">
0.332 (0.328, 0.336)
</td>
<td style="text-align:center;">
0.097 (0.086, 0.11)
</td>
<td style="text-align:center;">
0.022 (0.017, 0.028)
</td>
<td style="text-align:center;">
0.02 (0.015, 0.028)
</td>
</tr>
<tr>
<td style="text-align:center;">
NDI_group (%)
</td>
<td style="text-align:center;">
"-1 - 0"
</td>
<td style="text-align:center;">
0.701 (0.696, 0.706)
</td>
<td style="text-align:center;">
0.566 (0.561, 0.572)
</td>
<td style="text-align:center;">
0.478 (0.472, 0.485)
</td>
<td style="text-align:center;">
0.283 (0.278, 0.288)
</td>
<td style="text-align:center;">
0.088 (0.085, 0.09)
</td>
<td style="text-align:center;">
0.017 (0.016, 0.017)
</td>
<td style="text-align:center;">
0.015 (0.015, 0.016)
</td>
</tr>
<tr>
<td style="text-align:center;">
NDI_group (%)
</td>
<td style="text-align:center;">
"0 - 1"
</td>
<td style="text-align:center;">
0.695 (0.689, 0.7)
</td>
<td style="text-align:center;">
0.553 (0.547, 0.559)
</td>
<td style="text-align:center;">
0.475 (0.468, 0.481)
</td>
<td style="text-align:center;">
0.265 (0.26, 0.27)
</td>
<td style="text-align:center;">
0.077 (0.074, 0.079)
</td>
<td style="text-align:center;">
0.017 (0.016, 0.017)
</td>
<td style="text-align:center;">
0.015 (0.014, 0.015)
</td>
</tr>
<tr>
<td style="text-align:center;">
NDI_group (%)
</td>
<td style="text-align:center;">
"\>1"
</td>
<td style="text-align:center;">
0.7 (0.695, 0.705)
</td>
<td style="text-align:center;">
0.568 (0.562, 0.574)
</td>
<td style="text-align:center;">
0.493 (0.487, 0.499)
</td>
<td style="text-align:center;">
0.27 (0.265, 0.275)
</td>
<td style="text-align:center;">
0.068 (0.066, 0.07)
</td>
<td style="text-align:center;">
0.015 (0.014, 0.015)
</td>
<td style="text-align:center;">
0.012 (0.011, 0.012)
</td>
</tr>
<tr>
<td style="text-align:center;">
Charlson_wt_group (%)
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
0.616 (0.612, 0.62)
</td>
<td style="text-align:center;">
0.458 (0.454, 0.463)
</td>
<td style="text-align:center;">
0.382 (0.378, 0.386)
</td>
<td style="text-align:center;">
0.162 (0.16, 0.165)
</td>
<td style="text-align:center;">
0.018 (0.018, 0.019)
</td>
<td style="text-align:center;">
0.003 (0.002, 0.003)
</td>
<td style="text-align:center;">
0.002 (0.002, 0.003)
</td>
</tr>
<tr>
<td style="text-align:center;">
Charlson_wt_group (%)
</td>
<td style="text-align:center;">
1-2
</td>
<td style="text-align:center;">
0.749 (0.744, 0.753)
</td>
<td style="text-align:center;">
0.594 (0.605, 0.605)
</td>
<td style="text-align:center;">
0.508 (0.502, 0.514)
</td>
<td style="text-align:center;">
0.283 (0.278, 0.288)
</td>
<td style="text-align:center;">
0.065 (0.063, 0.067)
</td>
<td style="text-align:center;">
0.011 (0.01, 0.011)
</td>
<td style="text-align:center;">
0.008 (0.008, 0.009)
</td>
</tr>
<tr>
<td style="text-align:center;">
Charlson_wt_group (%)
</td>
<td style="text-align:center;">
3-5
</td>
<td style="text-align:center;">
0.855 (0.852, 0.858)
</td>
<td style="text-align:center;">
0.765 (0.761, 0.77)
</td>
<td style="text-align:center;">
0.683 (0.677, 0.688)
</td>
<td style="text-align:center;">
0.522 (0.515, 0.528)
</td>
<td style="text-align:center;">
0.214 (0.207, 0.219)
</td>
<td style="text-align:center;">
0.043 (0.042, 0.044)
</td>
<td style="text-align:center;">
0.035 (0.034, 0.036)
</td>
</tr>
<tr>
<td style="text-align:center;">
Charlson_wt_group (%)
</td>
<td style="text-align:center;">
6+
</td>
<td style="text-align:center;">
0.886 (0.883, 0.888)
</td>
<td style="text-align:center;">
0.824 (0.82, 0.827)
</td>
<td style="text-align:center;">
0.78 (0.775, 0.784)
</td>
<td style="text-align:center;">
0.688 (0.682, 0.693)
</td>
<td style="text-align:center;">
0.381 (0.374, 0.39)
</td>
<td style="text-align:center;">
0.103 (0.101, 0.107)
</td>
<td style="text-align:center;">
0.09 (0.087, 0.093)
</td>
</tr>
</tbody>
</table>

## Rates stratified by covariates

As discussed, time-to-event rates vary little across demographic groups
(usually on the order of half a day). Therefore, only the stratified
estimates of the location parameter and median time-to-event for
*Outpatient or worse* and *Inpatient or worse* are presented.

As a reminder, here are the parameters and mean time-to-events for
*Outpatient or worse* and *Inpatient or worse* for COVID-19 across all
groups.

<table>
<caption>
Parameters and median time-to-event across all COVID-19 Infections
</caption>
<thead>
<tr>
<th style="text-align:center;">
Outpatient + Distribution
</th>
<th style="text-align:center;">
Outpatient + Parameters
</th>
<th style="text-align:center;">
Outpatient + Median Time To Event
</th>
<th style="text-align:center;">
Inpatient + Distribution
</th>
<th style="text-align:center;">
Inpatient + Parameters
</th>
<th style="text-align:center;">
Inpatient + Median Time To Event
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 1.43, logsd = 0.934
</td>
<td style="text-align:center;">
4.17 (4.09, 4.24)
</td>
<td style="text-align:center;">
Log normal
</td>
<td style="text-align:center;">
logmean = 1.93, logsd = 0.971
</td>
<td style="text-align:center;">
4.17 (4.09, 4.24)
</td>
</tr>
</tbody>
</table>

And here are the stratified estimates.

<table>
<caption>
Location parameter and median time-to-event stratified by demographic
covariates for COVID-19
</caption>
<thead>
<tr>
<th style="text-align:center;">
Characteristic
</th>
<th style="text-align:center;">
Group
</th>
<th style="text-align:center;">
Outpatient + Location Parameter Estimate
</th>
<th style="text-align:center;">
Outpatient + Median Time To Event
</th>
<th style="text-align:center;">
Inpatient + Location Parameter
</th>
<th style="text-align:center;">
Inpatient + Median Time To Event
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:center;">
Age (%)
</td>
<td style="text-align:center;">
0-17
</td>
<td style="text-align:center;">
1.196
</td>
<td style="text-align:center;">
3.31 (2.46, 4.32)
</td>
<td style="text-align:center;">
1.846
</td>
<td style="text-align:center;">
6.34 (4.11, 10.47)
</td>
</tr>
<tr>
<td style="text-align:center;">
Age (%)
</td>
<td style="text-align:center;">
18-49
</td>
<td style="text-align:center;">
1.384
</td>
<td style="text-align:center;">
3.99 (2.68, 6.12)
</td>
<td style="text-align:center;">
1.866
</td>
<td style="text-align:center;">
6.46 (3.49, 12.48)
</td>
</tr>
<tr>
<td style="text-align:center;">
Age (%)
</td>
<td style="text-align:center;">
50-59
</td>
<td style="text-align:center;">
1.401
</td>
<td style="text-align:center;">
4.06 (2.67, 6.04)
</td>
<td style="text-align:center;">
1.979
</td>
<td style="text-align:center;">
7.23 (3.69, 13.84)
</td>
</tr>
<tr>
<td style="text-align:center;">
Age (%)
</td>
<td style="text-align:center;">
60-69
</td>
<td style="text-align:center;">
1.443
</td>
<td style="text-align:center;">
4.23 (2.76, 6.28)
</td>
<td style="text-align:center;">
1.987
</td>
<td style="text-align:center;">
7.3 (3.88, 13.9)
</td>
</tr>
<tr>
<td style="text-align:center;">
Age (%)
</td>
<td style="text-align:center;">
70-79
</td>
<td style="text-align:center;">
1.504
</td>
<td style="text-align:center;">
4.5 (3.02, 6.66)
</td>
<td style="text-align:center;">
1.968
</td>
<td style="text-align:center;">
7.15 (3.71, 13.56)
</td>
</tr>
<tr>
<td style="text-align:center;">
Age (%)
</td>
<td style="text-align:center;">
80-89
</td>
<td style="text-align:center;">
1.508
</td>
<td style="text-align:center;">
4.52 (2.97, 6.62)
</td>
<td style="text-align:center;">
1.868
</td>
<td style="text-align:center;">
6.48 (3.53, 12.63)
</td>
</tr>
<tr>
<td style="text-align:center;">
Age (%)
</td>
<td style="text-align:center;">
90+
</td>
<td style="text-align:center;">
1.545
</td>
<td style="text-align:center;">
4.69 (3.11, 7.12)
</td>
<td style="text-align:center;">
1.907
</td>
<td style="text-align:center;">
6.73 (3.53, 12.29)
</td>
</tr>
<tr>
<td style="text-align:center;">
GENDER (%)
</td>
<td style="text-align:center;">
Female
</td>
<td style="text-align:center;">
1.459
</td>
<td style="text-align:center;">
4.3 (3.87, 4.79)
</td>
<td style="text-align:center;">
1.938
</td>
<td style="text-align:center;">
6.94 (6.06, 7.93)
</td>
</tr>
<tr>
<td style="text-align:center;">
GENDER (%)
</td>
<td style="text-align:center;">
Male
</td>
<td style="text-align:center;">
1.383
</td>
<td style="text-align:center;">
3.98 (3.45, 4.63)
</td>
<td style="text-align:center;">
1.963
</td>
<td style="text-align:center;">
6.77 (5.6, 8.16)
</td>
</tr>
<tr>
<td style="text-align:center;">
Race/ethnicity (%)
</td>
<td style="text-align:center;">
Asian
</td>
<td style="text-align:center;">
1.405
</td>
<td style="text-align:center;">
4.07 (0, Inf)
</td>
<td style="text-align:center;">
1.966
</td>
<td style="text-align:center;">
7.14 (0, Inf)
</td>
</tr>
<tr>
<td style="text-align:center;">
Race/ethnicity (%)
</td>
<td style="text-align:center;">
Black
</td>
<td style="text-align:center;">
1.480
</td>
<td style="text-align:center;">
4.39 (0, Inf)
</td>
<td style="text-align:center;">
1.941
</td>
<td style="text-align:center;">
6.97 (0, Inf)
</td>
</tr>
<tr>
<td style="text-align:center;">
Race/ethnicity (%)
</td>
<td style="text-align:center;">
Hispanic
</td>
<td style="text-align:center;">
1.381
</td>
<td style="text-align:center;">
3.98 (0, Inf)
</td>
<td style="text-align:center;">
1.959
</td>
<td style="text-align:center;">
7.09 (0, Inf)
</td>
</tr>
<tr>
<td style="text-align:center;">
Race/ethnicity (%)
</td>
<td style="text-align:center;">
Multiple
</td>
<td style="text-align:center;">
1.438
</td>
<td style="text-align:center;">
4.21 (0, Inf)
</td>
<td style="text-align:center;">
2.005
</td>
<td style="text-align:center;">
7.43 (0, Inf)
</td>
</tr>
<tr>
<td style="text-align:center;">
Race/ethnicity (%)
</td>
<td style="text-align:center;">
Native Am Alaskan
</td>
<td style="text-align:center;">
1.549
</td>
<td style="text-align:center;">
4.71 (0, Inf)
</td>
<td style="text-align:center;">
1.962
</td>
<td style="text-align:center;">
7.11 (0, Inf)
</td>
</tr>
<tr>
<td style="text-align:center;">
Race/ethnicity (%)
</td>
<td style="text-align:center;">
Other
</td>
<td style="text-align:center;">
1.352
</td>
<td style="text-align:center;">
3.87 (0, Inf)
</td>
<td style="text-align:center;">
2.172
</td>
<td style="text-align:center;">
8.78 (0, Inf)
</td>
</tr>
<tr>
<td style="text-align:center;">
Race/ethnicity (%)
</td>
<td style="text-align:center;">
Pacific Islander
</td>
<td style="text-align:center;">
1.376
</td>
<td style="text-align:center;">
3.96 (0, Inf)
</td>
<td style="text-align:center;">
1.576
</td>
<td style="text-align:center;">
4.84 (0, Inf)
</td>
</tr>
<tr>
<td style="text-align:center;">
Race/ethnicity (%)
</td>
<td style="text-align:center;">
Unknown
</td>
<td style="text-align:center;">
1.254
</td>
<td style="text-align:center;">
3.5 (0, Inf)
</td>
<td style="text-align:center;">
1.842
</td>
<td style="text-align:center;">
6.31 (0, Inf)
</td>
</tr>
<tr>
<td style="text-align:center;">
Race/ethnicity (%)
</td>
<td style="text-align:center;">
White
</td>
<td style="text-align:center;">
1.500
</td>
<td style="text-align:center;">
4.48 (0, Inf)
</td>
<td style="text-align:center;">
1.889
</td>
<td style="text-align:center;">
6.61 (0, Inf)
</td>
</tr>
<tr>
<td style="text-align:center;">
COVID Vaccinations (%)
</td>
<td style="text-align:center;">
\<3
</td>
<td style="text-align:center;">
1.355
</td>
<td style="text-align:center;">
3.87 (3.55, 4.21)
</td>
<td style="text-align:center;">
1.809
</td>
<td style="text-align:center;">
6.1 (5.59, 6.71)
</td>
</tr>
<tr>
<td style="text-align:center;">
COVID Vaccinations (%)
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
1.342
</td>
<td style="text-align:center;">
3.83 (3.42, 4.31)
</td>
<td style="text-align:center;">
1.862
</td>
<td style="text-align:center;">
6.44 (5.68, 7.31)
</td>
</tr>
<tr>
<td style="text-align:center;">
COVID Vaccinations (%)
</td>
<td style="text-align:center;">
3+
</td>
<td style="text-align:center;">
1.460
</td>
<td style="text-align:center;">
4.31 (3.86, 4.87)
</td>
<td style="text-align:center;">
1.957
</td>
<td style="text-align:center;">
7.07 (6.25, 8.04)
</td>
</tr>
<tr>
<td style="text-align:center;">
NDI_group (%)
</td>
<td style="text-align:center;">
\<-1
</td>
<td style="text-align:center;">
1.448
</td>
<td style="text-align:center;">
4.25 (4, 4.51)
</td>
<td style="text-align:center;">
1.934
</td>
<td style="text-align:center;">
6.92 (6.39, 7.5)
</td>
</tr>
<tr>
<td style="text-align:center;">
NDI_group (%)
</td>
<td style="text-align:center;">
-1
</td>
<td style="text-align:center;">
1.464
</td>
<td style="text-align:center;">
4.32 (3.93, 4.7)
</td>
<td style="text-align:center;">
1.899
</td>
<td style="text-align:center;">
6.68 (5.94, 7.44)
</td>
</tr>
<tr>
<td style="text-align:center;">
NDI_group (%)
</td>
<td style="text-align:center;">
0 - 1
</td>
<td style="text-align:center;">
1.411
</td>
<td style="text-align:center;">
4.1 (3.72, 4.49)
</td>
<td style="text-align:center;">
1.941
</td>
<td style="text-align:center;">
6.96 (6.24, 7.79)
</td>
</tr>
<tr>
<td style="text-align:center;">
NDI_group (%)
</td>
<td style="text-align:center;">
\>1
</td>
<td style="text-align:center;">
1.384
</td>
<td style="text-align:center;">
3.99 (3.64, 4.36)
</td>
<td style="text-align:center;">
1.948
</td>
<td style="text-align:center;">
7.02 (6.29, 7.88)
</td>
</tr>
<tr>
<td style="text-align:center;">
Charlson_wt_group (%)
</td>
<td style="text-align:center;">
0
</td>
<td style="text-align:center;">
1.314
</td>
<td style="text-align:center;">
3.72 (3.42, 4.02)
</td>
<td style="text-align:center;">
1.784
</td>
<td style="text-align:center;">
5.95 (5.43, 6.58)
</td>
</tr>
<tr>
<td style="text-align:center;">
Charlson_wt_group (%)
</td>
<td style="text-align:center;">
1-2
</td>
<td style="text-align:center;">
1.442
</td>
<td style="text-align:center;">
4.23 (3.75, 4.77)
</td>
<td style="text-align:center;">
1.854
</td>
<td style="text-align:center;">
6.39 (5.64, 7.33)
</td>
</tr>
<tr>
<td style="text-align:center;">
Charlson_wt_group (%)
</td>
<td style="text-align:center;">
3-5
</td>
<td style="text-align:center;">
1.550
</td>
<td style="text-align:center;">
4.71 (4.17, 5.28)
</td>
<td style="text-align:center;">
1.939
</td>
<td style="text-align:center;">
6.95 (6.06, 7.94)
</td>
</tr>
<tr>
<td style="text-align:center;">
Charlson_wt_group (%)
</td>
<td style="text-align:center;">
6+
</td>
<td style="text-align:center;">
1.643
</td>
<td style="text-align:center;">
5.17 (4.61, 5.82)
</td>
<td style="text-align:center;">
2.014
</td>
<td style="text-align:center;">
7.5 (6.54, 8.58)
</td>
</tr>
</tbody>
</table>
