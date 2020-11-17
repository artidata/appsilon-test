library(data.table)
## Reading data
dt = fread('ships_04112020/ships.csv')

## Getting the next latitude and longitude for each observations
setkey(dt,ship_type,SHIPNAME,DATETIME)
dt[,':='(LAT_NEXT=shift(LAT,type='lead'),
         LON_NEXT=shift(LON,type='lead')),.(ship_type,SHIPNAME)]

## Function to compute distance between 2 coordinate point
## Output will have meter unit
fnHaversine = function(lat_from, lon_from, lat_to, lon_to, r = 6378137){
  radians = pi/180
  lat_to = lat_to * radians
  lat_from = lat_from * radians
  lon_to = lon_to * radians
  lon_from = lon_from * radians
  dLat = (lat_to - lat_from)
  dLon = (lon_to - lon_from)
  a = (sin(dLat/2)^2) + (cos(lat_from) * cos(lat_to)) * (sin(dLon/2)^2)
  return(2 * atan2(sqrt(a), sqrt(1 - a)) * r)
}

## Apply the function to get the coordinate distance 
dt[,distance:=fnHaversine(LAT,LON,LAT_NEXT,LON_NEXT)]

## Selecting observations when it sailed the longest distance
## If there are ties, the smallest DATETIME will be picked
dt=dt[,.SD[which.max(distance)],.(ship_type,SHIPNAME)]

## Output relevant data for shiny app
fwrite(dt[,.(ship_type,SHIPNAME,LAT,LON,LAT_NEXT,LON_NEXT,distance)],"data.csv")