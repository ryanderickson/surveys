
# Dashboards

The ```flexdashboard``` package for R makes it easy to create interactive dashboards and incorporate widgets such as ```plotly``` and ```leaflet```. Source code, examples, and templates are available at https://rmarkdown.rstudio.com/flexdashboard/examples.html.

# Delta

The *DELTA* function accepts two vectors and calculates Cliff's delta (Cliff, 1993) and the statistical significance of delta using a method optimized for large datasets.

Arguments:

- a: a numeric vector from the comparison group (NAs removed)    
- b: a numeric vector from the focal group (NAs removed)    

Returns:

- $delta: Cliff's delta representing the comparison of the focal group (b) to the reference group (a)  
- $sig: 2-tailed statistical significance of delta at the 95% level, per Cliff (1993) using pooled variances  
- $Na: Number of observations in the reference group  
- $Nb: Number of observations in the focal group  
- $counts: A dataframe of the counts of the observed values in a and b and comparisons of a and b  
- $zero: The number of a-to-b comparisons in which the a and b values were the same  
- $num1: The number of a-to-b comparisons in which the b value was larger  
- $numneg1: The number of a-to-b comparisons in which the b value was smaller  
- $amean: The mean of a  
- $bmean: The mean of b  

References:

Cliff, N. (1993). Dominance statistics: Ordinal analyses to answer ordinal questions. *Psychological Bulletin*, 114, 494-509.

Disclaimer:

This function is made available without restrictions, and with no guarantee or warranty of any kind.

Examples:

```
a<-c(1,3,2,4,5,2,3,4)
b<-c(2,3,1,4,2,3,4,2)

DELTA(a,b)


a<-rep(1:10, 5000)
b<-rep(1:5, 2000)

# 17 seconds required to compute via dominance matrix
t1<-Sys.time()
mean(sign(outer(b, a, FUN="-")))
Sys.time() - t1

# 0.1 seconds required to compute via counts. also does not hit a RAM ceiling.
t2<-Sys.time()
DELTA(a,b)
Sys.time() - t2


```


