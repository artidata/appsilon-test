
# Question 1
f1 <- function(x){
  counter = 0
  while(x!=0){
    if(x%%2 == 1){
      counter = counter + 1
      }
    x = x%/%2
  }
  counter
}

f1(8)
f1(5)
f1(7)
f1(16)
f1(32)
f1(33)

# Question 2
f2 <- function(x){
  lenX = length(x)
  sortX = sort(x)
  if(lenX%%2==1){
    sortX[lenX%/%2+1]
  } else {
    mean(sortX[(lenX%/%2):(lenX%/%2+1)])
  }
}

f2(c(3,2,4,1,5))
f2(c(1,1,2,2))
f2(c(1,1,1,1,1))
f2(1:10)
f2(1:9)
