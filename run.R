# setup
# clear the environment
rm(list = grep("^current_date", ls(), value = TRUE, invert = TRUE))

DATA_DIR <- './data'
IMAGES_DIR <- './images'
OUTPUT_DIR <- './output'

## function that concatenates strings (useful for directory paths)
concat <- function(x1,x2) {
    result <- paste(x1,x2,sep="")
    return(result)
}

## function that checks to see if a package is installed and,if not,installs it
## portions of this code came from http://stackoverflow.com/questions/9341635/how-can-i-check-for-installed-r-packages-before-running-install-packages
load_package <- function(x) {
    if (x %in% rownames(installed.packages())) { 
        print(concat("package already installed: ", x))
    }
    else { 
        install.packages(x) 
    }
    library(x, character.only=TRUE)
}

# get the data
# check to see if data is already downloaded
# if not, download it and save it to the data directory
csv_file <- concat(DATA_DIR, '/Wholesale%20customers%20data.csv')
if (file.exists(csv_file)) {
    D <- read.csv(csv_file)
} else {
    URL <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00292/Wholesale%20customers%20data.csv"
    current_date <- date()
    download.file(url=URL, 
                  destfile=csv_file, 
                  quiet=TRUE,
                  mode = "wb")
    D <- read.csv(csv_file)
}
rm(csv_file)

# how many are n/a?
sum(is.na(D))
head(which(is.na(D)))
sum(is.null(D))
length(which(D == ""))
length(which(!complete.cases(D)))
str(D)

D$Channel <- as.factor(D$Channel)
D$Region <- as.factor(D$Region)
str(D)
summary(D)

load_package('dplyr')
p <- length(D[,1])
grouped <- group_by(D[,-1], D$Channel)
grouped_summary <- data.frame(summarise(grouped, n=n()))
grouped_summary$pct <- grouped_summary$n / p
print(grouped_summary)
rm(p)
rm(grouped_summary)
# Channel 1 is 68% of the observations

p <- length(D[,1])
grouped <- group_by(D[,-2], D$Region)
grouped_summary <- data.frame(summarise(grouped, n=n()))
grouped_summary$pct <- grouped_summary$n / p
print(grouped_summary)
rm(p)
rm(grouped_summary)
# Region 3 is 72% of the observations; may want to focus on this one

load_package('car')
scatterplotMatrix(D[,3:8])
# looks like some transformations need to take place
