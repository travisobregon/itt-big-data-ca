install.packages("gender")

library(readr)
library(reshape2)
library(gender)

# Import the salaries data set and remove unnecessary columns.
salaries <- read_csv(
  "C:/Users/TravisO/Desktop/salaries.csv", 
  col_types = cols(
    Agency = col_skip(), 
    BasePay = col_skip(), 
    Benefits = col_skip(), 
    Id = col_skip(), 
    Notes = col_skip(), 
    OtherPay = col_skip(), 
    OvertimePay = col_skip(), 
    Status = col_skip(), 
    TotalPay = col_skip()
  )
)

# Adjust columns to comply with Google's R style guide.
names(salaries)[names(salaries) == "EmployeeName"] <- "employee.name"
names(salaries)[names(salaries) == "JobTitle"] <- "job.title"
names(salaries)[names(salaries) == "TotalPayBenefits"] <- "total.pay"
names(salaries)[names(salaries) == "Year"] <- "year"

# Only include salaries that are greater than $10,000.
salaries <- subset(salaries, total.pay > 10000.0)

# Function to convert the first letter in each word to uppercase.
capwords <- function(s, strict = FALSE) {
  cap <- function(s) paste(toupper(substring(s, 1, 1)),
                           {s <- substring(s, 2); if(strict) tolower(s) else s},
                           sep = "", collapse = " " )
  sapply(strsplit(s, split = " "), cap, USE.NAMES = !is.null(names(s)))
}

salaries$employee.name <- capwords(tolower(salaries$employee.name))
salaries$job.title <- toupper(salaries$job.title)

# Determine each employee's first name.
salaries$first.name <- colsplit(string = salaries$employee.name, pattern = " ", names = c("first.name", "last.name"))$first.name

# The maximum year for the gender_df function is 2012.
# So for years 2013 and 2014, set the year to 2012.
salaries$year <- ifelse(salaries$year > 2012, 2012, salaries$year)

# Determine each employee's gender.
genderdf <- gender_df(salaries, name_col = "first.name", year_col = "year", method = "ssa")
salaries$gender <- genderdf$gender[match(salaries$first.name, genderdf$name)]
salaries$gender <- as.factor(salaries$gender)

# Remove rows where the gender for the employee is NA.
salaries <- subset(salaries, !is.na(salaries$gender))

# Clean up
rm(genderdf)
salaries$employee.name <- NULL
salaries$year <- NULL
salaries$first.name <- NULL

summary(salaries)
# job.title         | total.pay      | gender
# =================================================
# Length :115597    | Min.   : 10002 | female:48671  
# Class  :character | 1st Qu.: 67971 | male  :66926  
# Mode   :character | Median :103109 |                
# Mean   :107327    |                |
# 3rd Qu.:141741    |                |
# Max.   :567595    |                |

# Boxplot of Salaries by Gender
boxplot(salaries$total.pay ~ salaries$gender, 
        main = "Boxplot of Salaries by Gender", 
        xlab = "Genders", 
        ylab = "Total Pay ($)",
        las = 1,
        options(scipen = 1),
        par(mar = c(7,7,4,2) + 0.1, mgp=c(5,1,0)))

male.salaries <- subset(salaries, salaries$gender == "male")
female.salaries <- subset(salaries, salaries$gender == "female")

# Histogram of Male Salaries (Right skew)
hist(male.salaries$total.pay, 
     main = "Histogram of Male Salaries", 
     xlab = "Total Pay")

# Histogram of Female Salaries (Right skew)
hist(female.salaries$total.pay, 
     main = "Histogram of Female Salaries", 
     xlab = "Total Pay")

mean(male.salaries$total.pay) # $115029.70
mean(female.salaries$total.pay) # $96735.46

summary(male.salaries$total.pay)
summary(female.salaries$total.pay)

# Create a text file of the preprocessed data
write.table(salaries, 
            file = "C:/Users/TravisO/Downloads/Big Data/salaries.txt",
            quote = FALSE,
            sep = "\t",
            row.names = FALSE,
            col.names = FALSE)
