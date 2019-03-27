# Delta

The *DELTA* function accepts two vectors and calculates Cliff's delta (Cliff, 1990) and the statistical significance of delta using a method optimized for large datasets.

Arguments:

- a: a numeric vector from the comparison group (NAs removed)    
- b: a numeric vector from the focal group (NAs removed)    

Returns:

- $delta: Cliff's delta representing the comparison of the focal group (b) to the reference group (a)  
- $sig: 2-tailed statistical significance of delta at the 95% level, per Cliff (1990) using pooled variances  
- $Na: Number of observations in the reference group  
- $Nb: Number of observations in the focal group  
- $counts: A dataframe of the counts of the observed values in a and b and comparisons of a and b  
- $zero: The number of a-to-b comparisons in which the a and b values were the same  
- $num1: The number of a-to-b comparisons in which the b value was larger  
- $numneg1: The number of a-to-b comparisons in which the b value was smaller  
- $amean: The mean of a  
- $bmean: The mean of b  

Examples:

```
a<-c(1,3,2,4,5,2,3,4)
b<-c(2,3,1,4,2,3,4,2)

DELTA(a,b)
```