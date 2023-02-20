# Note that each row here is a *mention* and NOT an article or story.
# This means that one story may appear as multiple rows in this data frame.
#Some cases in which an article may appear twice in this data frame:
## Article mentions incumbents in two different jurisdictions.
## Article mentions incumbent and challenger in the same jurisdiction
## Article mentions multiple challengers in the same jurisdiction

incs_for_binding <- incumbents %>%
  filter(duplicative_publication_of_previous_article=="0" |  #next line is for Devinney
           is.na(date_of_article)) %>%
  mutate(candidate_status ="incumbent") %>%
  rename(c(candidate_name = prosecutor_name,
           type_of_candidate_mention = type_of_prosecutor_mention,
           tenor_tone_of_article_re_candidate = tenor_tone_of_article_re_prosecutor)) %>%
  select(1, 21:22, 24, 2:7, 9:10, 13, 17)




nincs_for_binding <- non_incumbents %>%
  filter(duplicative_publication_of_previous_article=="0") %>%
  mutate(candidate_status ="challenger") %>%
  select(1, 16:18, 2:7, 9, 11:12, 14)


all_mentions <- bind_rows(incs_for_binding, nincs_for_binding)
