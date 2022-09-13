setwd(dirname(rstudioapi::getSourceEditorContext()$path))
getwd()
CSM.data.continuous <- read.csv("ATR_CSM_Continuous_Overall.csv")


### Define all visits
visits <- c(
  "SCR",
  "BLT1",
  "BLT2",
  "T2",
  "T3",
  "T4",
  "T5",
  "T6",
  "EoTRT",
  "FUP1",
  "FUP2",
  "FUP3",
  "FUP4",
  "FUP5",
  "FUP6",
  "FUP7",
  "FUP8",
  "FUP9",
  "FUP10",
  "SURV")

### Define visit names
visit.names <- c(
  "Screening",
  "Baseline",
  "Treatment - T1",
  "Treatment - T2",
  "Treatment - T3",
  "Treatment - T4",
  "Treatment - T5",
  "Treatment - T6",
  "End of treatment",
  "Follow-up 1",
  "Follow-up 2",
  "Follow-up 3",
  "Follow-up 4",
  "Follow-up 5",
  "Follow-up 6",
  "Follow-up 7",
  "Follow-up 8",
  "Follow-up 9",
  "Follow-up 10",
  "Survival follow-up")
### Define variables for continuous analysis
continuous.vars <- c(
  "VS_RESP_VAL", # Respiratory rate
  "VS_SPO2_VAL", # Oxygen saturation
  "VS_SYSBP_VAL", # Systolic blood pressure
  "VS_DIABP_VAL", # Diastolic blood pressure
  "VS_PULSE_VAL", # Pulse
  "VS_TEMP_VAL", # Temperature
  "PRD_VAS_VAL" # Degree of dyspnea [VAS]
)

continuous.names <- c(
  "Respiratory rate",
  "Oxygen saturation",
  "Systolic blood pressure",
  "Diastolic blood pressure",
  "Pulse",
  "Temperature",
  "Degree of dyspnea [VAS]"
)

continuous.units <- c(
  "breaths/min",
  "%",
  "mmHg",
  "mmHg",
  "bpm",
  "°C",
  " "
)


### Define variables for ordinal analysis
ordinal.vars <- c(
  "CSS_VAL", # Clinical severity status
  "VS_GCS_VAL", # Glasgow Coma Scale
  "PRD_LIK_VAL", # Degree of dyspnea [Likert]
  "VS_NEWS2" # NEWS2 score
)

### Define variables for dicotomous analysis
dichotomous.vars <- c(
  "VS_SUPOX_VAL" # Need fopr supplemental oxygen
)

#### General study settings
### Define checks
CSM.checks <- data.frame(
  Check.txt = c(  "Raw value compared to raw values of respective visit",
                  "Change from baseline compared to change from baseline of entire dataset",
                  "Change from previous visit compared to change from previous visit of entire dataset",
                  "Raw value compared to raw values of respective visit at respective site",
                  "Raw value compared to raw values of respective visit at all other sites"),
  F.Check = c("F1", "F2", "F3", "F4", "F5")
)


CSM.meta.continuous <- data.frame(
  item = continuous.vars,
  name = continuous.names,
  unit = continuous.units
)

sites <- unique(CSM.data.continuous$site_code)
modules <- CSM.meta.continuous$item

site.modules.cont <- data.frame(items = CSM.meta.continuous$item, type = "cont")
site.modules.cat <- data.frame(items = c("CatVar1", "CatVar2", "CatVar3") , type = "cat")
site.modules.ord <- data.frame(items = c("OrdVar1", "OrdVar2", "OrdVar3") , type = "ord")




#modules <- continuous.vars
