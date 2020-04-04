# Work.R - Test ideas

# source("Prep.R")


library(lubridate)
library(dplyr)
library(ggplot2)

cov <- readRDS("cov.rds")

last.report <- max(cov$date)

# Sample values
country <- "Spain"
end.new <- date("2020-03-30")
newdays <- 7


# Calculations
country.df <- cov %>%
    filter(country == country) %>%
    select(date, cases)
start.new <- end.new - newdays + 1
newcases <- filter(country.df, between(date, start.new, end.new))
prevcases <- filter(country.df, date < start.new)
newcasecnt = sum(newcases$cases)
prevcasecnt <- sum(prevcases$cases)
min.date <- min(country.df$date)


# Sample plots
country.df$status = "Prev"
country.df$status[country.df$date >= start.new] <- "New"

p <- ggplot(country.df, aes(date, cases)) + 
    geom_col(aes(fill = status)) + 
    labs(title = "Cases Reported by Date")


# Donut chart (code adapted from https://www.r-graph-gallery.com/128-ring-or-donut-plot.html)

data <- data.frame(
    category = c("New", "Prev"),
    count = c(newcasecnt, prevcasecnt)
)

# Compute percentages
data$fraction <- data$count / sum(data$count)

# Compute the cumulative percentages (top of each rectangle)
data$ymax <- cumsum(data$fraction)

# Compute the bottom of each rectangle
data$ymin <- c(0, head(data$ymax, n=-1))

# Compute label position
data$labelPosition <- (data$ymax + data$ymin) / 2

# Compute a good label
data$label <- paste0(data$category, "\n value: ", data$count)

# Make the plot
ggplot(data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=category)) +
    geom_rect() +
    geom_text( x=2, aes(y=labelPosition, label=label, color=category), size=6) + # x here controls label position (inner / outer)
    scale_fill_brewer(palette=3) +
    scale_color_brewer(palette=3) +
    coord_polar(theta="y") +
    xlim(c(-1, 4)) +
    theme_void() +
    theme(legend.position = "none")

ggplot(data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=category)) +
    geom_rect() +
    geom_text( x=2, aes(y=labelPosition, label=label), size=6) + # x here controls label position (inner / outer)
    scale_fill_brewer(palette=3) +
    scale_color_brewer(palette=3) +
    coord_polar(theta="y") +
    xlim(c(-1, 4)) +
    theme_void() +
    theme(legend.position = "none") +
    scale_color_manual(values = c("lightred", "lightblue"), aesthetics = c("color", "fill"))

ggplot(data, aes(ymax=ymax, ymin=ymin, xmax=4, xmin=3, fill=category)) +
    geom_rect() +
    geom_text( x=2, aes(y=labelPosition, label=label), size=6) + # x here controls label position (inner / outer)
    scale_color_manual(values = c("#D55E00", "#56B4E9"), aesthetics = c("color", "fill")) +
    coord_polar(theta="y") +
    xlim(c(-1, 4)) +
    theme_void() +
    theme(legend.position = "none")


