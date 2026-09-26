######################################################################
# The last cell reads from the CSV files to populate points on a map #
# This cell has the variable 'search_param' which can be changed to  #
# search for different tags. The twitter search currently searches   #
# for 5000 tweets, which can potentially take a long time.           #            
######################################################################

library("twitteR")
library("RSQLite")
library("ggplot2")
library("ggmap")
library("maps")
library("mapproj")
library("data.table")

# Authorization from twitter developer
setup_twitter_oauth("enter_twitter_developer_key_here")

# This can be updated to search for different tags
search_param <- "#tombrady"

# Look for tweets using above parameter
tweets <- searchTwitter(search_param, n=5000, since='2017-01-01',lang='en')

# Uncomment ffor testing
#head(strip_retweets(tweets, strip_manual=TRUE, strip_mt=TRUE))

# Uncomment for testing
#length(tweets)
#Sys.getlocale()

# Not really sure why this is needed but there are errors when not used
Sys.setlocale('LC_ALL','C') 

# Uncomment for testing
#Sys.getlocale()

# Convert tweets to a data file
df <- twListToDF(tweets)

# Uncomment for testing
#head(df)
#names(df)

# Convert tweets to a database
sql_lite_file = tempfile()
register_sqlite_backend(sql_lite_file)
store_tweets_db(tweets)
from_db = load_tweets_db()

# Uncomment for testing
#head(from_db)
#length(from_db)

# Create names.object to store all the screen names from the database
names <- sapply(from_db, function(x) x$getScreenName())

# Uncomment for testing
#head(names.object)
#length(names.object)

# Create a data file containging all usernames informatio
users_df <- rbindlist(lapply(lookupUsers(names), as.data.frame))

# Uncomment for testing.
#users_df$location
#length(users_df$location)

# Remove empty locations.
users_df <- subset(users_df, location != '')

# Uncomment for testing.    
length(users_df$location)
#users_df$location


# Remove '%' character from locations because geocode doesnt' like it.
users_df$location <- gsub("%", " ",users_df$location)
#users_df$location

# Using code from lucaspuente.github.io to convert users datafile into 
# list of location information
geocode_apply <- function(x){
    geocode(x, source = "google", output = "latlona")
}
users_geocode <- sapply(users_df$location, geocode_apply, simplify = F)

# Uncomment for testing.
#typeof(users_geocode)
length(users_geocode)
#head(users_geocode)
#!is.na(users_geocode[[5]][1])
#head(users_geocode)

# Remove entries with na as lat
remove_na <- sapply(users_geocode, function(x) !is.na(x[1]))
users_geocode <- users_geocode[remove_na]

# Uncommment for testing.
length(users_geocode)

# Uncomment for testing.
#users_geocode[1]
#print(as.numeric(users_geocode[[1]]))
#print(as.numeric(users_geocode[[1]][2]))

# Get length of users_geocode to set limits on for loop.
elems <- as.numeric(length(users_geocode))

# Create 'character' of latitudes 
# (whatever the hell type 'character' means).
lats = ''
for(i in 1:elems){
    lats[i] <- as.numeric(users_geocode[[i]][1])
    # Uncomment for testing.
    #print(as.numeric(users_geocode[[i]][1]))
    #print(lats[i])
}
# Uncomment for testing.
#length(lats)
#typeof(lats)
#lats

# Create 'character' of longitudes.
lons = ''
for(i in 1:elems){
    lons[i] <- as.numeric(users_geocode[[i]][2])
    
    #print(as.numeric(users_geocode[[i]][1]))
    #print(lons[i])
}
# Uncomment for testing.
#length(lons)
#lons

# Create a data file with latitudes and longitudes.
latlon_df = data.frame(lats, lons)

# Uncomment for testing.
length(latlon_df)
#head(latlon_df)
#names(latlon_df)

# Create a map with all necessary paramaters to add points
us_map <- map("state", proj="albers", param=c(39, 45), 
                 col="#999999", fill=FALSE, bg=NA, lwd=0.2, 
              add=FALSE, resolution=1)

# Add density points to the map from lat/longs obtained.
points(mapproject(lats, lons), col=NA, bg="#00000030", pch=21, cex=1.0)

# Used to write original tables
#write.table(latlon_df, file = "latlon.csv", sep = ",", col.names = NA,
#            qmethod = "double")
#write.table(lats, file = "lats.csv", sep = ",", col.names = NA,
#            qmethod = "double")
#write.table(lons, file = "lons.csv", sep = ",", col.names = NA,
#            qmethod = "double")

# Used to update tables.
#write.table(latlon_df_new, file = "latlon.csv", sep = ",", col.names = NA,
#            qmethod = "double")
#csvCurrent <- read.csv("latlon_df.csv", row.names = 1)
#csvNew <- read.csv("latlon_df_new.csv", row.names = 1)

# Uncomment for testing.
#length(csvCurrent)
#head(csvCurrent)
#length(csvNew)
#head(csvNew)

#csvUpdated <- rbind(csvCurrent, csvNew)
#head(csvUpdated)
#length(csvUpdated)

#write.table(latlon_df, file = "csvUpdated.csv", sep = ",", col.names = NA,
#            qmethod = "double")

######################################################################
# Run this cell reads from the CSV files to populate points on a map #
######################################################################

library("maps")
library("mapproj")
library("data.table")

# Read in the CSV file and use the points to plot a map
csvLats <- read.csv("lats.csv", row.names = 1)
csvLons <- read.csv("lons.csv", row.names = 1)
# Uncomment for testing.
#head(csvLats)
#head(csvLons)
#length(csvLats[[1]])
#length(csvLons[[1]])
#typeof(csvLats)
#csvLats[[1]][1]
#csvLats[[1]][2]

# I have to convert the above data tables or else I get an error
# from mapproj about x and y having different lengths
# Get length of users_geocode to set limits on for loop.
elems <- as.numeric(length(csvLats[[1]]))

# Create 'character' of latitudes 
# (whatever the hell type 'character' means).
lats = ''
for(i in 1:elems){
    lats[i] <- as.numeric(csvLats[[1]][i])
    # Uncomment for testing.
    #print(as.numeric(users_geocode[[i]][1]))
    #print(lats[i])
}
# Uncomment for testing.
#length(lats)
#typeof(lats)
#lats

# Create 'character' of longitudes.
lons = ''
for(i in 1:elems){
    lons[i] <- as.numeric(csvLons[[1]][i])
    
    #print(as.numeric(users_geocode[[i]][1]))
    #print(lons[i])
}
# Uncomment for testing.
#length(lons)
#lons

# Create a map with all necessary paramaters to add points
us_map <- map("state", proj="albers", param=c(39, 45), 
              col="#999999", fill=FALSE, bg=NA, lwd=0.2, 
              add=FALSE, resolution=1)

# Add density points to the map from lat/longs obtained.
points(mapproject(lats, lons), col=NA, 
       bg="#00000030", pch=21, cex=1.0)
