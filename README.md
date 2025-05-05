Parameterizing healthcare utilization progressions of respiratory
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
*first event* to occur following a *starting event*, as well as reaching each acuity threshold, or *outcome
or more severe* for each outcome from a *starting event*. The first
transition type can help answer questions about how people are moving
through the healthcare cascade. The
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
occurance, and time-to-event estimates (examples below) for COVID-19,
Influenza, and RSV are provided in the *Parameter_Tables* folder. The
methods and further discussion of these results will be provided in an
upcoming paper (link will be provided here when published). 

## Methods

We used the flexsurv package in R, which allowed us to create parametric 
mixture models. We employed a competing risk framework for the first event models, as there are multiple states that an individual can move to, some of which might occur before others and prohibit
them from occurring. This package is also useful because it allows for flexibility in
distributions. Using AIC, we compared the models’ performance using
different distributions to find the best fitting distribution for each
transition of interest.

<img width="1065" alt="image" src="https://github.com/user-attachments/assets/564b0e44-43df-4307-8215-818247f8b494" />


Graphical representation of inclusions criteria. 

Above shows a figure describing our inclusion criteria for acute
respiratory infection events. We looked between -7 and +30 days of a
positive test to find events. From those events, we looked 20 days out
to find the first event, if any, and 60 days out to find any events more severe. We also provide
first event model parameters using a 60 day follow up period, but differnces between the two are small. 

This extended criteria allowed us to restrict ARI healthcare events to being
related/caused by COVID infections, while still including healthcare
events that might take more than 20 days (like death) after the initial
event.

## Types of Outputs

Below are example outputs for the first event and outcome or worse
analyses (along with the stratified estimates) for COVID-19.

## First Event

There are two first event tables for each pathogen: a first_event_20 that shows the parameterized progressions using a follow-up period of 20 days, and first_event_60, which uses a 60 day follow-up period. 

The “First Event” following a “Starting State” for COVID Infections:

*For example, there is a 36.8% chance that the first event following
symptom onset is an urgent care visit. The median time to these urgent
care visits is 2.85 days following symptom onset.*

## Outcome or worse

The distribution of progressing to each outcome or more severe state
from each starting state:

*For example, there is a 48.3% chance that the of experiencing an urgent
care visit or worse event following symptom onset of a COVID-19
infection. The median time to this outcome is 4.04 days following
symptom onset.*


## Probabilities stratified by covariates

All of the *Event or more severe state* outcomes were stratified by
available demographic variables. Presented here are the probabilities of
each outcome stratified by various covariates.


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
