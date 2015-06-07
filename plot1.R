# Write small function to read data for drawing
# will use defaults from assessment - 2007-02-01 and 2007-02-02 (uper bound will be 2007-02-03 00:00:00).
read.data <- function(stime = '2007-02-01 00:00:00',etime = '2007-02-03 00:00:00') {
    # not sure if we have txt data avaliable. If not - download and unzip it.
    if (!file.exists('household_power_consumption.txt')) {
        datasetLink <- 'https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip'
        download.file(datasetLink, destfile='household_power_consumption.zip', method='curl')
        unzip('household_power_consumption.zip')
    }
    # read csv data
    household_power_consumption <- read.csv(
        file='household_power_consumption.txt',
        header=TRUE,
        sep=';',
        na.strings = "?"
    )
    # Combine Data and Time raw into Data.Time and convert them to POSIXlt.
    # As we don't know what the timezone it is, concider UTC
    household_power_consumption$Date.Time <- strptime(
                        paste(
                            household_power_consumption$Date,
                            household_power_consumption$Time,
                            sep=' '
                        ),
                        '%d/%m/%Y %H:%M:%S', tz= 'UTC'
                    )
    # Delete Date and Time column
    household_power_consumption$Date <- NULL
    household_power_consumption$Time <- NULL
    # Subset data
    upper_lim <- strptime(etime, '%Y-%m-%d %H:%M:%S', tz='UTC')
    lower_lim <- strptime(stime, '%Y-%m-%d %H:%M:%S', tz='UTC')
    household_power_consumption[
        which(
            household_power_consumption$Date.Time > lower_lim &
            household_power_consumption$Date.Time < upper_lim)
    ,]
}

# Use function to load data.
household_power_consumption_filtered <- read.data()

# Draw first PNG
# open png device
png(width=480,height=480,filename='plot1.png')
# Draw histogram
hist(
    household_power_consumption_filtered$Global_active_power,
    col='red',
    xlab='Global Active Power (kilowatts)',
    main='Global Active Power'
)
# close png file and flush data to disk
dev.off()
