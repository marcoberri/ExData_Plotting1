Sys.setlocale("LC_TIME", 'en_US.UTF-8')

download_file<-function(folder, file_result){
  
  if(!file.exists(
    paste(
      paste ("./" , folder, sep = "", collapse = NULL)
      ,file_result, sep = "", collapse = NULL)
  )
  ) {
    printUser("Start download File")  
    dir.create(paste ("./" , folder, sep = "", collapse = NULL))
    fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip" 
    download.file(fileUrl,destfile=paste ( folder, "/power_consumption.zip", sep = "", collapse = NULL), method="curl")
    unzip(paste ( folder, "/power_consumption.zip", sep = "", collapse = NULL), files = NULL, list = FALSE, overwrite = TRUE,junkpaths = FALSE, exdir = "./DS/", unzip = "internal", setTimes = FALSE)
    printUser("END download File")	
    
  }else{
    printUser("File Exists")	
  }
}

download_file("DS","/household_power_consumption.txt")

fulldata<-read.table("./DS/household_power_consumption.txt", header=TRUE, sep = ";", dec=".", quote="\"",  na.strings = "?",colClasses=c("character","character","numeric","numeric","numeric","numeric","numeric","numeric","numeric"))

fulldata$DateTime = strptime(paste(as.character(fulldata$Date),as.character(fulldata$Time),sep=" "),format="%d/%m/%Y %H:%M:%S")

fulldata$Date = as.Date(fulldata$Date,format="%d/%m/%Y")

fulldata_subset <- fulldata[ which(fulldata$Date=='2007-02-01' | fulldata$Date== '2007-02-02'),]

fulldata_subset$Day_of_Week <- strftime(fulldata_subset$Date,'%a')

png(filename = "./plot4.png", width = 800, height = 800, units = "px",bg="white")

par (mfrow = c(2,2), mar = c(4,4,2,1), oma = c(0,0,2,0))

plot(fulldata_subset$DateTime,fulldata_subset$Global_active_power, ylab='Global Active Power (kilowatts)', xlab='', type='l')


plot(fulldata_subset$DateTime,fulldata_subset$Voltage, ylab='Voltage', xlab='datetime', type='l')


plot(fulldata_subset$DateTime,fulldata_subset$Sub_metering_1, ylab='Energy sub metering', col="black", xlab='', type='l')
lines(fulldata_subset$DateTime,fulldata_subset$Sub_metering_2, type="l", col="red")
lines(fulldata_subset$DateTime,fulldata_subset$Sub_metering_3, type="l", col="blue")
legend("topright", lty=1, lwd=1, col=c("black","blue","red"), legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),bty="n")


plot(fulldata_subset$DateTime,fulldata_subset$Global_reactive_power, ylab='Global_reactive_power', xlab='datetime', type='l')



dev.off()
