###############
###############
###### Clinical progression parameters associated with SARS-CoV-2, influenza, and respiratory syncytial virus infections
###### Parker et. al
###############
###############


##### Shown below is a sample of the code used to run the analysis to parameterize progressions through the healthcare utilization cascade for respiratory diseases. We show here sample code for the influenza analysis and for a subset of the progressions (from symptom onset and emergency visit as starting events) for brevity, though the same code can be used to repeat the analyses for other diseases and progressions. The required data is time-to-event healthcare utilization data (see below for example of the structure of the data). Any questions or necessary clarifications can be directed to noahtparker3@berkeley.edu. 
#####

##### load in required packages
library(survival)
library(foreign)
library(readr)
library(dplyr)
library(tidyverse)
library(assertthat)
library(flexsurv)
library(haven)


### to begin, source functions.R to run all necessary functions


############
############
##### Data format
############
############

### this creates a small example of the time-to-event data that was used to run this analysis
example_data <- tibble(studyid = c(rep(1, 5), rep(2,1), rep(3,5)),
       age = c(rep(60, 5), rep(32,1), rep(2,5)),
       gender = c(rep("M", 5), rep("F", 1), rep("M", 5)),
       race_eth = c(rep("White", 5), rep("Black", 1), rep("Hispanic", 5)),
       ndi = c(rep(2, 5), rep(1, 1), rep(2,5)), ## can add any other demographic covariates as well
       event_type = c("VIRTUAL", "LAB", "EMERGENCY", "INPATIENT", "DEATH",
                      "LAB",
                      "OUTPATIENT", "URGENTCARE", "INPATIENT", "LAB", "VIRTUAL"),
       event_days = c(0, 4, 5, 6, 22,
                      0,
                      0, 48, 48, 48, 55),
       los = c(0,0,0,14,0,
               0,
               0,0,4,0,0),
       sym_onset_days_event = c(-2, -6, -7, -8, -24, ### sym_onset is the event day symptom onset occured - event day
                     NA,
                     -6, -1, -1, -1, 8),
       COVID = c(NA, "POSITIVE", NA, NA, NA,
                 "NEGATIVE",
                 NA, NA, NA, "NEGATIVE", NA),
       Flu = c(NA, NA, NA, NA, NA,
                 "NEGATIVE",
                 NA, NA, NA, NA, NA),
       Flu_A = c(NA, NA, NA, NA, NA,
                 "NEGATIVE",
                 NA, NA, NA, "POSITIVE", NA),
       Flu_B = c(NA, NA, NA, NA, NA,
                 "NEGATIVE",
                 NA, NA, NA, "NEGATIVE", NA),
       RSV = c(NA, NA, NA, NA, NA,
                 "NEGATIVE",
                 NA, NA, NA, NA, NA),
       RSV_A = c(NA, NA, NA, NA, NA,
                 "NEGATIVE",
                 NA, NA, NA, "NEGATIVE", NA),
       RSV_B = c(NA, NA, NA, NA, NA,
                 "NEGATIVE",
                 NA, NA, NA, "NEGATIVE", NA)
        )



### prep data
#filter for just ever Flu A or B positive
flu.pos <- data %>% group_by(studyid) %>%
  filter(any(str_detect(Flu_A, 'POSITIVE')) | any(str_detect(Flu_B, 'POSITIVE')) | any(str_detect(Flu, 'POSITIVE')))

#Clean the flu positive datset - add an event variable that combines lab, ventilation, with setting variable. 
clean.flu.pos <- flu.pos %>% mutate(event = ifelse(event_type == "Lab", "LAB", 
                                                   ifelse(event_type == "Ventilation", "VENTILATION",
                                                          ifelse(event_type == "Death", "DEATH", setting))))

# strips urgent care label of spaces
clean.flu.pos <- clean.flu.pos %>% mutate(event = ifelse(event == "URGENT CARE", "URGENTCARE", event))


#add in a variable flu_pos_time that has the time of closest positive flu test for each observation per studyid. Then create a variable time_from_pos_flu that has the time to the closest positive test for each observation
flu.time_from_pos_flu <- flu.pos.clean %>% mutate(flu_pos_time = ifelse(Flu_A == 'POSITIVE' | Flu_B == 'POSITVE' | Flu == 'POSITIVE', event_days, NA)) %>% group_by(studyid) %>% fill(flu_pos_time, .direction = "downup") %>% mutate(time_from_pos_flu = event_days - flu_pos_time)


###########
###########
#### example of first event, and event or worse, analysis from symptom onset
###########
###########


##take the implied symptom onset date for each event, given that event is within -15 and 30 days from a positive flu test
flu.implied_time_from_symps <- flu.time_from_pos_flu %>% mutate(event_days_implied_sym = ifelse((time_from_pos_flu >= -15 & time_from_pos_flu <= 30), event_days + sym_onset_days_event, NA))

#for each person, find the first implied symptom onset for that flu infection
flu.min_onset <- flu.implied_time_from_symps %>% group_by(studyid) %>% mutate(min_symp_onset = min(event_days_implied_sym, na.rm = T))

#for each event, find the time from this first implied symptom onset to each event, filtering out Infs created by finding the min of NA's - therefore they have no event
flu.sym_onset_each_event <- flu.min_onset %>% filter(min_symp_onset != Inf) %>% mutate(time_from_symp_clean = event_days - min_symp_onset)

#filter so has to be at least one day from symptom onset because we can't trust the 0 days. Also change LAB to NA, as we will not be modeling it
flu.sym.nozero <- flu.sym_onset_each_event %>% filter(time_from_symp_clean >= 1) %>% mutate(event_clean = ifelse(time_from_symp_clean < 20, as.character(event), NA)) %>% mutate(event_clean = ifelse(event_clean == "LAB", NA, event_clean)) %>% mutate(time_clean = ifelse(is.na(event_clean), 20, time_from_symp_clean)) %>% mutate(time_clean = ifelse(time_clean == 0, 0.1, time_clean))

# factor event columns to ensure its in correct order from low to high acuity state
flu.sym.nozero$event <- factor(flu.sym.nozero$event, levels = c("VIRTUAL", "OUTPATIENT", "URGENTCARE",  "EMERGENCY", "INPATIENT", "VENTILATION", "DEATH"))

# take the first event per person after symptom onset
flu.sym.first_event <- flu.sym.nozero %>%
  group_by(studyid) %>%
  slice(1) %>%
  ungroup() 

# if there is no event after symptom onset, then mark as censored and assign status as 0 (1 for everyone else)
flu.sym.fe <- flu.sym.first_event %>% mutate(first_event = ifelse(is.na(event_clean), "CENS", event_clean)) %>% mutate(status = ifelse(first_event == "CENS", 0, 1))

# counts of first events
table(flu.sym.fe$first_event)

# filter out death and ventilation, as they are 1) low in events, 2) likely misclassified as being the first event from symptom onset
flu.sym.fe <- flu.sym.fe %>% filter(!first_event %in% c("DEATH", "VENTILATION"))

###########
##### finding the best fitting distribution for each transition
###########

## distributions go in alphabetical order, so c("CENS" , DEATH", "EMERGENCY", "INPATIENT", "OUTPATIENT", "URGENTCARE", "VIRTUAL")
### ventilation does not occur as first event, so can disregard

#find the best fitting distribution for first_event = death, position = 2
best.dist.fe(flu.sym.fe, c("exp", "gamma", "weibull", "gamma", "exp"), dist_position = 2)

#find the best fitting distribution for first_event = emergency, position = 3
best.dist.fe(flu.sym.fe, c("exp", "lnorm", "weibull", "exp", "exp"), dist_position = 3)

#find the best fitting distribution for first_event = inpatient, position = 4
best.dist.fe(flu.sym.fe, c("exp", "lnorm", "lnorm", "gamma", "exp"), dist_position = 4)

#find the best fitting distribution for first_event = outpatient, position = 5
best.dist.fe(flu.sym.fe, c("exp", "lnorm", "gamma", "exp", "exp"), dist_position = 5)

#find the best fitting distribution for first_event = urgentcare, position = 6

best.dist.fe(flu.sym.fe, c("exp", "lnorm", "gamma", "lnorm", "lnorm"), dist_position = 6)

#find the best fitting distribution for first_event = virtual, position = 7

best.dist.fe(flu.sym.fe, c("exp", "lnorm", "gamma", "lnorm", "lnorm"), dist_position = 7)



###run the first event model 
flu.sym.mixmodel <- flexsurvmix(Surv(time_clean, status) ~ 1,
                                event = first_event,
                                data= flu.sym.fe, 
                                dists=c(CENS = "exp", EMERGENCY = "lnorm", INPATIENT = "gamma", OUTPATIENT = "lnorm", URGENTCARE = "lnorm", VIRTUAL ="lnorm"),
                                method = "em", 
                                em.control = list(trace=1),
                                optim.control=list(maxit=1000),
                                inits = c())
flu.sym.mixmodel

### get fits across modeled time points per event and plot
flu.sym.aj <- ajfit_flexsurvmix(flu.sym.mixmodel, startname="SYMPTOM ONSET/NO HEALTHCARE", B = 100)
flu.sym.model.plot <- ggplot(flu.sym.aj, aes(x=time, y=val, col=state, lty=model)) +
  geom_line() + 
  xlab("Days after symptom onset") + ylab("Probability of next event") + 
  labs(col="State") + labs(lty="Model") +
  xlim(0,60)
flu.sym.model.plot

#find the probability at t = 15 with 1000 bootstrapped samples
p_flexsurvmix(flu.sym.mixmodel, t = c(15), B= 1000, startname = "SYM ONSET") %>% mutate_at(vars(val, lower, upper), list(~ round(., 3)))  %>% arrange(factor(state, levels = c("VIRTUAL", "OUTPATIENT", "URGENTCARE",  "EMERGENCY", "INPATIENT", "VENTILATION", "DEATH")))

#find the total probability with 1000 bootstrapped samples
probs_flexsurvmix(flu.sym.mixmodel, B = 1000) %>% mutate_at(vars(val, lower, upper), list(~ round(., 3)))  %>% arrange(factor(event, levels = c("VIRTUAL", "OUTPATIENT", "URGENTCARE",  "EMERGENCY", "INPATIENT", "VENTILATION", "DEATH")))

#find the median time to event with 1000 bootstrapped samples
quantile_flexsurvmix(flu.sym.mixmodel, B = 1000, probs = 0.5) %>% filter(event != "CENS") %>%  mutate_at(vars(val, lower, upper), list(~ round(., 2)))  %>% arrange(factor(event, levels = c("VIRTUAL", "OUTPATIENT", "URGENTCARE",  "EMERGENCY", "INPATIENT", "VENTILATION", "DEATH")))

#find the 25th and 75th percentile time to event for IQR with 1000 bootstrapped samples
quantile_flexsurvmix(flu.sym.mixmodel, B = 1000, probs = c(0.25, 0.75)) %>% filter(event != "CENS") %>% mutate_at(vars(val, lower, upper), list(~ round(., 2)))  %>% arrange(p, factor(event, levels = c("VIRTUAL", "OUTPATIENT", "URGENTCARE",  "EMERGENCY", "INPATIENT", "VENTILATION", "DEATH")))

#find the mean time to event with 1000 bootstrapped samples
mean_flexsurvmix(flu.sym.mixmodel, B = 1000) %>% 
  mutate(model="Mixture", quantity="mean")



############
####### make datasets for every transition of symptom onset to or worse event
####### i.e. flu.sym.outpatient = first outpatient event or worse from symptom onset
############

###make the datasets using the from.symp.function (see Functions.R)

flu.sym.virtual <- from.symp.function(flu.time_from_pos_flu, "VIRTUAL", c("VIRTUAL", "OUTPATIENT", "URGENTCARE", "EMERGENCY", "INPATIENT", "VENTILATION", "DEATH"), time_from_variable = time_from_pos_flu) 

flu.sym.outpatient <- from.symp.function(flu.time_from_pos_flu, "OUTPATIENT", c("OUTPATIENT", "URGENTCARE", "EMERGENCY", "INPATIENT", "VENTILATION", "DEATH"), time_from_variable = time_from_pos_flu) 

flu.sym.uc <- from.symp.function(flu.time_from_pos_flu, "URGENTCARE", c("URGENTCARE", "EMERGENCY", "INPATIENT", "VENTILATION", "DEATH"), time_from_variable = time_from_pos_flu) 

flu.sym.emerg <- from.symp.function(flu.time_from_pos_flu, "EMERGENCY", c("EMERGENCY", "INPATIENT", "VENTILATION", "DEATH"), time_from_variable = time_from_pos_flu) 

flu.sym.inpatient <- from.symp.function(flu.time_from_pos_flu, "INPATIENT", c("INPATIENT", "VENTILATION", "DEATH"), time_from_variable = time_from_pos_flu) 

flu.sym.ventilation <- from.symp.function(flu.time_from_pos_flu, "VENTILATION", c("VENTILATION", "DEATH"), time_from_variable = time_from_pos_flu) 

flu.sym.death <- from.symp.function(flu.time_from_pos_flu, "DEATH", c("DEATH"), time_from_variable = time_from_pos_flu) 


###virtual + model
###Find the best fitting distribution
best.dist.orworse(flu.sym.virtual)

### run the virtual or worse model with the best fitting distribution
flu.sym.virtual.model <- flexsurvmix(Surv(time_clean, orworse.event) ~ 1,
                                     event = state,
                                     data = flu.sym.virtual, 
                                     dists = c("VIRTUAL -" = "exp", "VIRTUAL +" = "gengamma"),
                                     method = "em", 
                                     em.control = list(trace = 1),
                                     optim.control = list(maxit = 1000),
                                     inits = c())
flu.sym.virtual.model

### get fits and plot
flu.sym.virtual.aj <- ajfit_flexsurvmix(flu.sym.virtual.model, maxt = 60, startname = "SYMPTOM ONSET")

flu.sym.virtual.plot <- ggplot(flu.sym.virtual.aj, aes(x=time, y=val, col=state, lty=model)) +
  geom_line() + 
  xlab("Days after symptom onset") + ylab("Probability of next event") + 
  labs(col="State") + labs(lty="Model") +
  xlim(0,30)
flu.sym.virtual.plot

#get distribution statistics
compile_results(flu.sym.virtual.model, B = 1000, times = c(15, 30))

###outpatient + model
###Find the best fitting distribution
best.dist.orworse(flu.sym.outpatient)
###
flu.sym.outpatient.model <- flexsurvmix(Surv(time_clean, orworse.event) ~ 1,
                                        event = state,
                                        data = flu.sym.outpatient, 
                                        dists = c("OUTPATIENT -" = "exp", "OUTPATIENT +" = "lnorm"),
                                        method = "em", 
                                        em.control = list(trace = 1),
                                        optim.control = list(maxit = 1000),
                                        inits = c())
flu.sym.outpatient.model
flu.sym.outpatient.aj <- ajfit_flexsurvmix(flu.sym.outpatient.model, maxt = 60, startname = "SYMPTOM ONSET")

flu.sym.outpatient.plot <- ggplot(flu.sym.outpatient.aj, aes(x=time, y=val, col=state, lty=model)) +
  geom_line() + 
  xlab("Days after symptom onset") + ylab("Probability of next event") + 
  labs(col="State") + labs(lty="Model") +
  xlim(0,30)
flu.sym.outpatient.plot

#get distribution statistics
compile_results(flu.sym.outpatient.model, B = 1000, times = c(15, 30))

###urgent care + model
###Find the best fitting distribution
best.dist.orworse(flu.sym.uc)
###
flu.sym.uc.model <- flexsurvmix(Surv(time_clean, orworse.event) ~ 1,
                                event = state,
                                data = flu.sym.uc, 
                                dists = c("URGENTCARE -" = "exp", "URGENTCARE +" = "lnorm"),
                                method = "em", 
                                em.control = list(trace = 1),
                                optim.control = list(maxit = 1000),
                                inits = c())
flu.sym.uc.model
flu.sym.uc.aj <- ajfit_flexsurvmix(flu.sym.uc.model, maxt = 60, startname = "SYMPTOM ONSET")

flu.sym.uc.plot <- ggplot(flu.sym.uc.aj, aes(x=time, y=val, col=state, lty=model)) +
  geom_line() + 
  xlab("Days after symptom onset") + ylab("Probability of next event") + 
  labs(col="State") + labs(lty="Model") +
  xlim(0,30)
flu.sym.uc.plot

#get distribution statistics
compile_results(flu.sym.uc.model, B = 1000, times = c(15, 30))

###emergency + model
###Find the best fitting distribution
best.dist.orworse(flu.sym.emerg)
###
flu.sym.emerg.model <- flexsurvmix(Surv(time_clean, orworse.event) ~ 1,
                                   event = state,
                                   data = flu.sym.emerg, 
                                   dists = c("EMERGENCY -" = "exp", "EMERGENCY +" = "gengamma"),
                                   method = "em", 
                                   em.control = list(trace = 1),
                                   optim.control = list(maxit = 1000),
                                   inits = c())
flu.sym.emerg.model

flu.sym.emerg.aj <- ajfit_flexsurvmix(flu.sym.emerg.model, maxt = 60, startname = "SYMPTOM ONSET")

flu.sym.emerg.plot <- ggplot(flu.sym.emerg.aj, aes(x=time, y=val, col=state, lty=model)) +
  geom_line() + 
  xlab("Days after symptom onset") + ylab("Probability of next event") + 
  labs(col="State") + labs(lty="Model") +
  xlim(0,30)
flu.sym.emerg.plot

#get distribution statistics
compile_results(flu.sym.emerg.model, B = 1000, times = c(15, 30))

###inpatient + model
###Find the best fitting distribution
best.dist.orworse(flu.sym.inpatient)
###
flu.sym.inpatient.model <- flexsurvmix(Surv(time_clean, orworse.event) ~ 1,
                                       event = state,
                                       data = flu.sym.inpatient, 
                                       dists = c("INPATIENT -" = "exp", "INPATIENT +" = "gengamma"),
                                       method = "em", 
                                       em.control = list(trace = 1),
                                       optim.control = list(maxit = 1000),
                                       inits = c())
flu.sym.inpatient.model
flu.sym.inpatient.aj <- ajfit_flexsurvmix(flu.sym.inpatient.model, maxt = 60, startname = "SYMPTOM ONSET")

flu.sym.inpatient.plot <- ggplot(flu.sym.inpatient.aj, aes(x=time, y=val, col=state, lty=model)) +
  geom_line() + 
  xlab("Days after symptom onset") + ylab("Probability of next event") + 
  labs(col="State") + labs(lty="Model") +
  xlim(0,30)
flu.sym.inpatient.plot

#get distribution statistics
compile_results(flu.sym.inpatient.model, B = 1000, times = c(15, 30))

###ventilation + model
###Find the best fitting distribution
best.dist.orworse(flu.sym.ventilation)
###
flu.sym.ventilation.model <- flexsurvmix(Surv(time_clean, orworse.event) ~ 1,
                                         event = state,
                                         data = flu.sym.ventilation, 
                                         dists = c("VENTILATION -" = "exp", "VENTILATION +" = "weibull"),
                                         method = "em", 
                                         em.control = list(trace = 1),
                                         optim.control = list(maxit = 1000),
                                         inits = c())
flu.sym.ventilation.model
flu.sym.ventilation.aj <- ajfit_flexsurvmix(flu.sym.ventilation.model, maxt = 60, startname = "SYMPTOM ONSET")

flu.sym.ventilation.plot <- ggplot(flu.sym.ventilation.aj, aes(x=time, y=val, col=state, lty=model)) +
  geom_line() + 
  xlab("Days after symptom onset") + ylab("Probability of next event") + 
  labs(col="State") + labs(lty="Model") +
  xlim(0,30)
flu.sym.ventilation.plot

#get distribution statistics
compile_results(flu.sym.ventilation.model, B = 1000, times = c(15, 30))

###death + model
###Find the best fitting distribution
best.dist.orworse(flu.sym.death)
###
flu.sym.death.model <- flexsurvmix(Surv(time_clean, orworse.event) ~ 1,
                                   event = state,
                                   data = flu.sym.death, 
                                   dists = c("DEATH -" = "exp", "DEATH +" = "weibull"),
                                   method = "em", 
                                   em.control = list(trace = 1),
                                   optim.control = list(maxit = 1000),
                                   inits = c())
flu.sym.death.model
flu.sym.death.aj <- ajfit_flexsurvmix(flu.sym.death.model, maxt = 60, startname = "SYMPTOM ONSET")

flu.sym.death.plot <- ggplot(flu.sym.death.aj, aes(x=time, y=val, col=state, lty=model)) +
  geom_line() + 
  xlab("Days after symptom onset") + ylab("Probability of next event") + 
  labs(col="State") + labs(lty="Model") +
  xlim(0,30)
flu.sym.death.plot

#get distribution statistics
compile_results(flu.sym.death.model, B = 1000, times = c(15, 30))

















############
###### example of first event from emergency department visit
############

flu.emergency.fe <- flu.wide("EMERGENCY", flu.time_from_pos_flu, c("VIRTUAL" , "LAB" ,"OUTPATIENT" ,"URGENTCARE"))

table(flu.emergency.fe$first_event)

###find the best fitting distributions
# Define distributions
distributions.emergency <- list(
  dist1 = c("weibull", "exp", "gamma", "gengamma", "lnorm", "Gompertz"),
  dist2 = c("weibull", "exp", "gamma", "gengamma", "lnorm", "Gompertz"),
  dist3 = c("weibull", "exp", "gamma", "gengamma", "lnorm", "Gompertz")
)

# Initialize results list
aic_results.emergency <- list()

# Calculate total number of combinations
total_combinations <- length(distributions.emergency$dist1) * length(distributions.emergency$dist2) * length(distributions.emergency$dist3)

# Initialize iteration counter
iteration <- 0

for (dist1 in distributions.emergency$dist1) {
  for (dist2 in distributions.emergency$dist2) {
    for (dist3 in distributions.emergency$dist3) {
      iteration <- iteration + 1
      
      # Track progress
      cat("Fitting model", iteration, "of", total_combinations, "combinations...\n")
      
      # Fit the model
      fit.emergency <- tryCatch({
        flexsurvmix(Surv(time_clean, status) ~ 1,
                    event = first_event,
                    data = flu.emergency.fe, 
                    dists = c("exp", dist1, dist2, dist3),
                    method = "em", 
                    em.control = list(trace = 1, reltol = 1e-5),
                    optim.control = list(maxit = 1000),
                    inits = c()
        )
      }, error = function(e) {
        # Handle any errors during model fitting
        cat("Error fitting model", iteration, ": ", e$message, "\n")
        return(NULL)
      })
      
      if (!is.null(fit.emergency)) {
        # Try to compute mean_flexsurvmix and handle any errors
        mean_result <- tryCatch({
          mean_flexsurvmix(fit.emergency)
        }, error = function(e) {
          # Handle any errors during mean_flexsurvmix computation
          cat("Error computing mean_flexsurvmix for model", iteration, ": ", e$message, "\n")
          return(NULL)
        })
        
        if (!is.null(mean_result)) {
          # Extract AIC if mean_flexsurvmix is computed successfully
          aic.emergency <- fit.emergency$AIC
          
          # Store AIC in the list
          model_name <- paste(dist1, dist2, dist3, sep = "_")
          aic_results.emergency[[model_name]] <- aic.emergency
        }
      }
    }
  }
}

# Convert the list to a named vector for easier manipulation
aic_vector.emergency <- unlist(aic_results.emergency)

# Check if there are any results before finding the minimum AIC
if (length(aic_vector.emergency) > 0) {
  # Find the minimum AIC value
  min_aic.emergency <- min(aic_vector.emergency)
  
  # Find the name of the model with the minimum AIC
  best_model_name.emergency <- names(aic_vector.emergency)[which.min(aic_vector.emergency)]
  
  # Print the minimum AIC
  cat("The minimum AIC is", min_aic.emergency, "for the model with distributions:", best_model_name.emergency, "\n")
  
  # Find the smallest 5 AIC values
  num_results <- length(aic_vector.emergency)
  smallest_5_indices <- order(aic_vector.emergency)[1:min(num_results, 5)]
  
  smallest_5_values <- aic_vector.emergency[smallest_5_indices]
  
  # Print the smallest 5 AIC values
  cat("The smallest 5 AIC values are:\n")
  for (i in seq_along(smallest_5_values)) {
    model_name <- names(smallest_5_values)[i]
    cat("AIC for model with distributions:", model_name, "is", smallest_5_values[i], "\n")
  }
  
} else {
  cat("No valid models were fitted.\n")
}


###run the first event model
###

#run the model
flu.emergency.fe.model <- flexsurvmix(Surv(time_clean, status) ~ 1,
                                      event = first_event,
                                      data = flu.emergency.fe, 
                                      dists = c(CENS = "exp", DEATH = "gompertz", INPATIENT = "lnorm", VENTILATION = "lnorm"),
                                      method = "em", 
                                      em.control = list(trace = 1),
                                      optim.control = list(maxit = 1000),
                                      inits = c())
flu.emergency.fe.model

flu.emergency.fe.aj <- ajfit_flexsurvmix(flu.emergency.fe.model, startname="EMERGENCY", B = 100)
flu.emergency.fe.model.plot <- ggplot(flu.emergency.fe.aj, aes(x=time, y=val, col=state, lty=model)) +
  geom_line() + 
  xlab("Days after emergency visit") + ylab("Probability of event or worse") + 
  labs(col="State") + labs(lty="Model") +
  xlim(0,60)
flu.emergency.fe.model.plot

#find the probability at t = 15 with 1000 bootstrapped samples
p_flexsurvmix(flu.emergency.fe.model, t = c(15), B= 1000, startname = "EMERGENCY") %>% mutate_at(vars(val, lower, upper), list(~ round(., 3)))  %>% arrange(factor(state, levels = c("VIRTUAL", "OUTPATIENT", "URGENTCARE",  "EMERGENCY", "INPATIENT", "VENTILATION", "DEATH")))

#find the total probability with 1000 bootstrapped samples
probs_flexsurvmix(flu.emergency.fe.model, B = 1000) %>% mutate_at(vars(val, lower, upper), list(~ round(., 3)))  %>% arrange(factor(event, levels = c("VIRTUAL", "OUTPATIENT", "URGENTCARE",  "EMERGENCY", "INPATIENT", "VENTILATION", "DEATH")))

#find the median time to event with 1000 bootstrapped samples
quantile_flexsurvmix(flu.emergency.fe.model, B = 1000, probs = 0.5) %>% filter(event != "CENS") %>% mutate_at(vars(val, lower, upper), list(~ round(., 2)))  %>% arrange(factor(event, levels = c("VIRTUAL", "OUTPATIENT", "URGENTCARE",  "EMERGENCY", "INPATIENT", "VENTILATION", "DEATH")))

#find the 25th and 75th percentile time to event for IQR with 1000 bootstrapped samples
quantile_flexsurvmix(flu.emergency.fe.model, B = 1000, probs = c(0.25, 0.75)) %>% filter(event != "CENS") %>% mutate_at(vars(val, lower, upper), list(~ round(., 2)))  %>% arrange(p, factor(event, levels = c("VIRTUAL", "OUTPATIENT", "URGENTCARE",  "EMERGENCY", "INPATIENT", "VENTILATION", "DEATH")))

#find the mean time to event with 1000 bootstrapped samples
mean_flexsurvmix(flu.emergency.fe.model, B = 1000) %>% 
  mutate(model="Mixture", quantity="mean")

#######
### or worse analysis from emergency visit 
#######

#inpatient or worse

#make the dataset
flu.emergency.inpatient.ow <- or.worse.function(data = flu.time_from_pos_flu, time_from_pos_test_variable = time_from_pos_flu, base_event = "EMERGENCY", orworse_event = "INPATIENT", events_plus= c("INPATIENT", "VENTILATION", "DEATH"))

#find the best fitting distribution
best.dist.orworse(flu.emergency.inpatient.ow)

#run the model
flu.emergency.inpatient.ow.model <- flexsurvmix(Surv(time_clean, orworse.event) ~ 1,
                                                event = state,
                                                data = flu.emergency.inpatient.ow, 
                                                dists = c("INPATIENT -" = "exp", "INPATIENT +" = "lnorm"),
                                                method = "em", 
                                                em.control = list(trace = 1),
                                                optim.control = list(maxit = 1000),
                                                inits = c())
flu.emergency.inpatient.ow.model

flu.emergency.inpatient.ow.aj <- ajfit_flexsurvmix(flu.emergency.inpatient.ow.model, startname="EMERGENCY", B = 100)
flu.emergency.inpatient.ow.model.plot <- ggplot(flu.emergency.inpatient.ow.aj, aes(x=time, y=val, col=state, lty=model)) +
  geom_line() + 
  xlab("Days after emergency visit") + ylab("Probability of event or worse") + 
  labs(col="State") + labs(lty="Model") +
  xlim(0,60)
flu.emergency.inpatient.ow.model.plot

#get distribution statistics
compile_results(flu.emergency.inpatient.ow.model, B = 1000, times = c(15, 30))    



#ventilation or worse

#make the dataset
flu.emergency.ventilation.ow <- or.worse.function(data = flu.time_from_pos_flu, time_from_pos_test_variable = time_from_pos_flu, base_event = "EMERGENCY", orworse_event = "VENTILATION", events_plus= c("VENTILATION", "DEATH"))

#find the best fitting distribution
best.dist.orworse(flu.emergency.ventilation.ow)

#run the model
flu.emergency.ventilation.ow.model <- flexsurvmix(Surv(time_clean, orworse.event) ~ 1,
                                                  event = state,
                                                  data = flu.emergency.ventilation.ow, 
                                                  dists = c("VENTILATION -" = "exp", "VENTILATION +" = "gamma"),
                                                  method = "em", 
                                                  em.control = list(trace = 1),
                                                  optim.control = list(maxit = 1000),
                                                  inits = c())
flu.emergency.ventilation.ow.model

flu.emergency.ventilation.ow.aj <- ajfit_flexsurvmix(flu.emergency.ventilation.ow.model, startname="EMERGENCY", B = 100)
flu.emergency.ventilation.ow.model.plot <- ggplot(flu.emergency.ventilation.ow.aj, aes(x=time, y=val, col=state, lty=model)) +
  geom_line() + 
  xlab("Days after emergency visit") + ylab("Probability of event or worse") + 
  labs(col="State") + labs(lty="Model") +
  xlim(0,60)
flu.emergency.ventilation.ow.model.plot

#get distribution statistics
compile_results(flu.emergency.ventilation.ow.model, B = 1000, times = c(15, 30))  



#death

#make the dataset
flu.emergency.death.ow <- or.worse.function(data = flu.time_from_pos_flu, time_from_pos_test_variable = time_from_pos_flu, base_event = "EMERGENCY", orworse_event = "DEATH", events_plus= "DEATH")

#find the best fitting distribution
best.dist.orworse(flu.emergency.death.ow)

#run the model
flu.emergency.death.ow.model <- flexsurvmix(Surv(time_clean, orworse.event) ~ 1,
                                            event = state,
                                            data = flu.emergency.death.ow, 
                                            dists = c("DEATH -" = "exp", "DEATH +" = "gompertz"),
                                            method = "em", 
                                            em.control = list(trace = 1),
                                            optim.control = list(maxit = 1000),
                                            inits = c())
flu.emergency.death.ow.model

flu.emergency.death.ow.aj <- ajfit_flexsurvmix(flu.emergency.death.ow.model, startname="EMERGENCY", B = 100)
flu.emergency.death.ow.model.plot <- ggplot(flu.emergency.death.ow.aj, aes(x=time, y=val, col=state, lty=model)) +
  geom_line() + 
  xlab("Days after emergency visit") + ylab("Probability of event or worse") + 
  labs(col="State") + labs(lty="Model") +
  xlim(0,60)
flu.emergency.death.ow.model.plot

#get distribution statistics
compile_results(flu.emergency.death.ow.model, B = 1000, times = c(15, 30))  




##############
##############
####### looking at covariates
##############
##############


#####Flu as an example


### first some functions for speeding up and cleaning covariate model output
createlevels <- function(data){
data1 <- data
data1$age_group <- cut(data$age, c(0, 17, 49, 59, 69, 79, 89, Inf), 
                       c("0-17", "18-49", "50-59", "60-69", "70-79", "80-89", "90+"), include.lowest = T)
data1$GENDER <- factor(data$GENDER)
data1$COVID_vac <- ifelse(data$covid_ct == 0, "0", 
                          ifelse(data$covid_ct >= 3, "3+", "<3"))
data1$RACE_ETH <- factor(data$RACE_ETH)
data1$COVID_vac <- factor(data1$COVID_vac)
data1$flu_vac <- factor(data$flu_vac)
data1$rsv_vac <- factor(data$rsv_vac)
data1$NDI_group <- cut(data$ndi, c(-Inf, -1, 0, 1, Inf), 
                       c("<-1", "-1 - 0", "0 - 1", ">1"), include.lowest = T)
data1$cw_group <- cut(data$Charlson_Wt, c(0, 0.9, 2.9, 5, Inf), 
                      c("0", "1-2", "3-5", "6+"), include.lowest = T)
return(data1)
}

covariate_model_generator <- function(data, rate_covariate, prob_covariate, dists) {
  # Specify the model formula
  formula <- as.formula(paste("Surv(time_clean, orworse.event) ~", rate_covariate))
  
  
  # Run the flexsurvmix model
  model <- flexsurvmix(formula, 
                       event = state, 
                       data = data, 
                       dists = dists, 
                       pformula = as.formula(paste("~", prob_covariate)), 
                       method = "em", 
                       em.control = list(trace = 1), 
                       optim.control = list(maxit = 1000), 
                       inits = c())
  
  # Return the model object
  return(model)
}

covariate_prob <- function(model, data, covariate, fil_event) {
  new.data <- expand.grid(setNames(list(levels(data[[covariate]])), covariate))
  probs <- probs_flexsurvmix(model, newdata = new.data, B = 1000)
  results <- probs %>% mutate_at(vars(val, lower, upper), list(~ round(., 3))) %>% filter(event == paste(fil_event, "+"))
  return(results)
}

covariate_rate_median <- function(model, data, covariate, fil_event) {
  new.data <- expand.grid(setNames(list(levels(data[[covariate]])), covariate))
  median <- quantile_flexsurvmix(model, newdata = new.data, B = 1000, p =0.5)  %>% filter(event == paste(fil_event, "+"))
  results <- median %>% mutate_at(vars(val, lower, upper), list(~ round(., 2)))
  results2 <- model$res %>% filter(component == paste(fil_event, "+")) %>% filter(!(str_detect(terms, 'prob'))) %>% mutate_at(vars(est), list(~ round(., 4)))
  return(list(results, results2[,1:4]))
}


#virtual plus

flu.sym.virtual <- createlevels(flu.sym.virtual)

#age

flu.sym.virtual.age.prob.model <- covariate_model_generator(flu.sym.virtual, rate_covariate = 1, prob_covariate = "age_group", dists = c("VIRTUAL -" = "exp", "VIRTUAL +" = "lnorm"))
flu.sym.virtual.age.prob.rate.model <- covariate_model_generator(flu.sym.virtual, rate_covariate = "age_group", prob_covariate = "age_group", dists = c("VIRTUAL -" = "exp", "VIRTUAL +" = "lnorm"))

#gender

flu.sym.virtual.gender.prob.model <- covariate_model_generator(flu.sym.virtual, rate_covariate = 1, prob_covariate = "GENDER", dists = c("VIRTUAL -" = "exp", "VIRTUAL +" = "lnorm"))
flu.sym.virtual.gender.prob.rate.model <- covariate_model_generator(flu.sym.virtual, rate_covariate = "GENDER", prob_covariate = "GENDER", dists = c("VIRTUAL -" = "exp", "VIRTUAL +" = "lnorm"))

#race/ethnicity

flu.sym.virtual.race.prob.model <- covariate_model_generator(flu.sym.virtual, rate_covariate = 1, prob_covariate = "RACE_ETH", dists = c("VIRTUAL -" = "exp", "VIRTUAL +" = "lnorm"))
flu.sym.virtual.race.prob.rate.model <- covariate_model_generator(flu.sym.virtual, rate_covariate = "RACE_ETH", prob_covariate = "RACE_ETH", dists = c("VIRTUAL -" = "exp", "VIRTUAL +" = "lnorm"))
flu.sym.virtual.race.prob.model

#vaccination

flu.sym.virtual.vax.prob.model <- covariate_model_generator(flu.sym.virtual, rate_covariate = 1, prob_covariate = "flu_vac", dists = c("VIRTUAL -" = "exp", "VIRTUAL +" = "lnorm"))
flu.sym.virtual.vax.prob.rate.model <- covariate_model_generator(flu.sym.virtual, rate_covariate = "flu_vac", prob_covariate = "flu_vac", dists = c("VIRTUAL -" = "exp", "VIRTUAL +" = "lnorm"))

#ndi
flu.sym.virtual.ndi.clean <- flu.sym.virtual %>% filter(!is.na(NDI_group))
flu.sym.virtual.ndi.prob.model <- covariate_model_generator(flu.sym.virtual.ndi.clean, rate_covariate = 1, prob_covariate = "NDI_group", dists = c("VIRTUAL -" = "exp", "VIRTUAL +" = "lnorm"))
flu.sym.virtual.ndi.prob.rate.model <- covariate_model_generator(flu.sym.virtual.ndi.clean, rate_covariate = "NDI_group", prob_covariate = "NDI_group", dists = c("VIRTUAL -" = "exp", "VIRTUAL +" = "lnorm"))

#charlson wt

flu.sym.virtual.cw.prob.model <- covariate_model_generator(flu.sym.virtual, rate_covariate = 1, prob_covariate = "cw_group", dists = c("VIRTUAL -" = "exp", "VIRTUAL +" = "lnorm"))
flu.sym.virtual.cw.prob.rate.model <- covariate_model_generator(flu.sym.virtual, rate_covariate = "cw_group", prob_covariate = "cw_group", dists = c("VIRTUAL -" = "exp", "VIRTUAL +" = "lnorm"))

#get probs
covariate_prob(model = flu.sym.virtual.age.prob.model, data = flu.sym.virtual, covariate = "age_group", fil_event = "VIRTUAL")
covariate_prob(model = flu.sym.virtual.gender.prob.model, data = flu.sym.virtual, covariate = "GENDER", fil_event = "VIRTUAL")
covariate_prob(model = flu.sym.virtual.race.prob.model, data = flu.sym.virtual, covariate = "RACE_ETH", fil_event = "VIRTUAL")
covariate_prob(model = flu.sym.virtual.vax.prob.model, data = flu.sym.virtual, covariate = "flu_vac", fil_event = "VIRTUAL")
covariate_prob(model = flu.sym.virtual.ndi.prob.model, data = flu.sym.virtual, covariate = "NDI_group", fil_event = "VIRTUAL")
covariate_prob(model = flu.sym.virtual.cw.prob.model, data = flu.sym.virtual, covariate = "cw_group", fil_event = "VIRTUAL")

covariate_rate_median(model = flu.sym.virtual.age.prob.rate.model, data = flu.sym.virtual, covariate = "age_group", fil_event = "VIRTUAL")
covariate_rate_median(model = flu.sym.virtual.gender.prob.rate.model, data = flu.sym.virtual, covariate = "GENDER", fil_event = "VIRTUAL")
covariate_rate_median(model = flu.sym.virtual.race.prob.rate.model, data = flu.sym.virtual, covariate = "RACE_ETH", fil_event = "VIRTUAL")
covariate_rate_median(model = flu.sym.virtual.vax.prob.rate.model, data = flu.sym.virtual, covariate = "flu_vac", fil_event = "VIRTUAL")
covariate_rate_median(model = flu.sym.virtual.ndi.prob.rate.model, data = flu.sym.virtual, covariate = "NDI_group", fil_event = "VIRTUAL")
covariate_rate_median(model = flu.sym.virtual.cw.prob.rate.model, data = flu.sym.virtual, covariate = "cw_group", fil_event = "VIRTUAL")



#outpatient plus

flu.sym.outpatient <- createlevels(flu.sym.outpatient)

#age

flu.sym.outpatient.age.prob.model <- covariate_model_generator(flu.sym.outpatient, rate_covariate = 1, prob_covariate = "age_group", dists = c("OUTPATIENT -" = "exp", "OUTPATIENT +" = "lnorm"))
flu.sym.outpatient.age.prob.rate.model <- covariate_model_generator(flu.sym.outpatient, rate_covariate = "age_group", prob_covariate = "age_group", dists = c("OUTPATIENT -" = "exp", "OUTPATIENT +" = "lnorm"))

#gender

flu.sym.outpatient.gender.prob.model <- covariate_model_generator(flu.sym.outpatient, rate_covariate = 1, prob_covariate = "GENDER", dists = c("OUTPATIENT -" = "exp", "OUTPATIENT +" = "lnorm"))
flu.sym.outpatient.gender.prob.rate.model <- covariate_model_generator(flu.sym.outpatient, rate_covariate = "GENDER", prob_covariate = "GENDER", dists = c("OUTPATIENT -" = "exp", "OUTPATIENT +" = "lnorm"))

#race/ethnicity
table(flu.sym.outpatient$RACE_ETH, flu.sym.outpatient$orworse.event)
flu.sym.outpatient.race.prob.model <- covariate_model_generator(flu.sym.outpatient, rate_covariate = 1, prob_covariate = "RACE_ETH", dists = c("OUTPATIENT -" = "exp", "OUTPATIENT +" = "lnorm"))
flu.sym.outpatient.race.prob.rate.model <- covariate_model_generator(flu.sym.outpatient, rate_covariate = "RACE_ETH", prob_covariate = "RACE_ETH", dists = c("OUTPATIENT -" = "exp", "OUTPATIENT +" = "lnorm"))

#vaccination

flu.sym.outpatient.vax.prob.model <- covariate_model_generator(flu.sym.outpatient, rate_covariate = 1, prob_covariate = "flu_vac", dists = c("OUTPATIENT -" = "exp", "OUTPATIENT +" = "lnorm"))
flu.sym.outpatient.vax.prob.rate.model <- covariate_model_generator(flu.sym.outpatient, rate_covariate = "flu_vac", prob_covariate = "flu_vac", dists = c("OUTPATIENT -" = "exp", "OUTPATIENT +" = "lnorm"))

#ndi
flu.sym.outpatient.ndi.clean <- flu.sym.outpatient %>% filter(!is.na(NDI_group))
flu.sym.outpatient.ndi.prob.model <- covariate_model_generator(flu.sym.outpatient.ndi.clean, rate_covariate = 1, prob_covariate = "NDI_group", dists = c("OUTPATIENT -" = "exp", "OUTPATIENT +" = "lnorm"))
flu.sym.outpatient.ndi.prob.rate.model <- covariate_model_generator(flu.sym.outpatient.ndi.clean, rate_covariate = "NDI_group", prob_covariate = "NDI_group", dists = c("OUTPATIENT -" = "exp", "OUTPATIENT +" = "lnorm"))

#charlson wt

flu.sym.outpatient.cw.prob.model <- covariate_model_generator(flu.sym.outpatient, rate_covariate = 1, prob_covariate = "cw_group", dists = c("OUTPATIENT -" = "exp", "OUTPATIENT +" = "lnorm"))
flu.sym.outpatient.cw.prob.rate.model <- covariate_model_generator(flu.sym.outpatient, rate_covariate = "cw_group", prob_covariate = "cw_group", dists = c("OUTPATIENT -" = "exp", "OUTPATIENT +" = "lnorm"))

#get probs
covariate_prob(model = flu.sym.outpatient.age.prob.model, data = flu.sym.outpatient, covariate = "age_group", fil_event = "OUTPATIENT")
covariate_prob(model = flu.sym.outpatient.gender.prob.model, data = flu.sym.outpatient, covariate = "GENDER", fil_event = "OUTPATIENT")
covariate_prob(model = flu.sym.outpatient.race.prob.model, data = flu.sym.outpatient, covariate = "RACE_ETH", fil_event = "OUTPATIENT")
covariate_prob(model = flu.sym.outpatient.vax.prob.model, data = flu.sym.outpatient, covariate = "flu_vac", fil_event = "OUTPATIENT")
covariate_prob(model = flu.sym.outpatient.ndi.prob.model, data = flu.sym.outpatient, covariate = "NDI_group", fil_event = "OUTPATIENT")
covariate_prob(model = flu.sym.outpatient.cw.prob.model, data = flu.sym.outpatient, covariate = "cw_group", fil_event = "OUTPATIENT")

#get rate terms and median
covariate_rate_median(model = flu.sym.outpatient.age.prob.rate.model, data = flu.sym.outpatient, covariate = "age_group", fil_event = "OUTPATIENT")
covariate_rate_median(model = flu.sym.outpatient.gender.prob.rate.model, data = flu.sym.outpatient, covariate = "GENDER", fil_event = "OUTPATIENT")
covariate_rate_median(model = flu.sym.outpatient.race.prob.rate.model, data = flu.sym.outpatient, covariate = "RACE_ETH", fil_event = "OUTPATIENT")
covariate_rate_median(model = flu.sym.outpatient.vax.prob.rate.model, data = flu.sym.outpatient, covariate = "flu_vac", fil_event = "OUTPATIENT")
covariate_rate_median(model = flu.sym.outpatient.ndi.prob.rate.model, data = flu.sym.outpatient, covariate = "NDI_group", fil_event = "OUTPATIENT")
covariate_rate_median(model = flu.sym.outpatient.cw.prob.rate.model, data = flu.sym.outpatient, covariate = "cw_group", fil_event = "OUTPATIENT")


#urgentcare plus

flu.sym.uc <- createlevels(flu.sym.uc)

#age

flu.sym.uc.age.prob.model <- covariate_model_generator(flu.sym.uc, rate_covariate = 1, prob_covariate = "age_group", dists = c("URGENTCARE -" = "exp", "URGENTCARE +" = "lnorm"))
flu.sym.uc.age.prob.rate.model <- covariate_model_generator(flu.sym.uc, rate_covariate = "age_group", prob_covariate = "age_group", dists = c("URGENTCARE -" = "exp", "URGENTCARE +" = "lnorm"))

#gender

flu.sym.uc.gender.prob.model <- covariate_model_generator(flu.sym.uc, rate_covariate = 1, prob_covariate = "GENDER", dists = c("URGENTCARE -" = "exp", "URGENTCARE +" = "lnorm"))
flu.sym.uc.gender.prob.rate.model <- covariate_model_generator(flu.sym.uc, rate_covariate = "GENDER", prob_covariate = "GENDER", dists = c("URGENTCARE -" = "exp", "URGENTCARE +" = "lnorm"))

#race/ethnicity

flu.sym.uc.race.prob.model <- covariate_model_generator(flu.sym.uc, rate_covariate = 1, prob_covariate = "RACE_ETH", dists = c("URGENTCARE -" = "exp", "URGENTCARE +" = "lnorm"))
flu.sym.uc.race.prob.rate.model <- covariate_model_generator(flu.sym.uc, rate_covariate = "RACE_ETH", prob_covariate = "RACE_ETH", dists = c("URGENTCARE -" = "exp", "URGENTCARE +" = "lnorm"))

#vaccination

flu.sym.uc.vax.prob.model <- covariate_model_generator(flu.sym.uc, rate_covariate = 1, prob_covariate = "flu_vac", dists = c("URGENTCARE -" = "exp", "URGENTCARE +" = "lnorm"))
flu.sym.uc.vax.prob.rate.model <- covariate_model_generator(flu.sym.uc, rate_covariate = "flu_vac", prob_covariate = "flu_vac", dists = c("URGENTCARE -" = "exp", "URGENTCARE +" = "lnorm"))

#ndi
flu.sym.uc.ndi.clean <- flu.sym.uc %>% filter(!is.na(NDI_group))
flu.sym.uc.ndi.prob.model <- covariate_model_generator(flu.sym.uc.ndi.clean, rate_covariate = 1, prob_covariate = "NDI_group", dists = c("URGENTCARE -" = "exp", "URGENTCARE +" = "lnorm"))
flu.sym.uc.ndi.prob.rate.model <- covariate_model_generator(flu.sym.uc.ndi.clean, rate_covariate = "NDI_group", prob_covariate = "NDI_group", dists = c("URGENTCARE -" = "exp", "URGENTCARE +" = "lnorm"))

#charlson wt

flu.sym.uc.cw.prob.model <- covariate_model_generator(flu.sym.uc, rate_covariate = 1, prob_covariate = "cw_group", dists = c("URGENTCARE -" = "exp", "URGENTCARE +" = "lnorm"))
flu.sym.uc.cw.prob.rate.model <- covariate_model_generator(flu.sym.uc, rate_covariate = "cw_group", prob_covariate = "cw_group", dists = c("URGENTCARE -" = "exp", "URGENTCARE +" = "lnorm"))

#get probs
covariate_prob(model = flu.sym.uc.age.prob.model, data = flu.sym.uc, covariate = "age_group", fil_event = "URGENTCARE")
covariate_prob(model = flu.sym.uc.gender.prob.model, data = flu.sym.uc, covariate = "GENDER", fil_event = "URGENTCARE")
covariate_prob(model = flu.sym.uc.race.prob.model, data = flu.sym.uc, covariate = "RACE_ETH", fil_event = "URGENTCARE")
covariate_prob(model = flu.sym.uc.vax.prob.model, data = flu.sym.uc, covariate = "flu_vac", fil_event = "URGENTCARE")
covariate_prob(model = flu.sym.uc.ndi.prob.model, data = flu.sym.uc, covariate = "NDI_group", fil_event = "URGENTCARE")
covariate_prob(model = flu.sym.uc.cw.prob.model, data = flu.sym.uc, covariate = "cw_group", fil_event = "URGENTCARE")

covariate_rate_median(model = flu.sym.uc.age.prob.rate.model, data = flu.sym.uc, covariate = "age_group", fil_event = "URGENTCARE")
covariate_rate_median(model = flu.sym.uc.gender.prob.rate.model, data = flu.sym.uc, covariate = "GENDER", fil_event = "URGENTCARE")
covariate_rate_median(model = flu.sym.uc.race.prob.rate.model, data = flu.sym.uc, covariate = "RACE_ETH", fil_event = "URGENTCARE")
covariate_rate_median(model = flu.sym.uc.vax.prob.rate.model, data = flu.sym.uc, covariate = "flu_vac", fil_event = "URGENTCARE")
covariate_rate_median(model = flu.sym.uc.ndi.prob.rate.model, data = flu.sym.uc, covariate = "NDI_group", fil_event = "URGENTCARE")
covariate_rate_median(model = flu.sym.uc.cw.prob.rate.model, data = flu.sym.uc, covariate = "cw_group", fil_event = "URGENTCARE")

#emergency plus

flu.sym.emergency <- createlevels(flu.sym.emerg)

#age

flu.sym.emergency.age.prob.model <- covariate_model_generator(flu.sym.emergency, rate_covariate = 1, prob_covariate = "age_group", dists = c("EMERGENCY -" = "exp", "EMERGENCY +" = "gengamma"))
flu.sym.emergency.age.prob.rate.model <- covariate_model_generator(flu.sym.emergency, rate_covariate = "age_group", prob_covariate = "age_group", dists = c("EMERGENCY -" = "exp", "EMERGENCY +" = "gengamma"))

#gender

flu.sym.emergency.gender.prob.model <- covariate_model_generator(flu.sym.emergency, rate_covariate = 1, prob_covariate = "GENDER", dists = c("EMERGENCY -" = "exp", "EMERGENCY +" = "gengamma"))
flu.sym.emergency.gender.prob.rate.model <- covariate_model_generator(flu.sym.emergency, rate_covariate = "GENDER", prob_covariate = "GENDER", dists = c("EMERGENCY -" = "exp", "EMERGENCY +" = "gengamma"))

#race/ethnicity

flu.sym.emergency.race.prob.model <- covariate_model_generator(flu.sym.emergency, rate_covariate = 1, prob_covariate = "RACE_ETH", dists = c("EMERGENCY -" = "exp", "EMERGENCY +" = "gengamma"))
flu.sym.emergency.race.prob.rate.model <- covariate_model_generator(flu.sym.emergency, rate_covariate = "RACE_ETH", prob_covariate = "RACE_ETH", dists = c("EMERGENCY -" = "exp", "EMERGENCY +" = "gengamma"))

#vaccination

flu.sym.emergency.vax.prob.model <- covariate_model_generator(flu.sym.emergency, rate_covariate = 1, prob_covariate = "flu_vac", dists = c("EMERGENCY -" = "exp", "EMERGENCY +" = "gengamma"))
flu.sym.emergency.vax.prob.rate.model <- covariate_model_generator(flu.sym.emergency, rate_covariate = "flu_vac", prob_covariate = "flu_vac", dists = c("EMERGENCY -" = "exp", "EMERGENCY +" = "gengamma"))

#ndi
flu.sym.emergency.ndi.clean <- flu.sym.emergency %>% filter(!is.na(NDI_group))
flu.sym.emergency.ndi.prob.model <- covariate_model_generator(flu.sym.emergency.ndi.clean, rate_covariate = 1, prob_covariate = "NDI_group", dists = c("EMERGENCY -" = "exp", "EMERGENCY +" = "gamma"))
flu.sym.emergency.ndi.prob.rate.model <- covariate_model_generator(flu.sym.emergency.ndi.clean, rate_covariate = "NDI_group", prob_covariate = "NDI_group", dists = c("EMERGENCY -" = "exp", "EMERGENCY +" = "gamma"))

#charlson wt

flu.sym.emergency.cw.prob.model <- covariate_model_generator(flu.sym.emergency, rate_covariate = 1, prob_covariate = "cw_group", dists = c("EMERGENCY -" = "exp", "EMERGENCY +" = "gengamma"))
flu.sym.emergency.cw.prob.rate.model <- covariate_model_generator(flu.sym.emergency, rate_covariate = "cw_group", prob_covariate = "cw_group", dists = c("EMERGENCY -" = "exp", "EMERGENCY +" = "gengamma"))

#get probs
covariate_prob(model = flu.sym.emergency.age.prob.model, data = flu.sym.emergency, covariate = "age_group", fil_event = "EMERGENCY")
covariate_prob(model = flu.sym.emergency.gender.prob.model, data = flu.sym.emergency, covariate = "GENDER", fil_event = "EMERGENCY")
covariate_prob(model = flu.sym.emergency.race.prob.model, data = flu.sym.emergency, covariate = "RACE_ETH", fil_event = "EMERGENCY")
covariate_prob(model = flu.sym.emergency.vax.prob.model, data = flu.sym.emergency, covariate = "flu_vac", fil_event = "EMERGENCY")
covariate_prob(model = flu.sym.emergency.ndi.prob.model, data = flu.sym.emergency, covariate = "NDI_group", fil_event = "EMERGENCY")
covariate_prob(model = flu.sym.emergency.cw.prob.model, data = flu.sym.emergency, covariate = "cw_group", fil_event = "EMERGENCY")


covariate_rate_median(model = flu.sym.emergency.age.prob.rate.model, data = flu.sym.emergency, covariate = "age_group", fil_event = "EMERGENCY")
covariate_rate_median(model = flu.sym.emergency.gender.prob.rate.model, data = flu.sym.emergency, covariate = "GENDER", fil_event = "EMERGENCY")
covariate_rate_median(model = flu.sym.emergency.race.prob.rate.model, data = flu.sym.emergency, covariate = "RACE_ETH", fil_event = "EMERGENCY")
covariate_rate_median(model = flu.sym.emergency.vax.prob.rate.model, data = flu.sym.emergency, covariate = "flu_vac", fil_event = "EMERGENCY")
covariate_rate_median(model = flu.sym.emergency.ndi.prob.rate.model, data = flu.sym.emergency, covariate = "NDI_group", fil_event = "EMERGENCY")
covariate_rate_median(model = flu.sym.emergency.cw.prob.rate.model, data = flu.sym.emergency, covariate = "cw_group", fil_event = "EMERGENCY")


#inpatient plus

flu.sym.inpatient <- createlevels(flu.sym.inpatient)

#age

flu.sym.inpatient.age.prob.model <- covariate_model_generator(flu.sym.inpatient, rate_covariate = 1, prob_covariate = "age_group", dists = c("INPATIENT -" = "exp", "INPATIENT +" = "gengamma"))
flu.sym.inpatient.age.prob.rate.model <- covariate_model_generator(flu.sym.inpatient, rate_covariate = "age_group", prob_covariate = "age_group", dists = c("INPATIENT -" = "exp", "INPATIENT +" = "gengamma"))

#gender

flu.sym.inpatient.gender.prob.model <- covariate_model_generator(flu.sym.inpatient, rate_covariate = 1, prob_covariate = "GENDER", dists = c("INPATIENT -" = "exp", "INPATIENT +" = "gengamma"))
flu.sym.inpatient.gender.prob.rate.model <- covariate_model_generator(flu.sym.inpatient, rate_covariate = "GENDER", prob_covariate = "GENDER", dists = c("INPATIENT -" = "exp", "INPATIENT +" = "gengamma"))

#race/ethnicity

flu.sym.inpatient.race.prob.model <- covariate_model_generator(flu.sym.inpatient, rate_covariate = 1, prob_covariate = "RACE_ETH", dists = c("INPATIENT -" = "exp", "INPATIENT +" = "gengamma"))
flu.sym.inpatient.race.prob.rate.model <- covariate_model_generator(flu.sym.inpatient, rate_covariate = "RACE_ETH", prob_covariate = "RACE_ETH", dists = c("INPATIENT -" = "exp", "INPATIENT +" = "gengamma"))

#vaccination

flu.sym.inpatient.vax.prob.model <- covariate_model_generator(flu.sym.inpatient, rate_covariate = 1, prob_covariate = "flu_vac", dists = c("INPATIENT -" = "exp", "INPATIENT +" = "gengamma"))
flu.sym.inpatient.vax.prob.rate.model <- covariate_model_generator(flu.sym.inpatient, rate_covariate = "flu_vac", prob_covariate = "flu_vac", dists = c("INPATIENT -" = "exp", "INPATIENT +" = "gengamma"))

#ndi
flu.sym.inpatient.ndi.clean <- flu.sym.inpatient %>% filter(!is.na(NDI_group))
flu.sym.inpatient.ndi.prob.model <- covariate_model_generator(flu.sym.inpatient.ndi.clean, rate_covariate = 1, prob_covariate = "NDI_group", dists = c("INPATIENT -" = "exp", "INPATIENT +" = "gengamma"))
flu.sym.inpatient.ndi.prob.rate.model <- covariate_model_generator(flu.sym.inpatient.ndi.clean, rate_covariate = "NDI_group", prob_covariate = "NDI_group", dists = c("INPATIENT -" = "exp", "INPATIENT +" = "gengamma"))

#charlson wt

flu.sym.inpatient.cw.prob.model <- covariate_model_generator(flu.sym.inpatient, rate_covariate = 1, prob_covariate = "cw_group", dists = c("INPATIENT -" = "exp", "INPATIENT +" = "gengamma"))
flu.sym.inpatient.cw.prob.rate.model <- covariate_model_generator(flu.sym.inpatient, rate_covariate = "cw_group", prob_covariate = "cw_group", dists = c("INPATIENT -" = "exp", "INPATIENT +" = "gengamma"))

#get probs
covariate_prob(model = flu.sym.inpatient.age.prob.model, data = flu.sym.inpatient, covariate = "age_group", fil_event = "INPATIENT")
covariate_prob(model = flu.sym.inpatient.gender.prob.model, data = flu.sym.inpatient, covariate = "GENDER", fil_event = "INPATIENT")
covariate_prob(model = flu.sym.inpatient.race.prob.model, data = flu.sym.inpatient, covariate = "RACE_ETH", fil_event = "INPATIENT")
covariate_prob(model = flu.sym.inpatient.vax.prob.model, data = flu.sym.inpatient, covariate = "flu_vac", fil_event = "INPATIENT")
covariate_prob(model = flu.sym.inpatient.ndi.prob.model, data = flu.sym.inpatient, covariate = "NDI_group", fil_event = "INPATIENT")
covariate_prob(model = flu.sym.inpatient.cw.prob.model, data = flu.sym.inpatient, covariate = "cw_group", fil_event = "INPATIENT")

#get rate terms and median
covariate_rate_median(model = flu.sym.inpatient.age.prob.rate.model, data = flu.sym.inpatient, covariate = "age_group", fil_event = "INPATIENT")
covariate_rate_median(model = flu.sym.inpatient.gender.prob.rate.model, data = flu.sym.inpatient, covariate = "GENDER", fil_event = "INPATIENT")
covariate_rate_median(model = flu.sym.inpatient.race.prob.rate.model, data = flu.sym.inpatient, covariate = "RACE_ETH", fil_event = "INPATIENT")
covariate_rate_median(model = flu.sym.inpatient.vax.prob.rate.model, data = flu.sym.inpatient, covariate = "flu_vac", fil_event = "INPATIENT")
covariate_rate_median(model = flu.sym.inpatient.ndi.prob.rate.model, data = flu.sym.inpatient, covariate = "NDI_group", fil_event = "INPATIENT")
covariate_rate_median(model = flu.sym.inpatient.cw.prob.rate.model, data = flu.sym.inpatient, covariate = "cw_group", fil_event = "INPATIENT")

#ventilation plus

flu.sym.ventilation <- createlevels(flu.sym.ventilation)

#age

flu.sym.ventilation.age.prob.model <- covariate_model_generator(flu.sym.ventilation, rate_covariate = 1, prob_covariate = "age_group", dists = c("VENTILATION -" = "exp", "VENTILATION +" = "weibull"))
flu.sym.ventilation.age.prob.rate.model <- covariate_model_generator(flu.sym.ventilation, rate_covariate = "age_group", prob_covariate = "age_group", dists = c("VENTILATION -" = "exp", "VENTILATION +" = "exp"))

#gender

flu.sym.ventilation.gender.prob.model <- covariate_model_generator(flu.sym.ventilation, rate_covariate = 1, prob_covariate = "GENDER", dists = c("VENTILATION -" = "exp", "VENTILATION +" = "weibull"))
flu.sym.ventilation.gender.prob.rate.model <- covariate_model_generator(flu.sym.ventilation, rate_covariate = "GENDER", prob_covariate = "GENDER", dists = c("VENTILATION -" = "exp", "VENTILATION +" = "exp"))

#race/ethnicity
table(flu.sym.ventilation$RACE_ETH, flu.sym.ventilation$orworse.event)
flu.sym.ventilation.race.clean <- flu.sym.ventilation %>% filter(RACE_ETH %in% c("Asian", "Black", "Hispanic", "Pacific Islander", "White"))
flu.sym.ventilation.race.clean$RACE_ETH <- factor(flu.sym.ventilation.race.clean$RACE_ETH)
flu.sym.ventilation.race.prob.model <- covariate_model_generator(flu.sym.ventilation.race.clean, rate_covariate = 1, prob_covariate = "RACE_ETH", dists = c("VENTILATION -" = "exp", "VENTILATION +" = "weibull"))
flu.sym.ventilation.race.prob.model
flu.sym.ventilation.race.prob.rate.model <- covariate_model_generator(flu.sym.ventilation.race.clean, rate_covariate = "RACE_ETH", prob_covariate = "RACE_ETH", dists = c("VENTILATION -" = "exp", "VENTILATION +" = "weibull"))

#vaccination

flu.sym.ventilation.vax.prob.model <- covariate_model_generator(flu.sym.ventilation, rate_covariate = 1, prob_covariate = "flu_vac", dists = c("VENTILATION -" = "exp", "VENTILATION +" = "weibull"))
flu.sym.ventilation.vax.prob.rate.model <- covariate_model_generator(flu.sym.ventilation, rate_covariate = "flu_vac", prob_covariate = "flu_vac", dists = c("VENTILATION -" = "exp", "VENTILATION +" = "weibull"))

#ndi
flu.sym.ventilation.ndi.clean <- flu.sym.ventilation %>% filter(!is.na(NDI_group))
flu.sym.ventilation.ndi.prob.model <- covariate_model_generator(flu.sym.ventilation.ndi.clean, rate_covariate = 1, prob_covariate = "NDI_group", dists = c("VENTILATION -" = "exp", "VENTILATION +" = "weibull"))
flu.sym.ventilation.ndi.prob.rate.model <- covariate_model_generator(flu.sym.ventilation.ndi.clean, rate_covariate = "NDI_group", prob_covariate = "NDI_group", dists = c("VENTILATION -" = "exp", "VENTILATION +" = "exp"))

#charlson wt

flu.sym.ventilation.cw.prob.model <- covariate_model_generator(flu.sym.ventilation, rate_covariate = 1, prob_covariate = "cw_group", dists = c("VENTILATION -" = "exp", "VENTILATION +" = "weibull"))
flu.sym.ventilation.cw.prob.rate.model <- covariate_model_generator(flu.sym.ventilation, rate_covariate = "cw_group", prob_covariate = "cw_group", dists = c("VENTILATION -" = "exp", "VENTILATION +" = "weibull"))

#get probs
covariate_prob(model = flu.sym.ventilation.age.prob.model, data = flu.sym.ventilation, covariate = "age_group", fil_event = "VENTILATION")
covariate_prob(model = flu.sym.ventilation.gender.prob.model, data = flu.sym.ventilation, covariate = "GENDER", fil_event = "VENTILATION")
covariate_prob(model = flu.sym.ventilation.race.prob.model, data = flu.sym.ventilation.race.clean, covariate = "RACE_ETH", fil_event = "VENTILATION")
covariate_prob(model = flu.sym.ventilation.vax.prob.model, data = flu.sym.ventilation, covariate = "flu_vac", fil_event = "VENTILATION")
covariate_prob(model = flu.sym.ventilation.ndi.prob.model, data = flu.sym.ventilation, covariate = "NDI_group", fil_event = "VENTILATION")
covariate_prob(model = flu.sym.ventilation.cw.prob.model, data = flu.sym.ventilation, covariate = "cw_group", fil_event = "VENTILATION")

covariate_rate_median(model = flu.sym.ventilation.age.prob.rate.model, data = flu.sym.ventilation, covariate = "age_group", fil_event = "VENTILATION")
covariate_rate_median(model = flu.sym.ventilation.gender.prob.rate.model, data = flu.sym.ventilation, covariate = "GENDER", fil_event = "VENTILATION")
covariate_rate_median(model = flu.sym.ventilation.race.prob.rate.model, data = flu.sym.ventilation, covariate = "RACE_ETH", fil_event = "VENTILATION")
covariate_rate_median(model = flu.sym.ventilation.vax.prob.rate.model, data = flu.sym.ventilation, covariate = "flu_vac", fil_event = "VENTILATION")
covariate_rate_median(model = flu.sym.ventilation.ndi.prob.rate.model, data = flu.sym.ventilation, covariate = "NDI_group", fil_event = "VENTILATION")
covariate_rate_median(model = flu.sym.ventilation.cw.prob.rate.model, data = flu.sym.ventilation, covariate = "cw_group", fil_event = "VENTILATION")


#death

flu.sym.death <- createlevels(flu.sym.death)

#age

flu.sym.death.age.prob.model <- covariate_model_generator(flu.sym.death, rate_covariate = 1, prob_covariate = "age_group", dists = c("DEATH -" = "exp", "DEATH +" = "weibull"))
flu.sym.death.age.prob.rate.model <- covariate_model_generator(flu.sym.death, rate_covariate = "age_group", prob_covariate = "age_group", dists = c("DEATH -" = "exp", "DEATH +" = "weibull"))

#gender

flu.sym.death.gender.prob.model <- covariate_model_generator(flu.sym.death, rate_covariate = 1, prob_covariate = "GENDER", dists = c("DEATH -" = "exp", "DEATH +" = "weibull"))
flu.sym.death.gender.prob.rate.model <- covariate_model_generator(flu.sym.death, rate_covariate = "GENDER", prob_covariate = "GENDER", dists = c("DEATH -" = "exp", "DEATH +" = "weibull"))

#race/ethnicity
table(flu.sym.death$RACE_ETH, flu.sym.death$orworse.event)
flu.sym.death.race.clean <- flu.sym.death %>% filter(RACE_ETH %in% c("Asian", "Black", "Hispanic", "Pacific Islander", "White"))
flu.sym.death.race.clean$RACE_ETH <- factor(flu.sym.death.race.clean$RACE_ETH)

flu.sym.death.race.prob.model <- covariate_model_generator(flu.sym.death.race.clean, rate_covariate = 1, prob_covariate = "RACE_ETH", dists = c("DEATH -" = "exp", "DEATH +" = "weibull"))
flu.sym.death.race.prob.rate.model <- covariate_model_generator(flu.sym.death.race.clean, rate_covariate = "RACE_ETH", prob_covariate = "RACE_ETH", dists = c("DEATH -" = "exp", "DEATH +" = "weibull"))

#vaccination

flu.sym.death.vax.prob.model <- covariate_model_generator(flu.sym.death, rate_covariate = 1, prob_covariate = "flu_vac", dists = c("DEATH -" = "exp", "DEATH +" = "weibull"))
flu.sym.death.vax.prob.rate.model <- covariate_model_generator(flu.sym.death, rate_covariate = "flu_vac", prob_covariate = "flu_vac", dists = c("DEATH -" = "exp", "DEATH +" = "weibull"))

#ndi
flu.sym.death.ndi.clean <- flu.sym.death %>% filter(!is.na(NDI_group))
flu.sym.death.ndi.prob.model <- covariate_model_generator(flu.sym.death.ndi.clean, rate_covariate = 1, prob_covariate = "NDI_group", dists = c("DEATH -" = "exp", "DEATH +" = "weibull"))
flu.sym.death.ndi.prob.rate.model <- covariate_model_generator(flu.sym.death.ndi.clean, rate_covariate = "NDI_group", prob_covariate = "NDI_group", dists = c("DEATH -" = "exp", "DEATH +" = "weibull"))

#charlson wt

flu.sym.death.cw.prob.model <- covariate_model_generator(flu.sym.death, rate_covariate = 1, prob_covariate = "cw_group", dists = c("DEATH -" = "exp", "DEATH +" = "weibull"))
flu.sym.death.cw.prob.rate.model <- covariate_model_generator(flu.sym.death, rate_covariate = "cw_group", prob_covariate = "cw_group", dists = c("DEATH -" = "exp", "DEATH +" = "weibull"))

#get probs
covariate_prob(model = flu.sym.death.age.prob.model, data = flu.sym.death, covariate = "age_group", fil_event = "DEATH")
covariate_prob(model = flu.sym.death.gender.prob.model, data = flu.sym.death, covariate = "GENDER", fil_event = "DEATH")
covariate_prob(model = flu.sym.death.race.prob.model, data = flu.sym.death.race.clean, covariate = "RACE_ETH", fil_event = "DEATH")
covariate_prob(model = flu.sym.death.vax.prob.model, data = flu.sym.death, covariate = "flu_vac", fil_event = "DEATH")
covariate_prob(model = flu.sym.death.ndi.prob.model, data = flu.sym.death, covariate = "NDI_group", fil_event = "DEATH")
covariate_prob(model = flu.sym.death.cw.prob.model, data = flu.sym.death, covariate = "cw_group", fil_event = "DEATH")

covariate_rate_median(model = flu.sym.death.age.prob.rate.model, data = flu.sym.death, covariate = "age_group", fil_event = "DEATH")
covariate_rate_median(model = flu.sym.death.gender.prob.rate.model, data = flu.sym.death, covariate = "GENDER", fil_event = "DEATH")
covariate_rate_median(model = flu.sym.death.race.prob.rate.model, data = flu.sym.death, covariate = "RACE_ETH", fil_event = "DEATH")
covariate_rate_median(model = flu.sym.death.vax.prob.rate.model, data = flu.sym.death, covariate = "flu_vac", fil_event = "DEATH")
covariate_rate_median(model = flu.sym.death.ndi.prob.rate.model, data = flu.sym.death, covariate = "NDI_group", fil_event = "DEATH")
covariate_rate_median(model = flu.sym.death.cw.prob.rate.model, data = flu.sym.death, covariate = "cw_group", fil_event = "DEATH")









##############
##############
####### hospitalizations
##############
##############

flu.inpatient.stay <- inpatient.func(flu.time_from_pos_flu,  time_from_test_variable = time_from_pos_flu)


###
#with death and discharge
flu.all.inpatient <- flu.inpatient.stay %>% mutate(status = 1)


flu.all.inpatient.model <- flexsurvmix(Surv(total.stay, status) ~ 1,
                                       data = flu.all.inpatient,
                                       dist = "gengamma")
flu.all.inpatient.model

###
#with death and discharge as separate events
flu.death.discharge.inpatient.model <- flexsurvmix(Surv(total.stay, status) ~ 1,
                                                   event = final_state,
                                                   data = flu.all.inpatient, 
                                                   dists = c("DEATH" = "exp", "DISCHARGE" = "gompertz"),
                                                   method = "em", 
                                                   em.control = list(trace = 1),
                                                   optim.control = list(maxit = 1000),
                                                   inits = c())
flu.death.discharge.inpatient.model
