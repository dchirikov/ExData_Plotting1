read.data <- function() {
   if (!file.exists('household_power_consumption.txt')) {
       datasetLink <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
       download.file(datasetLink, destfile='household_power_consumption.zip', method='curl')
       unzip('household_power_consumption.zip')
   }
   read.csv(file='household_power_consumption.txt', header=TRUE,sep=';', na.strings = "?")
}

household_power_consumption <- read.data()
household_power_consumption$Date.Time <- strptime(paste(household_power_consumption$Date,household_power_consumption$Time,sep=' '), '%d/%m/%Y %H:%M:%S', tz= 'UTC')
household_power_consumption$Date <- NULL
household_power_consumption$Time <- NULL
upper_lim <- strptime('2007-02-03 00:00:00', '%Y-%m-%d %H:%M:%S', tz='UTC')
lower_lim <- strptime('2007-02-01 00:00:00', '%Y-%m-%d %H:%M:%S', tz='UTC')
household_power_consumption_filtered <- household_power_consumption[which(household_power_consumption$Date.Time > lower_lim & household_power_consumption$Date.Time < upper_lim),]
hist(household_power_consumption_filtered$Global_active_power,col='red',xlab='Global Active Power (kilowatts)', main='Global Active Power')

plot(household_power_consumption_filtered$Date.Time,household_power_consumption_filtered$Global_active_power,main='',xlab='',ylab='Global Active Power (kilowatts)',type='n')
lines(household_power_consumption_filtered$Date.Time,household_power_consumption_filtered$Global_active_power)

