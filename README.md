---
title: "README for Coursera course project 'Getting and Cleaning Data'"
author: Thomas Weber
output:
  html_document:
    toc: true
---

# Content of repository
- README.md: the current document
- run_analyis.R: Runs the extraction and tidying code
- CodeBook.md: Explains the meaning of the column names

# run_analysis.R
## Explanation of the code
### Preparations
- If the data file https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip hasn't been downloaded yet, it is donwloaded and unzipped first.
- The mapping tables for activities and features are loaded next. They provide mappings between the number for activities and features and the names for activities and features, respectively.
- Test and training data are loaded. The features' names from the previous step are used to give column names already at this stage. This simplifies the later work. Further, the numbers of activities and subjects for each observation are loaded and added as additional columns to the test and training data frames. The resulting data frames are called ```
test.df``` and ```train.df```

- We grep through the feature names for all names that contain "mean" or "std". As the assignment text is vague on what exactly constitutes a mean or std value in the exercise, I felt it is easiest to just include them all. The resulting table is a bit larger, but that is better than missing out on a needed value. The corresponding index values for the test and training sets are combined into a vector named
```
indices
```

### Steps from the assignment

- Step 1: The test and training data frames are "rbinded" to form a common data frame 
```df```
- Step 2: Using the vector ```indices```, we extract the columns with "mean" and "std" in their name from ```df```. As this removes also the ```activity``` and ```subject``` column, we put these two columns back. The resulting data frame is called ```df.filtered```.
- Step 3: In order to replace activity numbers with activity names, the corresponding data frames are merged. The (now superfluous) ```activity``` (containing the activity numbers) is removed and the column with the activity names is named ```activity``` instead. Further, this column is converted to a factor column. The resulting data frame is called ```df.named```.
- Step 4: This step was already done in the preparation phase, so the column names are already the names as they appear in the feature list. 
- Step 5: In order to create the tidy data frame as required by the assignment, the data frame is melted with ```activity``` and ```subject``` as ```id``` variables to give ```df.melt```. This data frame is then dcasted with aggreate function ```mean``` and the result is named ```df``` (overwriting the ```df``` frame from step 1). This dataframe ```df``` is written with ```write.table``` to a file named ```output.txt```. The column names of the data frame ```df``` have been retained, despite the fact that the values are no longer the actual measurement values, but the mean values. However, the codebook explains this and I found it easier to have the same names for both data frames, allowing a better match between the original values and the mean values.

# Loading the tidy data
The dataframe can be loaded with the command
```
df <- read.table("output.txt", header = TRUE, check.names = FALSE)
```
