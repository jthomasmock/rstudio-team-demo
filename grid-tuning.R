library(tidymodels)
library(mlbench)
data(Ionosphere)


# Inputs for the Search ---------------------------------------------------

svm_mod <-
  svm_rbf(cost = tune(), rbf_sigma = tune()) %>%
  set_mode("classification") %>%
  set_engine("kernlab")


# Recipe ------------------------------------------------------------------

iono_rec <-
  recipe(Class ~ ., data = Ionosphere)  %>%
  # remove any zero variance predictors
  step_zv(all_predictors()) %>% 
  # remove any linear combinations
  step_lincomb(all_numeric())

set.seed(4943)
iono_rs <- bootstraps(Ionosphere, times = 30)


# Options -----------------------------------------------------------------

roc_vals <- metric_set(roc_auc)
ctrl <- control_grid(verbose = TRUE, save_pred = TRUE)

set.seed(35)
formula_res <-
  svm_mod %>% 
  tune_grid(
    Class ~ .,
    resamples = iono_rs,
    metrics = roc_vals,
    control = ctrl
  )
formula_res


# Estimates ---------------------------------------------------------------

estimates <- collect_metrics(formula_res)

show_best(formula_res, metric = "roc_auc")


# Executing with a recipe -------------------------------------------------

set.seed(325)
recipe_res <-
  svm_mod %>% 
  tune_grid(
    iono_rec,
    resamples = iono_rs,
    metrics = roc_vals,
    control = ctrl
  )
recipe_res

show_best(recipe_res, metric = "roc_auc")
