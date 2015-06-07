# Write small function to read data for drawing
# will use defaults from assessment - 2007-02-01 and 2007-02-02.
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

# Draw second PNG
# open png device
png(width=480,height=480,filename='plot2.png')
# Draw empty plot, but specify header
plot(
    household_power_consumption_filtered$Date.Time,
    household_power_consumption_filtered$Global_active_power,
    main='',
    xlab='',
    ylab='Global Active Power (kilowatts)',
    type='n'
)
# Add line onto it.
lines(
    household_power_consumption_filtered$Date.Time,
    household_power_consumption_filtered$Global_active_power
)
# close png file and flush data to disk
dev.off()

# Draw third PNG
# open png device
png(width=480,height=480,filename='plot3.png')
# Here we draw empty plot as for plot2
plot(household_power_consumption_filtered$Date.Time, 
    household_power_consumption_filtered$Sub_metering_1,
    ylab = 'Energy sub methering',
    main = '',
    xlab = '',
    type = 'n'
)
# and add lines
lines(household_power_consumption_filtered$Date.Time,
    household_power_consumption_filtered$Sub_metering_1,
    col = 'black')
lines(household_power_consumption_filtered$Date.Time,
    household_power_consumption_filtered$Sub_metering_2,
    col = 'red')
lines(household_power_consumption_filtered$Date.Time,
    household_power_consumption_filtered$Sub_metering_3,
    col = 'blue')
# add legend
legend("topright",
    legend=c('Sub_metering_1','Sub_metering_2','Sub_metering_3'),
    lwd = 1, col=c('black','red','blue'))
# close png file and flush data to disk
dev.off()

# Draw 4th PNG
# open png device
png(width=480,height=480,filename='plot4.png')
# set 4 panels for draw area
par(mfcol = c(2,2))
# draw top left graph
# draw empty plot with header
plot(
    household_power_consumption_filtered$Date.Time,
    household_power_consumption_filtered$Global_active_power,
    main='',
    xlab='',
    ylab='Global Active Power',
    type='n')
# add lines
lines(
    household_power_consumption_filtered$Date.Time,
    household_power_consumption_filtered$Global_active_power
)
# draw left bottom
# draw empty plot with header
plot(household_power_consumption_filtered$Date.Time,
    household_power_consumption_filtered$Sub_metering_1,
    ylab = 'Energy sub methering',
    main = '',
    xlab = '',
    type = 'n'
)
# and add lines
lines(household_power_consumption_filtered$Date.Time,
    household_power_consumption_filtered$Sub_metering_1,
    col = 'black'
)
lines(household_power_consumption_filtered$Date.Time,
    household_power_consumption_filtered$Sub_metering_2,
    col = 'red'
)
lines(household_power_consumption_filtered$Date.Time,
    household_power_consumption_filtered$Sub_metering_3,
    col = 'blue'
)
# time to add legend
legend("topright",
    legend=c('Sub_metering_1','Sub_metering_2','Sub_metering_3'),
    lwd = 1,
    col=c('black','red','blue')
)

# righ top drawing
# empty plot with header
plot(
    household_power_consumption_filtered$Date.Time,
    household_power_consumption_filtered$Voltage,
    main='',
    xlab='datetime',
    ylab='Voltage',
    type='n'
)
# add lines
lines(
    household_power_consumption_filtered$Date.Time,
    household_power_consumption_filtered$Voltage
)

# the right bottom
# empty area with header
plot(
    household_power_consumption_filtered$Date.Time,
    household_power_consumption_filtered$Global_reactive_power,
    main='',
    xlab='datetime',
    ylab='Global_reactive_power',
    type='n'
)
# lines
lines(
    household_power_consumption_filtered$Date.Time,
    household_power_consumption_filtered$Global_reactive_power
)
# close png file and flush data to disk
dev.off()
