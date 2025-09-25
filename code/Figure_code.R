library(dplyr)
library(geomtextpath)
library(ggsci)
library(ggplot2)
library(gridExtra)
library(scales)
library(cowplot)
library(grid)
library(ggpubr)
library(forcats)

### set working directory
setwd("")

### necessary objects are in github



##################
################
####### figure 1: time-to-event from symps for all 3
################
################

load(file = "Figure_code/R_objects/pathogen_sym")

pathogen.sym$pathogen <- recode(pathogen.sym$pathogen, "COVID" = "SARS-CoV-2",
                                "Flu" = "Influenza")
pathogen.sym$pathogen <- factor(pathogen.sym$pathogen, levels = c("SARS-CoV-2", "Influenza", "RSV"))

#take all non-ventilation and death states
pathogen.sym.nodeathvent <- pathogen.sym %>% filter(state != "VENTILATION +" & state != "DEATH")

pathogen.sym.plot.nodeathvent <- ggplot(pathogen.sym.nodeathvent, aes(x=time, y=val, col=state)) +
  geom_textline(aes(x = time, y = val, group = state, colour = state, label = state),hjust = .94, size = 3) + 
  facet_grid(cols=vars(pathogen)) + 
  theme_classic(base_size = 11) +
  theme(strip.background = element_blank(),
        strip.text = element_text(face="bold", size = 10)) +
  scale_color_manual(values=c(pal_lancet()(5))) +
  scale_y_continuous(breaks = c(0, 0.25, 0.5, 0.75, 1), labels= c("0", "0.25", "0.50", "0.75", "1.00"), limits = c(0, 0.95)) +
  xlim(0,30) +
  xlab("Days after symptom onset") + ylab("Probability of event") + 
  labs(col="State") + labs(lty="Model") +
  theme(legend.position = "none")
pathogen.sym.plot.nodeathvent


####Make the ventilation/death plots for each pathogen
COVID.sym.deathvent <- pathogen.sym %>% filter(pathogen == "SARS-CoV-2") %>%
  filter(state == "VENTILATION +" | state == "DEATH")

COVID.sym.deathvent.plot <- ggplot(COVID.sym.deathvent, aes(x=time, y=val, col=state)) +
  geom_textline(aes(x = time, y = val, group = state, colour = state, label = state),hjust = .90, size = 2.8) + 
  facet_grid(cols=vars(pathogen)) + 
  theme_classic(base_size = 9) +
  theme(strip.background = element_blank(),
        strip.text = element_text(face="bold", size = 9)) +
  scale_color_manual(values=c(pal_lancet()(2))) +
  xlim(0,60) +
  scale_y_continuous(breaks = c(0, 0.01, 0.02), labels= c(0, 0.01, 0.02), limits = c(0, 0.021)) +
  xlab(element_blank()) +
  ylab("Probability of event") + 
  labs(col="State") + labs(lty="Model") +
  theme(legend.position = "none")
COVID.sym.deathvent.plot


flu.sym.deathvent <- pathogen.sym %>% filter(pathogen == "Influenza") %>%
  filter(state == "VENTILATION +" | state == "DEATH")

flu.sym.deathvent.plot <- ggplot(flu.sym.deathvent, aes(x=time, y=val, col=state)) +
  geom_textline(aes(x = time, y = val, group = state, colour = state, label = state),hjust = .90, size = 2.8) + 
  facet_grid(cols=vars(pathogen)) + 
  theme_classic(base_size = 9) +
  theme(strip.background = element_blank(),
        strip.text = element_text(face="bold", size = 9)) +
  scale_color_manual(values=c(pal_lancet()(2))) +
  xlim(0,60) +
  scale_y_continuous(breaks = c(0, 0.01), labels= c(0, 0.01), limits = c(0, 0.011)) +
  xlab(element_blank()) +
  ylab("Probability of event") + 
  labs(col="State") + labs(lty="Model") +
  theme(legend.position = "none")
flu.sym.deathvent.plot

rsv.sym.deathvent <- pathogen.sym %>% filter(pathogen == "RSV") %>% filter(state == "VENTILATION +" | state == "DEATH")

rsv.sym.deathvent.plot <- ggplot(rsv.sym.deathvent, aes(x=time, y=val, col=state)) +
  geom_textline(aes(x = time, y = val, group = state, colour = state, label = state),hjust = .90, size = 2.8) + 
  facet_grid(cols=vars(pathogen)) + 
  theme_classic(base_size = 9) +
  theme(strip.background = element_blank(),
        strip.text = element_text(face="bold", size = 9)) +
  scale_color_manual(values=c(pal_lancet()(2))) +
  xlim(0,60) +
  ylim(0,0.05) +
  xlab("Days after symptom onset") + ylab("Probability of event") + 
  labs(col="State") + labs(lty="Model") +
  theme(legend.position = "none")
rsv.sym.deathvent.plot


## combine them all to make figure 1
figure1 <- grid.arrange(pathogen.sym.plot.nodeathvent, COVID.sym.deathvent.plot, flu.sym.deathvent.plot, rsv.sym.deathvent.plot,
             layout_matrix = cbind(c(1,1,1), c(2,3,4)), 
             widths = c(1, 0.4), 
             heights = c(0.3, 0.3, 0.3)) 

ggsave("figure_1_wide.png", plot = figure1, width = 10, height = 7)



############
############
#####Figure 2 - densities
############
############

# bring in the required objects
load(file = "Figure_code/R_objects/ow_direct_dens")
load(file = "Figure_code/R_objects/ow_direct_sym")
load(file = "Figure_code/R_objects/testing_sym")
load(file =  "Figure_code/R_objects/testing_dens")



## make a plot for each state from symptom onset for densities for time for ever accessing care and state or worse outcome

testing.dens.plot <- testing.sym %>%
  ggplot(aes(x=time_clean)) + 
  geom_histogram(boundary=0, binwidth = 1, aes(y=after_stat(density)), col="gray", fill = "white")  +
  facet_grid(cols = vars(pathogen)) +
  theme_classic(base_size = 10) +
  theme(legend.position = "none",
        axis.title.y = element_text(size = 8)) +
  xlab("Days since symptom onset") + 
  ylab("Density") + 
  xlim(0,15) + 
  scale_y_continuous(pretty_breaks(n = 3)) +
  geom_line(data=dplyr::filter(testing.dens, ), 
            aes(y=dens, x=x)) +
  theme(
    strip.text.x = element_blank(),
    axis.title.x = element_blank(),
    strip.text.y = element_blank()
  ) +
  scale_y_continuous(breaks = pretty_breaks(n = 3)) 

testing.dens.plot


just.virt.sym <- ow.direct.sym %>% filter(state == "VIRTUAL +") %>% mutate(clean.state = "VIRTUAL")
just.virt.dens <- ow.direct.dens %>% filter((state == "VIRTUAL +" & event == "VIRTUAL +") | direct.event == "VIRTUAL") %>% mutate(clean.state = "VIRTUAL")

virtual.dens.plot <- just.virt.sym %>%
  ggplot(aes(x=time_clean)) + 
  geom_histogram(boundary=0, binwidth = 1, aes(y=after_stat(density)), col="gray", fill = "white")  +
  facet_grid(rows = vars(type), cols = vars(pathogen)) +
  theme_classic(base_size = 10) +
  theme(legend.position = "none",
        axis.title.y = element_text(size = 8)) +
  xlab("Days since symptom onset") + 
  ylab("Density") + 
  ylim(0,0.25) + 
  xlim(0,15) + 
  geom_line(data=dplyr::filter(just.virt.dens, ), 
            aes(y=dens, x=x)) +
  theme(
    strip.text.x = element_blank(),
    axis.title.x = element_blank(),
    strip.text.y = element_blank()
  ) +
  scale_y_continuous(breaks = pretty_breaks(n = 3)) 
virtual.dens.plot

just.out.sym <- ow.direct.sym %>% filter(state == "OUTPATIENT +") %>% mutate(clean.state = "OUTPATIENT")
just.out.dens <- ow.direct.dens %>% filter((state == "OUTPATIENT +" & event == "OUTPATIENT +") | direct.event == "OUTPATIENT") %>% mutate(clean.state = "OUTPATIENT")

outpatient.dens.plot <- just.out.sym %>%
  ggplot(aes(x=time_clean)) + 
  geom_histogram(boundary=0, binwidth = 1, aes(y=after_stat(density)), col="gray", fill = "white")  +
  facet_grid(rows = vars(type), cols = vars(pathogen)) +
  theme_classic(base_size = 10) +
  theme(legend.position = "none", 
        axis.title.y = element_text(size = 8)) +
  xlab("Days since symptom onset") + 
  ylab("Density") + 
  ylim(0,0.25) + 
  xlim(0,15) + 
  geom_line(data=dplyr::filter(just.out.dens, ), 
            aes(y=dens, x=x)) +
  theme(
    strip.text.x = element_blank(),
    axis.title.x = element_blank(),
    strip.text.y = element_blank()
  ) + 
  scale_y_continuous(breaks = pretty_breaks(n = 3)) 
outpatient.dens.plot

just.uc.sym <- ow.direct.sym %>% filter(state == "URGENTCARE +") %>% mutate(clean.state = "URGENTCARE")
just.uc.dens <- ow.direct.dens %>% filter((state == "URGENTCARE +" & event == "URGENTCARE +") | direct.event == "URGENT CARE") %>% mutate(clean.state = "URGENTCARE")

uc.dens.plot <- just.uc.sym %>%
  ggplot(aes(x=time_clean)) + 
  geom_histogram(boundary=0, binwidth = 1, aes(y=after_stat(density)), col="gray", fill = "white")  +
  facet_grid(rows = vars(type), cols = vars(pathogen)) +
  theme_classic(base_size = 10) +
  theme(legend.position = "none",
        axis.title.y = element_text(size = 8)) +
  xlab("Days since symptom onset") + 
  ylab("Density") + 
  ylim(0,0.25) + 
  xlim(0,15) + 
  geom_line(data=dplyr::filter(just.uc.dens, ), 
            aes(y=dens, x=x)) +
  theme(
    strip.text.x = element_blank(),
    axis.title.x = element_blank(),
    strip.text.y = element_blank()
  ) + 
  scale_y_continuous(breaks = pretty_breaks(n = 3)) 
uc.dens.plot

just.emerg.sym <- ow.direct.sym %>% filter(state == "EMERGENCY +") %>% mutate(clean.state = "EMERGENCY")
just.emerg.dens <- ow.direct.dens %>% filter((state == "EMERGENCY +" & event == "EMERGENCY +") | direct.event == "EMERGENCY") %>% mutate(clean.state = "EMERGENCY")

emergency.dens.plot <-just.emerg.sym %>%
  ggplot(aes(x=time_clean)) + 
  geom_histogram(boundary=0, binwidth = 1, aes(y=after_stat(density)), col="gray", fill = "white")  +
  facet_grid(rows = vars(type), cols = vars(pathogen)) +
  theme_classic(base_size = 10) +
  theme(legend.position = "none",
        axis.title.y = element_text(size = 8)) +
  xlab("Days since symptom onset") + 
  ylab("Density") + 
  ylim(0,0.25) + 
  xlim(0,15) + 
  geom_line(data=dplyr::filter(just.emerg.dens, ), 
            aes(y=dens, x=x)) +
  theme(
    strip.text.x = element_blank(),
    axis.title.x = element_blank(),
    strip.text.y = element_blank()
  ) + 
  scale_y_continuous(breaks = pretty_breaks(n = 3)) 
emergency.dens.plot

just.inpatient.sym <- ow.direct.sym %>% filter(state == "INPATIENT +") %>% mutate(clean.state = "INPATIENT")
just.inpatient.dens <- ow.direct.dens %>% filter((state == "INPATIENT +" & event == "INPATIENT +") | direct.event == "INPATIENT") %>% mutate(clean.state = "INPATIENT")

inpatient.dens.plot <- just.inpatient.sym %>%
  ggplot(aes(x=time_clean)) + 
  geom_histogram(boundary=0, binwidth = 1, aes(y=after_stat(density)), col="gray", fill = "white")  +
  facet_grid(rows = vars(type), cols = vars(pathogen)) +
  theme_classic(base_size = 10) +
  theme(legend.position = "none",
        axis.title.y = element_text(size = 8)) +
  xlab("Days since symptom onset") + 
  ylab("Density") + 
  ylim(0,0.25) + 
  xlim(0,15) + 
  geom_line(data=dplyr::filter(just.inpatient.dens, ), 
            aes(y=dens, x=x)) +
  theme(
    strip.text.x = element_blank(),
    axis.title.x = element_blank(),
    strip.text.y = element_blank()
  ) + 
  scale_y_continuous(breaks = pretty_breaks(n = 3)) 
inpatient.dens.plot

just.vent.sym <- ow.direct.sym %>% filter(state == "VENTILATION +") %>% mutate(clean.state = "VENTILATION")
just.vent.dens <- ow.direct.dens %>% filter((state == "VENTILATION +" & event == "VENTILATION +") | direct.event == "VENTILATION") %>% mutate(clean.state = "VENTILATION")

vent.dens.plot <- just.vent.sym %>%
  ggplot(aes(x=time_clean)) + 
  geom_histogram(boundary=0, binwidth = 2.5, aes(y=after_stat(density)), col="gray", fill = "white")  +
  facet_grid(rows = vars(type), cols = vars(pathogen)) +
  theme_classic(base_size = 10) +
  theme(legend.position = "none",
        axis.title.y = element_text(size = 8)) +
  xlab("Days since symptom onset") + 
  ylab("Density") + 
  ylim(0,0.15) + 
  xlim(0,50) + 
  geom_line(data=dplyr::filter(just.vent.dens, ), 
            aes(y=dens, x=x)) +
  theme(
    strip.text.x = element_blank(),
    axis.title.x = element_blank(),
    strip.text.y = element_blank()
  ) + 
  scale_y_continuous(breaks = pretty_breaks(n = 3)) 
vent.dens.plot

just.death.sym <- ow.direct.sym %>% filter(state == "DEATH +") %>% mutate(clean.state = "DEATH")
just.death.dens <- ow.direct.dens %>% filter(direct.event == "DEATH") %>% mutate(clean.state = "DEATH")

death.dens.plot <- just.death.sym %>%
  ggplot(aes(x=time_clean)) + 
  geom_histogram(boundary=0, binwidth = 2.5, aes(y=after_stat(density)), col="gray", fill = "white")  +
  facet_grid(cols = vars(pathogen)) +
  theme_classic(base_size = 10) +
  theme(legend.position = "none",
        axis.title.y = element_text(size = 8),
        axis.title.x = element_text(size = 10)) +
  xlab("Days since symptom onset") + 
  ylab("Density") + 
  ylim(0,0.1) + 
  xlim(0,50) + 
  geom_line(data=dplyr::filter(just.death.dens, ), 
            aes(y=dens, x=x)) +
  theme(
    strip.text.x = element_blank(),
    strip.text.y = element_blank()
  ) + 
  scale_y_continuous(breaks = pretty_breaks(n = 3)) 
death.dens.plot



### make a label for each state

testing.text = ggplot() +
  annotate("text", x = 0.6,  y = 1,
           size = 3,
           label = "Positive test",
           fontface = "bold") +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

virtual.text = ggplot() +
  annotate("text", x = 0.6,  y = 1,
           size = 3,
           label = "Virtual", 
           fontface = "bold") +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

outpatient.text = ggplot() +
  annotate("text", x = 0.6,  y = 1,
           size = 3,
           label = "Outpatient", 
           fontface = "bold") +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

uc.text = ggplot() +
  annotate("text", x = 0.6,  y = 1,
           size = 3,
           label = "Urgent Care", 
           fontface = "bold") +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

emerg.text = ggplot() +
  annotate("text", x = 0.6,  y = 1,
           size = 3,
           label = "Emergency", 
           fontface = "bold") +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

inpatient.text = ggplot() +
  annotate("text", x = 0.6,  y = 1,
           size = 3,
           label = "Inpatient", 
           fontface = "bold") +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

vent.text = ggplot() +
  annotate("text", x = 0.6,  y = 1,
           size = 3,
           label = "Ventilation", 
           fontface = "bold") +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

death.text = ggplot() +
  annotate("text", x = 0.6,  y = 1,
           size = 3,
           label = "Death", 
           fontface = "bold") +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

COVID.text = ggplot() +
  annotate("text", x = 0.32,  y = 1,
           size = 4,
           label = "SARS-CoV-2", 
           fontface = "bold") +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

flu.text = ggplot() +
  annotate("text", x = 0.4,  y = 1,
           size = 4,
           label = "Influenza", 
           fontface = "bold") +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

rsv.text = ggplot() +
  annotate("text", x = 0.45,  y = 1,
           size = 4,
           label = "RSV", 
           fontface = "bold") +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

testing.side.text = ggplot() +
  annotate("text", x = 10,  y = 5,
           size = 2.3,
           label = "Panel = time to a positive test", 
           fontface = "italic") +
  theme_void()

virtual.side.text = ggplot() +
  annotate("text", x = 10,  y = 5,
           size = 2.3,
           label = "Top panel = time to ever \n accessing virtual care \n Bottom panel = time to virtual \n or higher level of care", 
           fontface = "italic") +
  theme_void()

outpatient.side.text = ggplot() +
  annotate("text", x = 10,  y = 5,
           size = 2.3,
           label = "Top panel = time to ever \n accessing outpatient care \n Bottom panel = time to outpatient \n or higher level of care",
           fontface = "italic") +
  theme_void()

uc.side.text = ggplot() +
  annotate("text", x = 10,  y = 5,
           size = 2.3,
           label = "Top panel = time to ever \n accessing urgent care \n Bottom panel = time to urgent care \n or higher level of care", 
           fontface = "italic") +
  theme_void()

emerg.side.text = ggplot() +
  annotate("text", x = 10,  y = 5,
           size = 2.3,
           label = "Top panel = time to ever \n accessing emergency care \n Bottom panel = time to emergency \n or higher level of care", 
           fontface = "italic") +
  theme_void()

inpatient.side.text = ggplot() +
  annotate("text", x = 10,  y = 5,
           size = 2.3,
           label = "Top panel = time to ever \n accessing inpatient care \n Bottom panel = time to inpatient \n or higher level of care", 
           fontface = "italic") +
  theme_void()

vent.side.text = ggplot() +
  annotate("text", x = 10,  y = 5,
           size = 2.3,
           label = "Top panel = time to ever \n being ventilated \n Bottom panel = time to ventilation \n or death", 
           fontface = "italic") +
  theme_void()

death.side.text = ggplot() +
  annotate("text", x = 10,  y = 5,
           size = 2.3,
           label = "Panel = time to death", 
           fontface = "italic") +
  theme_void()


### combine all the figures and labels into figure 2
figure2 <- grid.arrange(COVID.text, flu.text, rsv.text,
                        testing.text, testing.dens.plot, testing.side.text,
                        virtual.text, virtual.dens.plot, virtual.side.text, 
                        outpatient.text, outpatient.dens.plot, outpatient.side.text,
                        uc.text, uc.dens.plot, uc.side.text,
                        emerg.text, emergency.dens.plot, emerg.side.text,
                        inpatient.text, inpatient.dens.plot, inpatient.side.text,
                        vent.text, vent.dens.plot, vent.side.text,
                        death.text, death.dens.plot, death.side.text,
                        layout_matrix = cbind(c(NA, 4, 5, 7, 8, 10, 11, 13, 14, 16, 17, 19, 20, 22, 23, 25, 26), c(1, NA, 5, NA, 8, NA, 11, NA, 14, NA, 17, NA, 20, NA, 23, NA, 26), c(2, NA, 5, NA, 8, NA, 11, NA, 14, NA, 17, NA, 20, NA, 23, NA, 26), c(3, NA, 5, NA, 8, NA, 11, NA, 14, NA, 17, NA, 20, NA, 23, NA, 26),  c(NA, NA, 6, NA, 9, NA, 12, NA, 15, NA, 18, NA, 21, NA, 24, NA, 27)), 
                        widths = c(0.35, 1.00, 1.05, 1.05, 0.58), 
                        heights = c(0.5, 0.5, 1.5, 0.5, 2, 0.5, 2, 0.5, 2, 0.5, 2, 0.5, 2, 0.5, 2, 0.5, 2)) 

figure2 <- grid.arrange(COVID.text, flu.text, rsv.text,
                        testing.text, testing.dens.plot,
                        virtual.text, virtual.dens.plot, 
                        outpatient.text, outpatient.dens.plot,
                        uc.text, uc.dens.plot,
                        emerg.text, emergency.dens.plot,
                        inpatient.text, inpatient.dens.plot,
                        vent.text, vent.dens.plot,
                        death.text, death.dens.plot,
                        layout_matrix = cbind(c(NA, 4, 5, 7, 8, 10, 11, 13, 14, 16, 17, 19, 20, 22, 23, 25, 26), c(1, NA, 5, NA, 8, NA, 11, NA, 14, NA, 17, NA, 20, NA, 23, NA, 26), c(2, NA, 5, NA, 8, NA, 11, NA, 14, NA, 17, NA, 20, NA, 23, NA, 26), c(3, NA, 5, NA, 8, NA, 11, NA, 14, NA, 17, NA, 20, NA, 23, NA, 26)), 
                        widths = c(0.4, 1.00, 1.05, 1.05), 
                        heights = c(0.5, 0.5, 1.5, 0.5, 2, 0.5, 2, 0.5, 2, 0.5, 2, 0.5, 2, 0.5, 2, 0.5, 2)) 

ggsave("figure_2.png", plot = figure2, width = 8, height = 10)


################
################
####### Figure 3 - covariates
################
################



#load in required datasets
load(file = "Figure_code/R_objects/COVID_oi_age_probs")
load(file = "Figure_code/R_objects/COVID_oi_gender_probs")
load(file = "Figure_code/R_objects/COVID_oi_race_probs")
load(file = "Figure_code/R_objects/COVID_oi_vax_probs")
load(file = "Figure_code/R_objects/COVID_oi_ndi_probs")
load(file = "Figure_code/R_objects/COVID_oi_cw_probs")
load(file = "Figure_code/R_objects/COVID_oi_age_dens")
load(file = "Figure_code/R_objects/COVID_oi_gender_dens")
load(file = "Figure_code/R_objects/COVID_oi_race_dens")
load(file = "Figure_code/R_objects/COVID_oi_vax_dens")
load(file = "Figure_code/R_objects/COVID_oi_ndi_dens")
load(file = "Figure_code/R_objects/COVID_oi_cw_dens")


#create a ggplot to take a legend from, to use for the rest of the figure
COVID.oi.age.probs$event <- factor(COVID.oi.age.probs$event, levels = c("OUTPATIENT +", "INPATIENT +"))
COVID.age.prob.plot.legend <- ggplot(COVID.oi.age.probs) +
  geom_dotplot(aes(x = age_group, y = val, fill = event, color = event), binaxis = "y", stackdir = "center", dotsize = 4) +
  geom_linerange(aes(x = age_group, ymin = lower, ymax = upper, color = event)) +
  ylim(0, 1) +
  theme_classic(base_size = 8) +
  theme(legend.position = "top",
        legend.title = element_blank()) +
  theme(legend.key.size = unit(0.3, 'cm'), 
        legend.key.height = unit(0.3, 'cm'),
        legend.key.width = unit(0.3, 'cm'),
        legend.text = element_text(size=7))

left.legend  <-  get_legend(COVID.age.prob.plot.legend)
left.legend <- as_ggplot(left.legend)
left.legend



#### for each covariate, make a dotplot of the probability of outpatient + and inpatient + for each subgroup

COVID.age.prob.plot <- ggplot(COVID.oi.age.probs) +
  geom_dotplot(aes(x = age_group, y = val, fill = event, color = event), binaxis = "y", stackdir = "center", dotsize = 1.5) +
  geom_linerange(aes(x = age_group, ymin = lower, ymax = upper, color = event)) +
  ylim(0, 1) +
  theme_classic(base_size = 8) +
  theme(legend.position = "none") +
  theme(axis.title.x = element_blank())
COVID.age.prob.plot


COVID.gender.prob.plot <- ggplot(COVID.oi.gender.probs) +
  geom_dotplot(aes(x = GENDER, y = val, fill = event, color = event), binaxis = "y", stackdir = "center", dotsize = 1.5) +
  geom_linerange(aes(x = GENDER, ymin = lower, ymax = upper, color = event)) +
  ylim(0, 1) +
  theme_classic(base_size = 8) +
  theme(legend.position = "none") +
  theme(axis.title.x = element_blank())
COVID.gender.prob.plot

COVID.oi.race.probs$RACE_ETH <- fct_recode(COVID.oi.race.probs$RACE_ETH,
                                           "AIAN" = "Native Am Alaskan",
                                           "PI" = "Pacific Islander")
COVID.race.prob.plot <- ggplot(COVID.oi.race.probs) +
  geom_dotplot(aes(x = RACE_ETH, y = val, fill = event, color = event), binaxis = "y", stackdir = "center", dotsize = 1.5) +
  geom_linerange(aes(x = RACE_ETH, ymin = lower, ymax = upper, color = event)) +
  ylim(0, 1) +
  theme_classic(base_size = 8)  +
  theme(legend.position = "none") +
  theme(axis.title.x = element_blank())
COVID.race.prob.plot

COVID.vax.prob.plot <- ggplot(COVID.oi.vax.probs) +
  geom_dotplot(aes(x = COVID_vac, y = val, fill = event, color = event), binaxis = "y", stackdir = "center", dotsize = 1.5) +
  geom_linerange(aes(x = COVID_vac, ymin = lower, ymax = upper, color = event)) +
  ylim(0, 1) +
  theme_classic(base_size = 8) +
  theme(legend.position = "none")+
  theme(axis.title.x = element_blank())

COVID.ndi.prob.plot <- ggplot(COVID.oi.ndi.probs) +
  geom_dotplot(aes(x = NDI_group, y = val, fill = event, color = event), binaxis = "y", stackdir = "center", dotsize = 1.5) +
  geom_linerange(aes(x = NDI_group, ymin = lower, ymax = upper, color = event)) +
  ylim(0, 1) +
  theme_classic(base_size = 8) +
  theme(legend.position = "none")+
  theme(axis.title.x = element_blank())
COVID.ndi.prob.plot

COVID.cw.prob.plot <- ggplot(COVID.oi.cw.probs) +
  geom_dotplot(aes(x = cw_group, y = val, fill = event, color = event), binaxis = "y", stackdir = "center", dotsize = 1.5) +
  geom_linerange(aes(x = cw_group, ymin = lower, ymax = upper, color = event)) +
  ylim(0, 1) +
  theme_classic(base_size = 8) +
  theme(legend.position = "none")+
  theme(axis.title.x = element_blank())


### create a text label for each state

outpatient.text <- ggplot() +
  annotate("text", x = 10,  y = 5,
           size = 2.5,
           label = "OUTPATIENT +", 
           fontface = "bold") +
  theme_void()

inpatient.text <- ggplot() +
  annotate("text", x = 10,  y = 5,
           size = 2.5,
           label = "INPATIENT +", 
           fontface = "bold") +
  theme_void()

age.text = ggplot() +
  annotate("text", x = 10,  y = 5,
           size = 1.8,
           label = "Age") +
  theme_void()

gender.text = ggplot() +
  annotate("text", x = 10,  y = 5,
           size = 1.8,
           label = "Gender") +
  theme_void()

race.text = ggplot() +
  annotate("text", x = 10,  y = 5,
           size = 1.8,
           label = "Race/ethnicity") +
  theme_void()

vac.text = ggplot() +
  annotate("text", x = 10,  y = 5,
           size = 1.8,
           label = "COVID Vaccinations") +
  theme_void()

ndi.text = ggplot() +
  annotate("text", x = 10,  y = 5,
           size = 1.8,
           label = "NDI") +
  theme_void()

cw.text = ggplot() +
  annotate("text", x = 10,  y = 5,
           size = 1.8,
           label = "Charlson Index") +
  theme_void()



## create a density plot for each covariate
## 
COVID.age.dens.plot <- ggplot(COVID.oi.age.dens) +
  facet_grid(cols = vars(factor(event, levels = c("OUTPATIENT +", "INPATIENT +")))) +
  geom_line(aes(x = x, y = dens, group = age_group, color = age_group)) +
  xlim(0, 15) +
  theme_classic(base_size = 6) +
  theme(legend.position = "right",
        legend.direction = "vertical",
        legend.title = element_blank()) +
  theme(legend.key.size = unit(0.2, 'cm'), 
        legend.key.height = unit(0.2, 'cm'),
        legend.key.width = unit(0.2, 'cm'),
        legend.text = element_text(size=6)) +
  theme(strip.text.x = element_blank(),
        axis.title.x = element_blank())
COVID.age.dens.plot

COVID.gender.dens.plot <- ggplot(COVID.oi.gender.dens) +
  facet_grid(cols = vars(factor(event, levels = c("OUTPATIENT +", "INPATIENT +")))) +
  geom_line(aes(x = x, y = dens, group = GENDER, color = GENDER)) +
  xlim(0, 15) +
  theme_classic(base_size = 6) +
  theme(legend.position = "right",
        legend.direction = "vertical",
        legend.title = element_blank())+
  theme(legend.key.size = unit(0.2, 'cm'), 
        legend.key.height = unit(0.2, 'cm'),
        legend.key.width = unit(0.2, 'cm'),
        legend.text = element_text(size=6),
        legend.box.margin=margin(5,5,5,5)) +
  theme(strip.text.x = element_blank(),
        axis.title.x = element_blank()) +
  ylab("Density")
COVID.gender.dens.plot



COVID.oi.gender.probs.outpatient <- filter(COVID.oi.gender.probs, event == "OUTPATIENT +")
COVID.oi.gender.probs.inpatient <- filter(COVID.oi.gender.probs, event == "INPATIENT +")
COVID.gender.prob.plot <- ggplot(COVID.oi.gender.probs.outpatient) +
  geom_dotplot(aes(x = event, y = val, fill = GENDER, color = GENDER), binaxis = "y", stackdir = "center", dotsize = 1.5) +
  geom_linerange(aes(x = event, ymin = lower, ymax = upper, color = GENDER), linewidth = 2) +
  ylim(0.4, 0.6) +
  theme_classic(base_size = 8) +
  theme(legend.position = "none") +
  theme(axis.title.x = element_blank()) +
  ylab("Probability")
COVID.gender.prob.plot


plot.with.inset <-
  ggdraw() +
  draw_plot(COVID.gender.dens.plot) +
  draw_plot(COVID.gender.prob.plot, x = 0.57, y = .7, width = .3, height = .3) +
  draw_plot(COVID.gender.prob.plot, x = 0.27, y = .7, width = .3, height = .3)
plot.with.inset

# Can save the plot with ggsave()
ggsave(filename = "plot.with.inset.png", 
       plot = plot.with.inset,
       width = 17, 
       height = 12,
       units = "cm",
       dpi = 300)

COVID.oi.race.dens$RACE_ETH <- fct_recode(COVID.oi.race.dens$RACE_ETH,
                                          "AIAN" = "Native Am Alaskan",
                                          "PI" = "Pacific Islander")
COVID.race.dens.plot <- ggplot(COVID.oi.race.dens) +
  facet_grid(cols = vars(factor(event, levels = c("OUTPATIENT +", "INPATIENT +")))) +
  geom_line(aes(x = x, y = dens, group = RACE_ETH, color = RACE_ETH)) +
  xlim(0, 15) +
  theme_classic(base_size = 6) +
  theme(legend.position = "right",
        legend.direction = "vertical",
        legend.title = element_blank())+
  theme(legend.key.size = unit(0.2, 'cm'), 
        legend.key.height = unit(0.2, 'cm'),
        legend.key.width = unit(0.2, 'cm'),
        legend.text = element_text(size=6),
        legend.box.margin=margin(-5,-5,-5,-5)) +
  theme(strip.text.x = element_blank(),
        axis.title.x = element_blank())
COVID.race.dens.plot

COVID.vax.dens.plot <- ggplot(COVID.oi.vax.dens) +
  facet_grid(cols = vars(factor(event, levels = c("OUTPATIENT +", "INPATIENT +")))) +
  geom_line(aes(x = x, y = dens, group = COVID_vac, color = COVID_vac)) +
  xlim(0, 15) +
  theme_classic(base_size = 6) +
  theme(legend.position = "right",
        legend.direction = "vertical",
        legend.title = element_blank())+
  theme(legend.key.size = unit(0.2, 'cm'), 
        legend.key.height = unit(0.2, 'cm'),
        legend.key.width = unit(0.2, 'cm'),
        legend.text = element_text(size=6),
        legend.justification = "left",
        legend.box.margin=margin(5,5,5,5)) +
  theme(strip.text.x = element_blank(),
        axis.title.x = element_blank())
COVID.vax.dens.plot

COVID.ndi.dens.plot <- ggplot(COVID.oi.ndi.dens) +
  facet_grid(cols = vars(factor(event, levels = c("OUTPATIENT +", "INPATIENT +")))) +
  geom_line(aes(x = x, y = dens, group = NDI_group, color = NDI_group)) +
  xlim(0, 15) +
  theme_classic(base_size = 6) +
  theme(legend.position = "right",
        legend.direction = "vertical",
        legend.title = element_blank())+
  theme(legend.key.size = unit(0.2, 'cm'), 
        legend.key.height = unit(0.2, 'cm'),
        legend.key.width = unit(0.2, 'cm'),
        legend.text = element_text(size=6)) +
  theme(strip.text.x = element_blank(),
        axis.title.x = element_blank())
COVID.ndi.dens.plot

COVID.cw.dens.plot <- ggplot(COVID.oi.cw.dens) +
  facet_grid(cols = vars(factor(event, levels = c("OUTPATIENT +", "INPATIENT +")))) +
  geom_line(aes(x = x, y = dens, group = cw_group, color = cw_group)) +
  xlim(0, 15) +
  theme_classic(base_size = 6) +
  theme(legend.position = "right",
        legend.direction = "vertical",
        legend.title = element_blank())+
  theme(legend.key.size = unit(0.2, 'cm'), 
        legend.key.height = unit(0.2, 'cm'),
        legend.key.width = unit(0.2, 'cm'),
        legend.text = element_text(size=6)) +
  theme(strip.text.x = element_blank(),
        axis.title.x = element_blank())
COVID.cw.dens.plot


figure3 <- grid.arrange(left.legend, outpatient.text, inpatient.text,
             age.text, COVID.age.prob.plot, COVID.age.dens.plot, 
             gender.text, COVID.gender.prob.plot, COVID.gender.dens.plot, 
             race.text, COVID.race.prob.plot, COVID.race.dens.plot, 
             vac.text, COVID.vax.prob.plot, COVID.vax.dens.plot,
             ndi.text, COVID.ndi.prob.plot, COVID.ndi.dens.plot,
             cw.text, COVID.cw.prob.plot, COVID.cw.dens.plot,
             layout_matrix = cbind(c(1, 4, 5, 7, 8, 10, 11, 13, 14, 16, 17, 19, 20), c(1, NA, 5, NA, 8, NA, 11, NA, 14, NA, 17, NA, 20), c(2, NA, 6, NA, 9, NA, 12, NA, 15, NA, 18, NA, 21), c(3, NA, 6, NA, 9, NA, 12, NA, 15, NA, 18, NA, 21)), 
             widths = c(0.2, 0.5, 0.4, 0.5), 
             heights = c(0.3, 0.3, 1, 0.3, 1, 0.3, 1, 0.3, 1, 0.3, 1, 0.3, 1))

figure3


################
################
####### Figure 4 - hospital stays
################
################


load(file = "Figure_code/R_objects/inpatient_dat_together")

inpatient.dat.together$pathogen <- recode(inpatient.dat.together$pathogen, "COVID" = "SARS-CoV-2",
                                "Flu" = "Influenza")
inpatient.dat.together$pathogen <- factor(inpatient.dat.together$pathogen, levels = c("SARS-CoV-2", "Influenza", "RSV"))

#plot the result of hospitalization for each pathogen
inpatient.together.plot <- ggplot(data = inpatient.dat.together) +
  geom_line(aes(x = x, y = dens, group = type, color = type)) +
  scale_color_manual(values=c(pal_lancet()(3))) +
  facet_grid(cols = vars(pathogen)) +
  xlim(0,30) +
  theme_classic(base_size = 8) +
  labs(color = "Result of hospitalization") +
  theme(legend.text = element_text(size = 7),
        legend.title = element_text(size = 7),
        legend.key.height = unit(0.2, "cm"),
        legend.key.width = unit(0.3, "cm")) +
  theme(strip.background = element_blank(),
        strip.text = element_text(face="bold", size = 8),
        legend.position = c(.88, .75)) +
  xlab("Days since inpatient admission") + 
  ylab("Density") 

inpatient.together.plot


load(file = "Figure_code/R_objects/vent_dat_together")

### plot the time to ventilation for each pathogen
vent.together.plot <- ggplot(data = vent.dat.together) +
  geom_line(aes(x = x, y = dens, group = type, color = type)) +
  scale_color_manual(values=c(pal_lancet()(3))) +
  facet_grid(cols = vars(pathogen)) +
  xlim(0, 5) +
  theme_classic(base_size = 8) +
  theme(strip.background = element_rect(fill = "white"),
        strip.text.x = element_blank()) +
  theme(legend.text = element_text(size = 7),,
        legend.key.height = unit(0.2, "cm"),
        legend.key.width = unit(0.3, "cm"),
        legend.position = c(.88, .75),
        legend.title = element_blank()) +
  xlab("Days since inpatient admission") + 
  ylab("Density") 
vent.together.plot

## combine for figure 4
figure4 <- grid.arrange(inpatient.together.plot,
             vent.together.plot,
             layout_matrix = cbind(c(1,2), c(1,2)), 
             widths = c(1, 1), 
             heights = c(0.5, 0.5)) 



ggsave("figure_4.png", plot = figure4, width = 5, height = 5)

















################
################
####### Figure 3 - covariates
################
################



#load in required datasets
load(file = "Figure_code/R_objects/COVID_oi_age_probs")
load(file = "Figure_code/R_objects/COVID_oi_gender_probs")
load(file = "Figure_code/R_objects/COVID_oi_race_probs")
load(file = "Figure_code/R_objects/COVID_oi_vax_probs")
load(file = "Figure_code/R_objects/COVID_oi_ndi_probs")
load(file = "Figure_code/R_objects/COVID_oi_cw_probs")
load(file = "Figure_code/R_objects/COVID_oi_age_dens")
load(file = "Figure_code/R_objects/COVID_oi_gender_dens")
load(file = "Figure_code/R_objects/COVID_oi_race_dens")
load(file = "Figure_code/R_objects/COVID_oi_vax_dens")
load(file = "Figure_code/R_objects/COVID_oi_ndi_dens")
load(file = "Figure_code/R_objects/COVID_oi_cw_dens")


### create a text label for each state

outpatient.text <- ggplot() +
  annotate("text", x = 0.1,  y = 1,
           size = 3.4,
           label = "Time to outpatient or higher-acuity threshold", 
           fontface = "bold",
           hjust = 0) +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

inpatient.text <- ggplot() +
  annotate("text", x = 0.2,  y = 1,
           size = 3.4,
           label = "Time to inpatient or higher-acuity threshold", 
           fontface = "bold",
           hjust = 0) +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

age.text = ggplot() +
  annotate("text", x = 0.2,  y = 1,
           size = 3,
           label = "Age", 
           fontface = "bold",
           hjust = 0) +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void()


gender.text = ggplot() +
  annotate("text", x = 0.2,  y = 1,
           size = 3,
           label = "Sex", 
           fontface = "bold") +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

race.text = ggplot() +
  annotate("text", x = 0.2,  y = 1,
           size = 3,
           label = "Race/ethnicity", 
           fontface = "bold",
           hjust = 0) +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

vac.text = ggplot() +
  annotate("text", x = 0.2,  y = 1,
           size = 3,
           label = "COVID-19 Vaccinations", 
           fontface = "bold",
           hjust = 0) +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

ndi.text = ggplot() +
  annotate("text", x = 0.2,  y = 1,
           size = 3,
           label = "NDI", 
           fontface = "bold",
           hjust = 0) +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

cw.text = ggplot() +
  annotate("text", x = 0.2,  y = 1,
           size = 3,
           label = "Charlson comorbidity index", 
           fontface = "bold",
           hjust = 0) +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 


create_inset_plot <- function(probsdata, densdata, variable, legend_margin = 85){
  levels <- n_distinct(probsdata %>% pull({{variable}}))
  
  outpatient_data <- filter(probsdata, event == "OUTPATIENT +")
  inpatient_data <- filter(probsdata, event == "INPATIENT +")
  
  prob.outpatient.plot <- ggplot(outpatient_data, aes(x = event, y = val, fill = {{variable}}, color = {{variable}})) +
    geom_point(position = position_dodge(width = 0.9), size = 0.7) +
    geom_linerange(aes(ymin = lower, ymax = upper), 
                   position = position_dodge(width = 0.9), 
                   linewidth = 0.7) +
    ylim(ifelse(min(outpatient_data$lower) - 0.1 > 0, min(outpatient_data$lower) - 0.05, 0), max(outpatient_data$upper) + 0.05) +
    scale_color_manual(values=c(pal_lancet()(levels))) +
    scale_y_continuous(breaks = pretty_breaks(n = 3)) +
    theme_classic(base_size = 8) +
    theme(legend.position = "none") +
    theme(axis.title.x = element_blank(),
          axis.text.x = element_blank(),
          axis.line.x =element_blank(),
          axis.ticks.x = element_blank()) +
    ylab("Probability")
  
  
  prob.inpatient.plot <- ggplot(inpatient_data, aes(x = event, y = val, fill = {{variable}}, color = {{variable}})) +
    geom_point(position = position_dodge(width = 0.9), size = 0.7) +
    geom_linerange(aes(ymin = lower, ymax = upper), 
                   position = position_dodge(width = 0.9), 
                   linewidth = 0.7) +
    ylim(ifelse(min(inpatient_data$lower) - 0.1 > 0, min(inpatient_data$lower) - 0.05, 0), max(inpatient_data$upper) + 0.05) +
    scale_y_continuous(breaks = pretty_breaks(n = 3)) +
    scale_color_manual(values=c(pal_lancet()(levels))) + 
    theme_classic(base_size = 8) +
    theme(legend.position = "none") +
    theme(axis.title.x = element_blank(),
          axis.text.x = element_blank(),
          axis.line.x =element_blank(),
          axis.ticks.x = element_blank()) +
    ylab("Probability")
  
  dens.plot <- ggplot(densdata) +
    facet_grid(cols = vars(factor(event, levels = c("OUTPATIENT +", "INPATIENT +")))) +
    geom_line(aes(x = x, y = dens, group = {{variable}}, color = {{variable}}), linewidth = 0.3) +
    scale_color_manual(values=c(pal_lancet()(levels))) +
    xlim(0, 15) +
    theme_classic(base_size = 9) +
    theme(legend.position = "right",
          legend.direction = "vertical",
          legend.justification = "center") +
    theme(legend.key.size = unit(0.2, 'cm'), 
          legend.key.height = unit(0.2, 'cm'),
          legend.key.width = unit(0.2, 'cm'),
          legend.text = element_text(size=8),
          legend.box.margin = margin(r = legend_margin, unit = "pt"),
          legend.title = element_blank()) +
    theme(strip.text.x = element_blank(),
          axis.title.x = element_blank()) +
    ylab("Density")
  
  plot.with.inset <-
    ggdraw() +
    draw_plot(dens.plot) +
    draw_plot(prob.outpatient.plot, x = 0.25, y = .45, width = .15, height = .7) +
    draw_plot(prob.inpatient.plot, x = 0.65, y = .45, width = .15, height = .7)
  
  return(plot.with.inset)
}

age_plots <- create_inset_plot(COVID.oi.age.probs, COVID.oi.age.dens, age_group)
age_plots

COVID.oi.gender.probs <- COVID.oi.gender.probs %>% mutate(GENDER = recode(GENDER, "M" = "Male", "F" = "Female")) %>% mutate(GENDER = factor(GENDER, levels = c("Male", "Female")))
COVID.oi.gender.dens <- COVID.oi.gender.dens %>% mutate(GENDER = recode(GENDER, "M" = "Male", "F" = "Female")) %>% mutate(GENDER = factor(GENDER, levels = c("Male", "Female")))
gender_plots <- create_inset_plot(COVID.oi.gender.probs, COVID.oi.gender.dens, GENDER)
gender_plots


COVID.oi.race.probs <- COVID.oi.race.probs %>% mutate(RACE_ETH = recode(RACE_ETH,
                                                                  "Native Am Alaskan" = "Native American/Alaska Native")) %>% mutate(RACE_ETH = factor(RACE_ETH, levels = c("White", "Asian", "Black", "Hispanic", "Pacific Islander", "Native American/Alaska Native", "Other", "Multiple", "Unknown")))
COVID.oi.race.dens <- COVID.oi.race.dens %>% mutate(RACE_ETH = recode(RACE_ETH,
                                                               "Native Am Alaskan" = "Native American/Alaska Native")) %>% mutate(RACE_ETH = factor(RACE_ETH, levels = c("White", "Asian", "Black", "Hispanic", "Pacific Islander", "Native American/Alaska Native", "Other", "Multiple", "Unknown")))
race_plots <- create_inset_plot(COVID.oi.race.probs, COVID.oi.race.dens, RACE_ETH, legend_margin = 0)
race_plots

COVID.oi.vax.probs <- COVID.oi.vax.probs %>% mutate(COVID_vac = recode(COVID_vac,
                                                                       "0" = "Unvacccinated",
                                                                       "<3" = "1-2 doses",
                                                                       "3+" = "3 or more doses"
                                                                       )) %>% mutate(COVID_vac = factor(COVID_vac, levels = c("Unvacccinated", "1-2 doses", "3 or more doses")))
COVID.oi.vax.dens <- COVID.oi.vax.dens %>% mutate(COVID_vac = recode(COVID_vac,
                                                                     "0" = "Unvacccinated",
                                                                     "<3" = "1-2 doses",
                                                                     "3+" = "3 or more doses"
)) %>% mutate(COVID_vac = factor(COVID_vac, levels = c("Unvacccinated", "1-2 doses", "3 or more doses")))
vax_plots <- create_inset_plot(COVID.oi.vax.probs, COVID.oi.vax.dens, COVID_vac, legend_margin = 52)
vax_plots

COVID.oi.ndi.probs <- COVID.oi.ndi.probs %>% mutate(NDI_group = recode(NDI_group,
                                                                       "<-1" = "Below -1",
                                                                       "-1 - 0" = "-1 ≤ NDI < 0",
                                                                       "0 - 1" = "0 ≤ NDI < 1",
                                                                       ">1" = "Above 1")) %>% mutate(NDI_group = factor(NDI_group, levels = c("Below -1", "-1 ≤ NDI < 0", "0 ≤ NDI < 1", "Above 1")))
COVID.oi.ndi.dens <- COVID.oi.ndi.dens %>% mutate(NDI_group = recode(NDI_group,
                                                                     "<-1" = "Below -1",
                                                                     "-1 - 0" = "-1 ≤ NDI < 0",
                                                                     "0 - 1" = "0 ≤ NDI < 1",
                                                                     ">1" = "Above 1")) %>% mutate(NDI_group = factor(NDI_group, levels = c("Below -1", "-1 ≤ NDI < 0", "0 ≤ NDI < 1", "Above 1")))
ndi_plots <- create_inset_plot(COVID.oi.ndi.probs, COVID.oi.ndi.dens, NDI_group, legend_margin = 50)
ndi_plots

COVID.oi.cw.probs <- COVID.oi.cw.probs %>% mutate(cw_group = recode(cw_group,
                                                                    "6+" = "≥6"))
COVID.oi.cw.dens <- COVID.oi.cw.dens %>% mutate(cw_group = recode(cw_group,
                                                                  "6+" = "≥6"))
cw_plots <- create_inset_plot(COVID.oi.cw.probs, COVID.oi.cw.dens, cw_group)
cw_plots


figure3 <- grid.arrange(outpatient.text, inpatient.text,
                        age.text, age_plots, 
                        gender.text, gender_plots, 
                        race.text, race_plots, 
                        vac.text, vax_plots,
                        ndi.text, ndi_plots,
                        cw.text, cw_plots,
                        layout_matrix = cbind(c(1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14), c(1, NA, 4, NA, 6, NA, 8, NA, 10, NA, 12, NA, 14), c(2, NA, 4, NA, 6, NA, 8, NA, 10, NA, 12, NA, 14)), 
                        widths = c(0.2, 0.15, 0.65), 
                        heights = c(0.4, 0.4, 1.2, 0.4, 1.2, 0.4, 1.2, 0.4, 1.2, 0.4, 1.2, 0.4, 1.2))



figure3


ggsave("figure_3.png", plot = figure3, width = 10, height = 10)



###########
###########
###### repeat for flu
###########
###########


#load in required datasets
load(file = "Figure_code/R_objects/flu_oi_age_probs")
load(file = "Figure_code/R_objects/flu_oi_gender_probs")
load(file = "Figure_code/R_objects/flu_oi_race_probs")
load(file = "Figure_code/R_objects/flu_oi_vax_probs")
load(file = "Figure_code/R_objects/flu_oi_ndi_probs")
load(file = "Figure_code/R_objects/flu_oi_cw_probs")
load(file = "Figure_code/R_objects/flu_oi_age_dens")
load(file = "Figure_code/R_objects/flu_oi_gender_dens")
load(file = "Figure_code/R_objects/flu_oi_race_dens")
load(file = "Figure_code/R_objects/flu_oi_vax_dens")
load(file = "Figure_code/R_objects/flu_oi_ndi_dens")
load(file = "Figure_code/R_objects/flu_oi_cw_dens")


flu.vac.text = ggplot() +
  annotate("text", x = 0.2,  y = 1,
           size = 3,
           label = "Influenza vaccination", 
           fontface = "bold",
           hjust = 0) +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

flu_age_plots <- create_inset_plot(flu.oi.age.probs, flu.oi.age.dens, age_group)
flu_age_plots

flu.oi.gender.probs <- flu.oi.gender.probs %>% mutate(GENDER = recode(GENDER, "M" = "Male", "F" = "Female")) %>% mutate(GENDER = factor(GENDER, levels = c("Male", "Female")))
flu.oi.gender.dens <- flu.oi.gender.dens %>% mutate(GENDER = recode(GENDER, "M" = "Male", "F" = "Female")) %>% mutate(GENDER = factor(GENDER, levels = c("Male", "Female")))
flu_gender_plots <- create_inset_plot(flu.oi.gender.probs, flu.oi.gender.dens, GENDER)
flu_gender_plots


flu.oi.race.probs <- flu.oi.race.probs %>% mutate(RACE_ETH = recode(RACE_ETH,
                                                                        "Native Am Alaskan" = "Native American/Alaska Native")) %>% mutate(RACE_ETH = factor(RACE_ETH, levels = c("White", "Asian", "Black", "Hispanic", "Pacific Islander", "Native American/Alaska Native", "Other", "Multiple", "Unknown")))
flu.oi.race.dens <- flu.oi.race.dens %>% mutate(RACE_ETH = recode(RACE_ETH,
                                                                      "Native Am Alaskan" = "Native American/Alaska Native")) %>% mutate(RACE_ETH = factor(RACE_ETH, levels = c("White", "Asian", "Black", "Hispanic", "Pacific Islander", "Native American/Alaska Native", "Other", "Multiple", "Unknown")))
flu_race_plots <- create_inset_plot(flu.oi.race.probs, flu.oi.race.dens, RACE_ETH, legend_margin = 0)
flu_race_plots

flu.oi.vax.probs <- flu.oi.vax.probs %>% mutate(flu_vac = recode(flu_vac,
                                                                       "0" = "Unvacccinated",
                                                                       "1" = "Vaccinated"
)) %>% mutate(flu_vac = factor(flu_vac, levels = c("Unvacccinated", "Vaccinated")))
flu.oi.vax.dens <- flu.oi.vax.dens %>% mutate(flu_vac = recode(flu_vac,
                                                                     "0" = "Unvacccinated",
                                                                     "1" = "Vaccinated"
)) %>% mutate(flu_vac = factor(flu_vac, levels = c("Unvacccinated", "Vaccinated")))
flu_vax_plots <- create_inset_plot(flu.oi.vax.probs, flu.oi.vax.dens, flu_vac, legend_margin = 52)
flu_vax_plots

flu.oi.ndi.probs <- flu.oi.ndi.probs %>% mutate(NDI_group = recode(NDI_group,
                                                                       "<-1" = "Below -1",
                                                                       "-1 - 0" = "-1 ≤ NDI < 0",
                                                                       "0 - 1" = "0 ≤ NDI < 1",
                                                                       ">1" = "Above 1")) %>% mutate(NDI_group = factor(NDI_group, levels = c("Below -1", "-1 ≤ NDI < 0", "0 ≤ NDI < 1", "Above 1")))
flu.oi.ndi.dens <- flu.oi.ndi.dens %>% mutate(NDI_group = recode(NDI_group,
                                                                     "<-1" = "Below -1",
                                                                     "-1 - 0" = "-1 ≤ NDI < 0",
                                                                     "0 - 1" = "0 ≤ NDI < 1",
                                                                     ">1" = "Above 1")) %>% mutate(NDI_group = factor(NDI_group, levels = c("Below -1", "-1 ≤ NDI < 0", "0 ≤ NDI < 1", "Above 1")))
flu_ndi_plots <- create_inset_plot(flu.oi.ndi.probs, flu.oi.ndi.dens, NDI_group, legend_margin = 50)
flu_ndi_plots

flu.oi.cw.probs <- flu.oi.cw.probs %>% mutate(cw_group = recode(cw_group,
                                                                    "6+" = "≥6"))
flu.oi.cw.dens <- flu.oi.cw.dens %>% mutate(cw_group = recode(cw_group,
                                                                  "6+" = "≥6"))
flu_cw_plots <- create_inset_plot(flu.oi.cw.probs, flu.oi.cw.dens, cw_group)
flu_cw_plots


flu_figure3 <- grid.arrange(outpatient.text, inpatient.text,
                        age.text, flu_age_plots, 
                        gender.text, flu_gender_plots, 
                        race.text, flu_race_plots, 
                        flu.vac.text, flu_vax_plots,
                        ndi.text, flu_ndi_plots,
                        cw.text, flu_cw_plots,
                        layout_matrix = cbind(c(1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14), c(1, NA, 4, NA, 6, NA, 8, NA, 10, NA, 12, NA, 14), c(2, NA, 4, NA, 6, NA, 8, NA, 10, NA, 12, NA, 14)), 
                        widths = c(0.2, 0.15, 0.65), 
                        heights = c(0.4, 0.4, 1.2, 0.4, 1.2, 0.4, 1.2, 0.4, 1.2, 0.4, 1.2, 0.4, 1.2))



ggsave("flu_figure_3.png", plot = flu_figure3, width = 10, height = 10)


###########
###########
###### repeat for RSV
###########
###########


#load in required datasets
load(file = "Figure_code/R_objects/rsv.oi.age.probs")
load(file = "Figure_code/R_objects/rsv.oi.gender.probs")
load(file = "Figure_code/R_objects/rsv.oi.vax.probs")
load(file = "Figure_code/R_objects/rsv.oi.ndi.probs")
load(file = "Figure_code/R_objects/rsv.oi.cw.probs")
load(file = "Figure_code/R_objects/rsv.oi.age.dens")
load(file = "Figure_code/R_objects/rsv.oi.gender.dens")
load(file = "Figure_code/R_objects/rsv.oi.vax.dens")
load(file = "Figure_code/R_objects/rsv.oi.ndi.dens")
load(file = "Figure_code/R_objects/rsv.oi.cw.dens")


rsv.vac.text = ggplot() +
  annotate("text", x = 0.2,  y = 1,
           size = 3,
           label = "RSV vaccination", 
           fontface = "bold",
           hjust = 0) +
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1.5), expand = FALSE) +
  theme_void() 

rsv_age_plots <- create_inset_plot(rsv.oi.age.probs, rsv.oi.age.dens, age_group)
rsv_age_plots

rsv.oi.gender.probs <- rsv.oi.gender.probs %>% mutate(GENDER = recode(GENDER, "M" = "Male", "F" = "Female")) %>% mutate(GENDER = factor(GENDER, levels = c("Male", "Female")))
rsv.oi.gender.dens <- rsv.oi.gender.dens %>% mutate(GENDER = recode(GENDER, "M" = "Male", "F" = "Female")) %>% mutate(GENDER = factor(GENDER, levels = c("Male", "Female")))
rsv_gender_plots <- create_inset_plot(rsv.oi.gender.probs, rsv.oi.gender.dens, GENDER)
rsv_gender_plots

rsv.oi.vax.probs <- rsv.oi.vax.probs %>% mutate(rsv_vac = recode(rsv_vac,
                                                                 "0" = "Unvacccinated",
                                                                 "1" = "Vaccinated"
)) %>% mutate(rsv_vac = factor(rsv_vac, levels = c("Unvacccinated", "Vaccinated")))
rsv.oi.vax.dens <- rsv.oi.vax.dens %>% mutate(rsv_vac = recode(rsv_vac,
                                                               "0" = "Unvacccinated",
                                                               "1" = "Vaccinated"
)) %>% mutate(rsv_vac = factor(rsv_vac, levels = c("Unvacccinated", "Vaccinated")))
rsv_vax_plots <- create_inset_plot(rsv.oi.vax.probs, rsv.oi.vax.dens, rsv_vac, legend_margin = 52)
rsv_vax_plots

rsv.oi.ndi.probs <- rsv.oi.ndi.probs %>% mutate(NDI_group = recode(NDI_group,
                                                                   "<-1" = "Below -1",
                                                                   "-1 - 0" = "-1 ≤ NDI < 0",
                                                                   "0 - 1" = "0 ≤ NDI < 1",
                                                                   ">1" = "Above 1")) %>% mutate(NDI_group = factor(NDI_group, levels = c("Below -1", "-1 ≤ NDI < 0", "0 ≤ NDI < 1", "Above 1")))
rsv.oi.ndi.dens <- rsv.oi.ndi.dens %>% mutate(NDI_group = recode(NDI_group,
                                                                 "<-1" = "Below -1",
                                                                 "-1 - 0" = "-1 ≤ NDI < 0",
                                                                 "0 - 1" = "0 ≤ NDI < 1",
                                                                 ">1" = "Above 1")) %>% mutate(NDI_group = factor(NDI_group, levels = c("Below -1", "-1 ≤ NDI < 0", "0 ≤ NDI < 1", "Above 1")))
rsv_ndi_plots <- create_inset_plot(rsv.oi.ndi.probs, rsv.oi.ndi.dens, NDI_group, legend_margin = 50)
rsv_ndi_plots

rsv.oi.cw.probs <- rsv.oi.cw.probs %>% mutate(cw_group = recode(cw_group,
                                                                "6+" = "≥6"))
rsv.oi.cw.dens <- rsv.oi.cw.dens %>% mutate(cw_group = recode(cw_group,
                                                              "6+" = "≥6"))
rsv_cw_plots <- create_inset_plot(rsv.oi.cw.probs, rsv.oi.cw.dens, cw_group)
rsv_cw_plots


rsv_figure3 <- grid.arrange(outpatient.text, inpatient.text,
                            age.text, rsv_age_plots, 
                            gender.text, rsv_gender_plots, 
                            rsv.vac.text, rsv_vax_plots,
                            ndi.text, rsv_ndi_plots,
                            cw.text, rsv_cw_plots,
                            layout_matrix = cbind(c(1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12), c(1, NA, 4, NA, 6, NA, 8, NA, 10, NA, 12), c(2, NA, 4, NA, 6, NA, 8, NA, 10, NA, 12)), 
                            widths = c(0.2, 0.15, 0.65), 
                            heights = c(0.4, 0.4, 1.2, 0.4, 1.2, 0.4, 1.2, 0.4, 1.2, 0.4, 1.2))



figure3


ggsave("rsv_figure_3.png", plot = rsv_figure3, width = 10, height = 10)








###########
###########
#### Charlson comorbity table
###########
###########

cw_counts <- ari.combined %>% group_by(studyid) %>%
  summarize(`MI in prior year` = sum(icdx_e_ch_mi == 1),
            `CHF in prior year` = sum(icdx_e_ch_chf == 1),
            `PVD in prior year` = sum(icdx_e_ch_pvd == 1),
            `CEVD` = sum(icdx_e_ch_cevd == 1),
            `Dementia` = sum(icdx_e_ch_dem == 1),
            `COPD` = sum(icdx_e_ch_copd == 1),
            `Rheumatic disease` = sum(icdx_e_ch_rheum == 1),
            `Peptic ulcer disease` = sum(icdx_e_ch_pud == 1),
            `Diabetes with complications` = sum(icdx_e_ch_diab_c == 1),
            `Paraplegic` = sum(icdx_e_ch_para == 1),
            `Renal disease` = sum(icdx_e_ch_rd == 1),
            `Mild/severe liver disease` = sum(icdx_e_ch_msld == 1),
            `Metastatic cancer` = sum(icdx_e_ch_mets == 1),
            `HIV` = sum(icdx_e_ch_hiv == 1),
            `Diabetes without complications` = sum(icdx_e_ch_diab_nc == 1),
            `Mild Liver Disease` = sum(icdx_e_ch_mildld == 1),
            `Cancer` = sum(icdx_e_ch_cancer == 1))


my.vars <- c("icdx_e_ch_mi", "icdx_e_ch_chf", "icdx_e_ch_pvd","icdx_e_ch_cevd","icdx_e_ch_dem","icdx_e_ch_copd" ,"icdx_e_ch_rheum" , "icdx_e_ch_pud" ,"icdx_e_ch_diab_c", "icdx_e_ch_para",
             "icdx_e_ch_rd", "icdx_e_ch_msld" ,"icdx_e_ch_mets" , "icdx_e_ch_hiv",
             "icdx_e_ch_diab_nc"  ,  "icdx_e_ch_mildld"    , "icdx_e_ch_cancer")

# create a list of which ones are categorical (factor)
factor.vars <- c("icdx_e_ch_mi", "icdx_e_ch_chf", "icdx_e_ch_pvd","icdx_e_ch_cevd","icdx_e_ch_dem","icdx_e_ch_copd" ,"icdx_e_ch_rheum" , "icdx_e_ch_pud" ,"icdx_e_ch_diab_c", "icdx_e_ch_para",
                 "icdx_e_ch_rd", "icdx_e_ch_msld" ,"icdx_e_ch_mets" , "icdx_e_ch_hiv",
                 "icdx_e_ch_diab_nc"  ,  "icdx_e_ch_mildld"    , "icdx_e_ch_cancer")

one_per <- ari.combined %>% group_by(studyid) %>% 
  filter(any(str_detect(Flu_A, 'POSITIVE')) | any(str_detect(Flu_B, 'POSITIVE')) | any(str_detect(Flu, 'POSITIVE')) | any(str_detect(RSV_A, 'POSITIVE')) | any(str_detect(RSV_B, 'POSITIVE')) | any(str_detect(RSV, 'POSITIVE')) | any(str_detect(COVID, 'POSITIVE'))) %>% slice(1)

table.1.cw <- CreateTableOne(vars = my.vars,
                              factorVars = factor.vars,
                              data = one_per, includeNA=TRUE,
                              test=FALSE, addOverall=F) # No p-values in Table 1!
table.1.cw

print(table.1.cw, exact = "stage", quote = TRUE, noSpaces = TRUE)



