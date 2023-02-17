incumbents_contest <- incumbents %>% 
  group_by(state, contest) %>%
  summarize(incumbents = n_distinct(prosecutor_name))

challengers_contest <- non_incumbents %>%
  group_by(state, contest) %>%
  summarize(non_incumbents = n_distinct(candidate_name)) 

competitiveness <- full_join(incumbents_contest, challengers_contest, by=c("state","contest")) %>%
  mutate(type = case_when(
    is.na(non_incumbents) ~ "uncontested",
    is.na(incumbents) ~ "open",
    TRUE ~ "contested"
  ) )

#Added Feb. 4, 2023 to reflect five incumbents whose names appeared in our data, but who did not run for re-election.
competitiveness <- competitiveness %>%
  mutate(type = case_when(
    contest %in% c("Pima","Saline", "HoodRiver", "Niagara", "Clackamas") ~ "open",
    TRUE ~ type
  ))
