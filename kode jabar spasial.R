# Import data jabar

# cara 1
library(readxl)
data_dbh_jabar <- read_excel("data DBH-CHT jabar.xlsx")
View(data_dbh_jabar)

# cara 2
data_dbh_jabar <- openxlsx::read.xlsx("data DBH-CHT jabar.xlsx")
str(data_dbh_jabar)

# import peta pulau jawa
library(rgdal)
petajawa<- readOGR(dsn = "D:\\Jobs\\Pelatihan Spasial STIS\\New folder\\Pelatihan-Spasial\\Jawamap", layer="jawa")
summary(petajawa)
# subset peta pulau jawa menjadi jawa barat
petajabar <- subset(petajawa,PROVINSI=="JAWA BARAT")
summary(petajabar)

View(petajabar@data)

# menambar baris data dengan kota Bandung dan Bekasi
data_dbh_jabar <- rbind(data_dbh_jabar,data_dbh_jabar[15:16,])

# mengurutkan data berdasarkan kabupaten
data_peta1 <- dplyr::arrange(data_dbh_jabar,KABKOT)
data_peta2 <- dplyr::arrange(petajabar@data,KABKOT)

# membuat kolom baru di data peta jawa barat
data_fix <- cbind(data_peta1,data_peta2)
petajabar$TotalRealisasi <- data_fix$TotalRealisasi

View(petajabar@data)
# menentukan warna
blues <- c(RColorBrewer::brewer.pal(9,"Blues")[1],
           RColorBrewer::brewer.pal(9,"Blues")[7],
           RColorBrewer::brewer.pal(9,"Blues")[9])
colfunc <- colorRampPalette(blues)
color1 <- colfunc(27)

# membuat plot peta jawa barat
coordinates(petajabar) # menampilkan coordinate peta
spplot(petajabar,"TotalRealisasi",col.regions=color1)









w_jabar<-poly2nb(petajabar)
nb2mat(w_jabar)
ww<-nb2listw(w, zero.policy=T)






library(cartography)

choroLayer(spdf=petajabar,var="TotalRealisasi",method = "equal")
