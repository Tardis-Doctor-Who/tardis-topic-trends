########################################################################
# Run this three cells to get a print out of trending twitter searches #
# for a specified location. The location can be chosen by changing the #
# variable 'search_param' in the second cell. The output of the second #
# cell will tell you if the place you are searching for is in the list #
# of availableTrendLocations() provided.                               #
########################################################################

library("twitteR")

# Authorization from twitter developer
setup_twitter_oauth("enter_twitter_developer_key_here")

avail_trends = availableTrendLocations()
#length(avail_trends)
#length(names(avail_trends))
#names(avail_trends)
#length(avail_trends$name)

# List available US Cities
#us_cities <- subset(avail_trends, country == "United States")
#us_cities

#Uncomment for testing.
#avail_trends[[1]][3]

######################################################################
# This can be updated to search for different tags                   #
######################################################################
search_param <- "Dallas-Ft. Worth"

# Check is search parameter is in the list of available search locations
if(search_param %in% avail_trends[[1]]){
    print("Search Successful")
    search_status = 1
}else{
    print(paste("No trend analysis for location:",search_param,
            "Please try another location."))
    search_status = 0
}

# Check of the search was a success
if(search_status == 1){
    # Convert search_param string into woeid
    city_line_num <- which(avail_trends[[1]] == search_param)
    woeid <- avail_trends[[3]][city_line_num]
    # Uncomment for testing.
    #woeid

    # Look for tweets using above parameter
    trends = getTrends(woeid)
    
    # Get the top ten search items.
    top_ten_search <- subset(head(trends, n=10))
    # Uncomment for testing.
    #top_ten_search[[1]]
}

# Print the results to the console for the user.

paste("The top ten Twitter searches in", search_param, 
      format(Sys.time(), "%a %b %d %X %Y"),":")
strsplit(top_ten_search[[1]], "\n")
# Display some specific tweets. gsub removes '/' from apostrophe words
# i.e. "don/'t" becomes "don't"
tweets1 <- searchTwitter(top_ten_search[[1]][1], n=5,lang='en')
df1 <- twListToDF(tweets1)
paste("\n")
paste("The five most recent tweets about", top_ten_search[[1]][1], "are:")
df1[[1]][1]
df1[[1]][2]
df1[[1]][3]
df1[[1]][4]
df1[[1]][5]

paste("*Note: RT are retweets")
