1. Code checks for libraries needed
2. Code loads libraries data.table and dplyr used in script
3. Code reads the column variables into features.col and filters the names containing mean and std 
4. Code reads the activity labels
5. Code reads the training data and test data in one step into environment and merges the data. Uses FREAD as it's much faster
6. Code sets the column names for train and test data, based on features and join the activity data
7. Code removes all the unneeded variables
8. Code tidies the data
9. Code writes the results to a file
