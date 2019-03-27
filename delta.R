
DELTA<-function(a,b){
  
  # has to separately handle length(0) vectors, and length(1) vectors because they zero-out the denominator
  if(length(a)>1 & length(b)>1){
    
    n_a<-length(a)
    n_b<-length(b)
    n_tot<-as.double(as.double(n_a) * as.double(n_b))
    n_tot1<-as.double(as.double(n_a-1) * as.double(n_b-1))
    
    possible<-sort(unique(c(a,b)))
    
    # count number of responses in, <, >, in a or b
    bequal<-vapply(possible, 1, FUN=function(x)length(b[b %in% x]))
    aequal<-vapply(possible, 1, FUN=function(x)length(a[a %in% x]))
    aLT<-vapply(possible, 1, FUN=function(x)length(a[a < x]))
    aGT<-vapply(possible, 1, FUN=function(x)length(a[a > x]))
    
    counts<-data.frame(possible=possible,
                       bequal=bequal,
                       aequal=aequal,
                       aLT=aLT,
                       aGT=aGT)
    
    num1<-as.double(sum(counts$bequal * counts$aLT))
    numneg1<-as.double(sum(counts$bequal * counts$aGT))
    numerator<-num1 - numneg1 
    
    delta<-numerator/n_tot
    
    minp<-min(possible)
    maxp<-max(possible)
    
    # if min = max, everyone said the same value. in that case force the second-highest/lowest values to be the same as min & max
    if(minp==maxp){
      
      minp2<-minp
      maxp2<-maxp
      
    } else {
      
      minp2<-min(possible[possible != min(possible)]) # 2nd lowest value
      maxp2<-max(possible[possible != max(possible)]) # 2nd highest value
    }
    
    # initialize t1, t2
    counts$t1<-NA
    counts$t2<-NA
    
    # write t1 & t2 row by row. i is the row index.
    for(i in possible){
      
      # g1reX from old style
      if(i==minp){
        counts[counts$possible==i,"t1"]<-((((sum(counts[counts$possible>i, "aequal"])*-1)/n_a)-delta)^2)*counts[counts$possible==i, "bequal"]
      }
      if(i < maxp & i > minp){
        counts[counts$possible==i,"t1"]<-(((((sum(counts[counts$possible>i, "aequal"])*-1) + sum(counts[counts$possible<i, "aequal"]))/n_a) - delta)^2*counts[counts$possible==i, "bequal"])
      }
      if(i==maxp){
        counts[counts$possible==i,"t1"]<-(((sum(counts[counts$possible<i, "aequal"])/n_a)-delta)^2)*counts[counts$possible==i, "bequal"]
      }
      
      # g2ceX from old style
      if(i==minp){
        counts[counts$possible==i,"t2"]<-((((sum(counts[counts$possible>i, "bequal"])/n_b)-delta)^2)*counts[counts$possible==i, "aequal"])
      }
      if(i < maxp & i > minp){
        counts[counts$possible==i,"t2"]<-((((sum(counts[counts$possible>i, "bequal"]) + sum(counts[counts$possible<i, "bequal"])*-1)/n_b) - delta)^2*counts[counts$possible==i, "aequal"])
      }
      if(i==maxp){
        counts[counts$possible==i,"t2"]<-((((sum(counts[counts$possible<i, "bequal"])*-1)/n_b)-delta)^2)*counts[counts$possible==i, "aequal"]
      }
    }
    
    # neg1 & pos1 totals
    neg1<-0
    for(i in possible[possible<=maxp2]){
      neg1<-as.double(neg1 + sum(counts[counts$possible>i, "aequal"]) * counts[counts$possible==i, "bequal"])
    }
    
    pos1<-0
    for(i in possible[possible>=minp2]){
      pos1<-as.double(pos1 + sum(counts[counts$possible<i, "aequal"]) * counts[counts$possible==i, "bequal"])
    }
    
    zro<-as.double(n_tot - pos1 - neg1)
    
    term1<-as.double((n_a^2) * sum(counts$t1))
    term2<-as.double((n_b^2) * sum(counts$t2))
    term3<-as.double(((-1-delta)^2)*neg1+((1-delta)^2)*pos1+((0-delta)^2)*zro)
    
    denom2<-as.double(as.double(n_a) * as.double(n_b) * as.double(n_a-1) * as.double(n_b-1))
    
    sd2<-(term1+term2-term3)/denom2
    sd1<-sqrt(sd2)
    
    z<-delta/sd1
    tp1<-1-pnorm(abs(z))
    tp2<-2*tp1
    
    # if everyone said the same value in both groups, delta is fine but have to force p=0
    ua<-unique(a)
    ub<-unique(b)
    
    if(length(ua)==1 & length(ub)==1){
      if(is.finite(ua) & is.finite(ub)){
        if(ua == ub){
          tp2<-1
        }
      }
    }
    
    return(list(delta=round(delta,6),
                sig=round(tp2,6),
                Na=n_a,
                Nb=n_b,
                counts=counts,
                zero=zro,
                term1=term1,
                term2=term2,
                term3=term3,
                denom2=denom2,
                sd2=sd2,
                amean=round(mean(a),6),
                bmean=round(mean(b),6),
                num1=num1,
                numneg1=numneg1))
    
    # if a or b has 1 response then return delta & counts, but force everything else to be missing. can't calculate sig w/1 response.
  } else if((length(a)==1 & length(b)>=1) | (length(a)>=1 & length(b)==1)){
    
    n_a<-length(a)
    n_b<-length(b)
    n_tot<-as.double(as.double(n_a) * as.double(n_b))
    n_tot1<-as.double(as.double(n_a-1) * as.double(n_b-1))
    
    possible<-sort(unique(c(a,b)))
    
    bequal<-vapply(possible, 1, FUN=function(x)length(b[b %in% x]))
    aequal<-vapply(possible, 1, FUN=function(x)length(a[a %in% x]))
    aLT<-vapply(possible, 1, FUN=function(x)length(a[a < x]))
    aGT<-vapply(possible, 1, FUN=function(x)length(a[a > x]))
    
    counts<-data.frame(possible=possible,
                       bequal=bequal,
                       aequal=aequal,
                       aLT=aLT,
                       aGT=aGT)
    
    numerator<-as.double(sum(counts$bequal * counts$aLT) - sum(counts$bequal * counts$aGT))
    delta<-numerator/n_tot
    
    return(list(delta=round(delta,6),
                sig=NA,
                Na=n_a,
                Nb=n_b,
                counts=NA,
                zero=NA,
                term1=NA,
                term2=NA,
                term3=NA,
                denom2=NA,
                sd2=NA,
                amean=round(mean(a, na.rm=TRUE),6),
                bmean=round(mean(b, na.rm=TRUE),6)))
    
    # "else" should mostly be instances where a or b has 0 responses. 
    #  return counts and means but force everything else to be missing.
  } else {
    
    n_a<-length(a)
    n_b<-length(b)
    
    return(list(delta=NA,
                sig=NA,
                Na=n_a,
                Nb=n_b,
                counts=NA,
                zero=NA,
                term1=NA,
                term2=NA,
                term3=NA,
                denom2=NA,
                sd2=NA,
                amean=round(mean(a, na.rm=TRUE),6),
                bmean=round(mean(b, na.rm=TRUE),6)))
    
  }
}

















