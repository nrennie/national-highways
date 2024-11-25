library(ggplot2)
library(lubridate)
library(dplyr)
library(hms)
library(tidyr)
library(ggtext)

# read in data
daily <- readr::read_csv("data/daily_report_7090_26Jun2023.csv")

# all time intervals
all_times <- data.frame(TimeGroup = seq(
  from=as.POSIXct("2023-06-26 00:00:00","%Y-%m-%d %H:%M:%S", tz="UTC"),
  to=as.POSIXct("2023-06-26 23:50:00", "%Y-%m-%d %H:%M:%S", tz="UTC"),
  by="15 min"
)) |> 
  mutate(TimeGroup = as_hms(TimeGroup))

# average speed per interval
speed_data <- daily |> 
  mutate(DayOfWeek = lubridate::wday(`Report Date`, label = TRUE, week_start = 1), 
         .after = `Report Date`,
         TimeGroup = trunc_hms(as_hms(`Time Period Ending`), 60*15)) |> 
  group_by(DayOfWeek, TimeGroup) |> 
  summarise(avg_speed = mean(`Avg mph`, na.rm = TRUE)) |> 
  right_join(all_times, by = "TimeGroup")

# heat map of speed
ggplot(data = speed_data) +
  geom_tile(mapping = aes(x = TimeGroup, y = DayOfWeek, fill = avg_speed)) +
  scale_y_discrete(limits = rev) +
  scale_fill_distiller(name = "Average Speed (mph)", palette = "OrRd",
                       direction = 1, limits = c(50, 75)) +
  labs(x = "", y = "",
       title = "Average speed observed at TAME Site 30361533 on link M6 northbound between J33 and J34",
       subtitle = "Week commencing 19 June 2023") +
  coord_cartesian(expand = FALSE) +
  guides(fill = guide_colourbar(title.position="top", title.hjust = 0.5, barwidth = 25, barheight = 0.7)) +
  theme_minimal(base_size = 10) +
  theme(legend.position = "bottom",
        plot.title.position = "plot",
        legend.title = element_text(margin = margin(t = -10)),
        plot.title = element_textbox_simple(face = "bold", margin = margin(b = 5)),
        plot.margin = margin(10, 10, 10, 10))

# save
ggsave("plots/daily_reports.png", dpi = 300, width = 6, height = 4, unit = "in", bg = "white")
