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

png(filename = "./plot1.png", width = 480, height = 480, units = "px",bg="white")

hist(fulldata_subset$Global_active_power,col="red",main="Global Active Power",xlab="Global Active Power (kilowatts)")

dev.off()


