---
title: "Codebook for Coursera course project 'Getting and Cleaning Data'"
author: Thomas Weber
output:
  html_document:
    toc: true
---

# Explanation of variables for the data.frame 
The data in ```output.txt``` contains **mean values** for the different measurement values of the ```mean``` and ```std (standard deviation)``` values described in the files ```features.txt``` and ```features_info.txt``` from the original data set (the .zip file). The mean values are given for each unique combination of ```activity``` and ```subject``` (aka individual person).
The units and definitions for the data can thus be found in the original files ```features_info.txt``` and ```features.txt```. The column names in the original test and training sets and the mean values in ```output.txt``` are the same, to ensure an easy mapping between the two data sets (despite the fact that ```output.txt``` contains mean values).

Another reason for keeping the column names is the lack of domain knowledge. I assume that the original column names are consistent with best practices in the domain of human movement measurements, so I did not want to mess with them.