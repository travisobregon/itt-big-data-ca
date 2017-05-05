install.packages("ggplot2")

library(readr)
library(ggplot2)
library(scales)

salaries.discrimination <- read_csv("C:/Users/TravisO/Downloads/Big Data/salaries_discrimination.csv")  

# Adjust columns to comply with Google's R style guide.
names(salaries.discrimination)[names(salaries.discrimination) == "Job Title"] <- "job.title"
names(salaries.discrimination)[names(salaries.discrimination) == "Male Average Pay"] <- "male.avg.pay"
names(salaries.discrimination)[names(salaries.discrimination) == "Female Average Pay"] <- "female.avg.pay"
names(salaries.discrimination)[names(salaries.discrimination) == "Discrimination\t"] <- "discrimination"

# Trim tabs and set the column to be a factor
salaries.discrimination$discrimination <- trimws(salaries.discrimination$discrimination)
salaries.discrimination$discrimination <- as.factor(salaries.discrimination$discrimination)

View(salaries.discrimination)

summary(salaries.discrimination)

# 63% of jobs showed no discrimination

cor(salaries.discrimination$male.avg.pay, salaries.discrimination$female.avg.pay) # 0.8824544
plot(x = salaries.discrimination$male.avg.pay,	
     y = salaries.discrimination$female.avg.pay,
     main	=	"Scatterplot of Male Avg. Pay vs. Female Avg. Pay",
     xlab	= "Male Avg. Pay ($)", 
     ylab	=	"Female Avg. Pay ($)") +
     abline(lm(salaries.discrimination$male.avg.pay ~ salaries.discrimination$female.avg.pay), col = "blue")

# 414 jobs pay females more than males
higher.female.avg.pay.jobs <- subset(salaries.discrimination, 
                                     salaries.discrimination$female.avg.pay > salaries.discrimination$male.avg.pay)
# 586 jobs pay males more than females
higher.male.avg.pay.jobs <- subset(salaries.discrimination, 
                                   salaries.discrimination$male.avg.pay > salaries.discrimination$female.avg.pay)

# 1 job pays males and females equally

# Find the difference in total pay for each job
salaries.discrimination <- transform(salaries.discrimination, 
                                     total.pay.difference = male.avg.pay - female.avg.pay)

# If we find the difference between all the total pay averages it is $2,456,511.89
total.pay.difference <- sum(salaries.discrimination$total.pay.difference)

# If we find the mean of the total.pay.difference we see that 
# it is $2454.058, which is less than our $5,000 threshold
avg.total.pay.difference <- mean(salaries.discrimination$total.pay.difference)
