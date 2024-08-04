# Chandipura Virus Outbreak Tracking

# Load Required Packages --------------------------------------------------

pacman::p_load(rio, #for data import and export
               here, # for defining filepaths
               tidyverse, #data wrangling and basic visualization
               rnaturalearth #for obtaining and working with map data
               )

# Get the shapefile of India
india <- ne_states(country = "India", returnclass = "sf")

# Case Data Import -------------------------------------------------------------
chpv_trend <- import("CHPV-outbreak-tracking/chpv-trend.csv")

all_chandipura_metadata <- import("CHPV-outbreak-tracking/all_chandipura_metadata.tsv") %>% 
  # Making sure there are no rows missing critical data 
  filter(!is.na(strain) & !is.na(region) & !is.na(country)) %>% 
  # cleaning some missing and/or misformatted data columns 
  mutate(division = ifelse(is.na(division) | division == "", "Unknown", division),
         location = ifelse(is.na(location) | location == "", "Unknown", location),
         country = ifelse(is.na(country) | country == "", "Unknown", country), ## replacing missing country with "Unknown"
         host = ifelse(host == "", "Unknown", host),
         region = ifelse(submitter_country == "India", "Asia", region),
         region = ifelse(region =="", "Unknown", region)) %>% 
  # Cleaning the date column
  mutate(date = case_when(
    date == "XXXX-XX-XX" ~ as.character(date_released), ## if date is "XXXX-XX-XX", replace it with date_released
    grepl("^\\d{4}-XX-XX$", date) ~ paste0(substr(date, 1, 4), "-06-30"), ## if date is in "YYYY-XX-XX" format, replace the "XXXX" part with "06-30", assuming mid-year
    grepl("^\\d{4}-\\d{2}-XX$", date) ~ paste0(substr(date, 1, 7), "-15"), ## if date is in "YYYY-MM-XX" format, replace the "XX" part with "15", assuming mid-month
    TRUE ~ date ), ## if none of the above conditions are met, keep the date as it is
    date = ymd(date), ## convert the date column to Date type
    year = year(date), ## extract the year from the cleaned date
    date_released = ymd(date_released), 
    date_updated = ymd(date_updated))

# Exporting the cleaned metadata

export(all_chandipura_metadata, "all_chandipura_metadata_cleaned.csv")


# Data Visualization  -----------------------------------------------------

# Summarize the data to get the count of genomes per year per country
genome_counts <- all_chandipura_metadata %>%
  group_by(year, country) %>%
  summarise(count = n()) %>%
  ungroup()

# Plot the number of genomes per year per country
ggplot(genome_counts, aes(x = year, y = count, fill = country)) +
  geom_col(position = "stack") +
  theme_minimal() +
  labs(title = "Chandipura Viral Genomes in NCBI GenBank by Year and Country",
       x = "Year",
       y = "Number of Genomes",
       fill = "Country") +
  theme(
    plot.title = element_text(hjust = 0.5, size = 20, face = "bold"),
    axis.title = element_text(size = 16),
    axis.text = element_text(size = 14),
    legend.title = element_text(size = 14),
    legend.text = element_text(size = 12)) 

# Export the plot

ggsave("chandipura_genomes_by_year_country.png", width = 10, height = 6, dpi = 300)



# Merge the cases data with the shapefile data
india_chpv_cases <- merge(india, chpv_trend, by.x = "name", by.y = "state", all.x = TRUE)

# Replace NA values with 0
india_chpv_cases$total_cases[is.na(india_chpv_cases$total_cases)] <- 0

# Plot the cases
ggplot(data = india_chpv_cases) +
  geom_sf(aes(fill = total_cases)) +
  scale_fill_gradient(low = "white", high = "red", name = "Chandipura Virus Cases") +
  labs(title = "Cases by State",
       caption = "Data Source: @BrendanMIRROR, according to the health bulletin of Ministry of Health and Family Welfare (accessed on August 4, 2024)") +
  theme_minimal()


# Export the plot

ggsave("chandipura_cases_by_state.png", width = 10, height = 6, dpi = 300)



