# twitterGeoLocationTrends
Spring 2017 - Data Intensive Computing - Project 1
Summarizing trending topics on Twitter about a location (place).
Written using R in jupyter notebook.

# twitterEventResponse.r
Data Intesive Computing Project 1.1
Problem 1: Study response to an event.
We are interested in finding out how the nation reacted to the Super Bowl. We are NOT
interested in sentiment analysis. We are interested in sheer number of tweets on a topic that is
associated with Super Bowl LI. You have to choose a good topic. Understand the Search API that
we are using for can give you only limited number of tweets per day and also only a sampling of
the all the tweets. You will collect at least 20000 tweets (Hmm…How could we categorize
them?? We will learn later.). Group them by geo-location as in Google maps API (one more API)
and plot them on the map of USA. If you plot the location every tweet then there will be too
many points on the map. You can plot all the tweets at a given location (say a city or state) by a
single blob, the size of the blob representing the density of tweets. You may need some R
programming here.
Input: Search word or hash tag related to super bowl. Data client processing: Obtain and group
tweets by location. Output: plot the groups by size on a map of USA for visual understanding of
the response to an event.
Issue 1: Of course, there is an issue with location meta-data. This is not available (N/A) if the
user does hide his/her location. This is often the case nowadays with most of us. Many
celebrities are especially conscious about this. They don’t want people knowing their locations
for obvious reasons. Then how can we get “set of locations”?
Here is a verified approach using function of twitteR
1. Convert search result tweets into dataframe
2. Lookup screen name from this dataframe
3. From Screen names get user info and convert into dataframe
4. Keep only users with location info
5. Get the geo code of the locations from this dataframe
6. Hints on TwitteR functions you may need: twListToDF, lookupUsers, geocode
Generalize: Once this is completed, generalize the solution for any twitter search
hashtag. We should be able to reproduce the results for any event or happening of your choice.
Add a text input as a widget so that user can interact with your program with their choice of
search word for the twitter search API.


# showGeoLocTrends.r
Data Intesive Computing Project 1.2
"Problem 2: Summarizing trending topics about a location (place).
When we are visiting places (say, for an interview or other official visits) you may want to about
topics trending in that place. Instead of reading newspapers and online news, you want just a
quick summary. You want to put use your twitter “data client” application development
experience. You use the twitteR libraries “trends” function to retrieve 10 top things trending
about the place and summarize it appropriately as a complete message (print out). 
Input: Location specified either as geo-location or by its name Output: A message listing the
topics trending about the place."
