library(ggplot2)

# Read in data
sites_df <- readr::read_csv("data/sites.csv") |> 
  tibble::as_tibble() |> 
  sf::st_as_sf(coords = c("Longitude", "Latitude"), crs = 4277)

# UK Map from https://geoportal.statistics.gov.uk/datasets/ons::countries-december-2021-uk-buc/explore?location=55.216238%2C-3.316413%2C6.38
uk <- sf::st_read("data-raw/UK/CTRY_DEC_2021_UK_BUC.shp") 
england <- uk |> 
  dplyr::filter(CTRY21NM == "England")

# Plot map
ggplot() +
  geom_sf(data = england, fill = "#f5f5f5") +
  geom_sf(data = sites_df, mapping = aes(colour = Status), size = 0.7) +
  scale_colour_manual(values = c("Active" = "#014421", "Inactive" = "#FA9F42")) +
  labs(title = "National Highways Road Sensors",
       subtitle = "Locations of <span style='color: #014421;'>active</span> and 
       <span style='color: #FA9F42;'>inactive</span> road sensors.") +
  theme(legend.position = "none",
        plot.title = element_text(face = "bold"),
        plot.subtitle = ggtext::element_textbox_simple(margin = margin(b = 10)))

# save
ggsave("plots/sites.png", dpi = 300, width = 4, height = 5, unit = "in")
