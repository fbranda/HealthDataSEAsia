## Data schema


| Field                 | Format                       |Description                      
|-----------------------------|-----------------------------------|-------------------------------|
**data**      | YYYY-MM-DD  | Date of publication of epidemiological data    | 
**state**      | String       | Name of the specific state where the outbreak occurred  |
**district**      | String       | Name of administrative district of the `state` where the data were collected |
**lat**      | Numeric       | Latitude of the `district` where the data were collected |
**lon**      | Numeric       | Longitude of the `district` where the data were collected  |
**total_cases**      | Numeric       | Total number of cases reported in the districts  |
**total_deaths**      | Numeric       | Total number of deaths reported in the districts  |
**patients_admitted_hospitals**      | Numeric       | Number of patients admitted to hospitals  |
**children_discharged**      | Numeric       | Number of children discharged from hospitals  |
**mortality_rate_percent**      | Numeric       | Total percentage mortality rate since the beginning of the outbreak   |
**chpv_cases**      | Numeric       | Number of confirmed cases of Chandipura Virus  |
**chpv_deaths**      | Numeric       | Number of confirmed deaths of Chandipura Virus  |
**enterovirus_cases**      | Numeric       | Number of confirmed cases of Enterovirus  |
**source**      | String       | URL of the source of the epidemiological data  |




## License and attribution

This repository and data exports are published under the CC BY 4.0 license.

