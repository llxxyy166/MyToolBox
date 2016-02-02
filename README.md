# MytoolBox

This app now contains a simple calculator with + - * /. Enter the expression than push = button to calculate.
The model is written in C++, inspired by the 2 calculator problem on leetcode

Second function is the weather forecast. It query from yahoo via their API to get the location ID, then query the weather by 
this unique ID. It can display 3 locations' weather at same time (my intutive is 1 for current location, 1 for my home in US and 1 for my home in China but unfortuantely I don't have time to add a locating function to it)

Third function is get the movie data from TMDb. Currently it can do
1. Search movie by genre, and get the details
2. Show the poster and the trailer
3. Show each movies's similar movies
4. Search upcoming movies
5. Save each movied viewed into core data (of courese you can erase history)
Much more coming soon
