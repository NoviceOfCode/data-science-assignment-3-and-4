# Get current working directory
current_dir <- getwd()

# Set the relative file path
relative_path  <- "/data_clean/diabetes.csv"

# Combine the current directory with the relative path
file_path <- file.path(current_dir, relative_path)

# Load the CSV file
data <- read.csv(file_path)

# View the first few rows of the data
head(data)

# Load necessary libraries
library(dplyr)
library(ggplot2)

#FOR PART A
# Set seed for reproducibility
set.seed(45)

# Take a random sample of 25 observations
sample_data <- sample_n(data, 25)

# Calculate mean and highest Glucose values of the sample
sample_mean_glucose <- mean(sample_data$Glucose)
sample_highest_glucose <- max(sample_data$Glucose)


# Calculate population mean and highest Glucose values
population_mean_glucose <- mean(data$Glucose)
population_highest_glucose <- max(data$Glucose)


# Comparison plot
comparison <- data.frame(
  Statistic = c("Sample Mean Glucose", "Sample Highest Glucose", "Population Mean Glucose", "Population Highest Glucose"),
  Value = c(sample_mean_glucose, sample_highest_glucose, population_mean_glucose, population_highest_glucose)
)

ggplot(comparison, aes(x = Statistic, y = Value, fill = Statistic)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Comparison of Glucose Statistics",
       y = "Value",
       x = "Statistic")

#PART B
# Calculate 98th percentile of BMI for the sample
sample_98th_percentile_bmi <- quantile(sample_data$BMI, 0.98)

# Calculate 98th percentile of BMI for the population
population_98th_percentile_bmi <- quantile(data$BMI, 0.98)

# Comparison plot
comparison <- data.frame(
  Statistic = c("Sample 98th Percentile BMI", "Population 98th Percentile BMI"),
  Value = c(sample_98th_percentile_bmi, population_98th_percentile_bmi)
)

ggplot(comparison, aes(x = Statistic, y = Value, fill = Statistic)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Comparison of 98th Percentile BMI",
       y = "Value",
       x = "Statistic")

#PART C
# Caclulating statistics for BloodPressure
calculate_stats <- function(example_data) {
  mean_bp <- mean(example_data$BloodPressure)
  sd_bp <- sd(example_data$BloodPressure)
  percentile_bp <- quantile(example_data$BloodPressure, 0.95) # Using 95th percentile for comparison
  return(c(mean_bp, sd_bp, percentile_bp))
}

# Bootstrap resampling
num_samples <- 500
sample_size <- 150

bootstrap_stats <- replicate(num_samples, {
  sample_data <- sample_n(data, sample_size, replace = TRUE)
  calculate_stats(sample_data)
})

# Calculate average statistics across samples
avg_stats <- apply(bootstrap_stats, 1, mean)

# Calculate population statistics
population_stats <- calculate_stats(data)

# Create comparison plot
comparison <- data.frame(
  Statistic = c("Average Mean BloodPressure", "Average Standard Deviation BloodPressure", "95th Percentile BloodPressure"),
  Value = c(avg_stats[1], avg_stats[2], avg_stats[3]),
  Category = c(rep("Bootstrap Samples", 3), rep("Population", 3))
)

ggplot(comparison, aes(x = Statistic, y = Value, fill = Category)) +
  geom_bar(stat = "identity", position = "dodge") +
  theme_minimal() +
  labs(title = "Comparison of BloodPressure Statistics",
       y = "Value",
       x = "Statistic")
