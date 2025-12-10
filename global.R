#GLOBAL
################################################################################


# Importation packages utiles
library(shiny)
library(shinydashboard)
library(tidyverse)
library(ggplot2)
library(plotly)
library(treemapify)
library(shinythemes)


# Importation des données 
product= read_delim("data/dataset_product.csv", delim = ";")

# Préparation des données

fact=1:5
product[,fact]= lapply(product[,fact], 
                       FUN = as.factor)


# création de nouvelles variables
product=product %>% mutate(note_produit=product$sum_customer_note/product$nb_customer_note)
product=product %>% mutate(qty_total=product$qty_store + product$qty_web)
product=product %>% mutate(ca_total=product$ca_store + product$ca_web)
product=product %>% mutate(taux_ajout_panier=(product$nb_add_to_cart_web/product$nb_session_web)*100)
product=product %>% mutate(taux_litige=(product$total_product_dispute/product$qty_total)*100)
product=product %>% mutate(taux_transaction_web=(product$qty_web/product$qty_total)*100)

# Création sélecteur variables MEUBLE : Top 3 
#
sous_famille<-c("CANAPES","CHAISES","BUFFETS ET COMPTOIRS")


# création jeux de données 

#
meuble<-product%>% filter(product_activity=="meuble")

#
global<-product%>% 
  group_by(product_activity)%>%
  summarise(sum(ca_total),sum(qty_total),mean(taux_litige))

#
gib <- product %>% filter(product_is_good_is_beautiful=="TRUE")

#
GIB_pourcent <- meuble %>% 
  group_by(product_is_good_is_beautiful)%>%
  summarise(sum(ca_total),sum(qty_total))

#
CA_Meuble_Total<-sum(meuble$ca_total)

#
QTY_Meuble_Total<-sum(meuble$qty_total)

#
plus_vendu <- meuble %>% 
  group_by(product_subfamily)%>%
  summarise(sum(ca_total),sum(qty_total))

#
plus_vendu_qty <- plus_vendu %>% 
  arrange(desc(plus_vendu$'sum(qty_total)'))

#
plus_vendu_ca<-plus_vendu %>%
  arrange(desc(plus_vendu$'sum(ca_total)'))

#
groupby_family<- meuble %>% 
  group_by(product_family) %>%
  summarise(ca=sum(ca_web)+sum(ca_store),count=n())

#
top3<-product %>%
  filter(product_subfamily=="CANAPES" |product_subfamily=="CHAISES"|product_subfamily=="BUFFETS ET COMPTOIRS")

#
canape<-product %>%
  filter(product_subfamily=="CANAPES")

#
chaise<-product %>%
  filter(product_subfamily=="CHAISES")

#
buff<-product %>%
  filter(product_subfamily=="BUFFETS ET COMPTOIRS")


# TOP 3 : clustering CANAPE
canape_CAH<- canape %>%
  select(6:35)

#
table_distance=dist(canape_CAH)

# 
arbre<-hclust(table_distance,method = "ward.D")
canape$cluster <- cutree(arbre,5)
canape$cluster=as.factor(canape$cluster)

# création jeu de données pour canape moins attractifs 
canape_moins_attractif<-canape %>%
  filter(cluster=="3")
canape_moins_attractif$cluster=as.factor(canape_moins_attractif$cluster)

# création jeu de données pour canape plus attractifs
canape_plus_attractif<-canape %>%
  filter(cluster=="4")
canape_plus_attractif$cluster=as.factor(canape_plus_attractif$cluster)

# jeu de données comparer plus et moins attractifs 
canape_groupe_filtre<-canape %>%
  filter(cluster=="3" |cluster=="4" )

# mettre en facteur 
canape_groupe_filtre$cluster=as.factor(canape_groupe_filtre$cluster)

# KPI
pourcent_GIB_canap_attractif <-canape_plus_attractif%>%
  group_by(product_is_good_is_beautiful)%>%
  summarise(count=n())

# KPI
pourcent_GIB_canap_moins_attractif <-canape_moins_attractif%>%
  group_by(product_is_good_is_beautiful)%>%
  summarise(count=n())

# TOP 3 : clustering CHAISES 

#
chaise_CAH<- chaise %>%
  select(6:35)

#
table_distance_chaise=dist(chaise_CAH)
arbre_chaise<-hclust(table_distance_chaise,method = "ward.D")
chaise$cluster <- cutree(arbre_chaise,5)
chaise$cluster=as.factor(chaise$cluster) 

# création jeu de données pour chaises moins attractifs
chaise_moins_attractif<-chaise %>%
  filter(cluster=="2")
chaise_moins_attractif$cluster=as.factor(chaise_moins_attractif$cluster)

# création jeu de données pour chaises plus attractifs
chaise_plus_attractif<-chaise %>%
  filter(cluster=="3")

# mettre en facteur 
chaise_plus_attractif$cluster=as.factor(chaise_plus_attractif$cluster)

# jeu de données comparer plus et moins attractifs 
chaise_groupe_filtre<-chaise %>%
  filter(cluster=="2" |cluster=="3" )

# KPI
pourcent_GIB_chaise_moins_attractif <-chaise_moins_attractif%>%
  group_by(product_is_good_is_beautiful)%>%
  summarise(count=n())

# KPI
pourcent_GIB_chaise_attractif <-chaise_plus_attractif%>%
  group_by(product_is_good_is_beautiful)%>%
  summarise(count=n())


# TOP 3 : clustering BUFFETS 
#
buff_CAH<- buff %>%
  select(6:35)

#
table_distance_buff=dist(buff_CAH)
arbre_buff<-hclust(table_distance_buff,method = "ward.D")
buff$cluster <- cutree(arbre_buff,5)
buff$cluster=as.factor(buff$cluster)

# création jeu de données pour buffets moins attractifs
buff_moins_attractif<-buff %>%
  filter(cluster=="1")

# création jeu de données pour buffets plus attractifs
buff_plus_attractif<-buff %>%
  filter(cluster=="4")

# mettre en facteur 
buff_moins_attractif$cluster=as.factor(buff_moins_attractif$cluster)
buff_plus_attractif$cluster=as.factor(buff_plus_attractif$cluster)

# jeu de données comparer plus et moins attractifs
buff_groupe_filtre<-buff %>%
  filter(cluster=="1" |cluster=="4"|cluster=="5" )

# KPI
pourcent_GIB_buff_moins_attractif <-buff_moins_attractif%>%
  group_by(product_is_good_is_beautiful)%>%
  summarise(count=n())

# KPI
pourcent_GIB_buff_attractif <-buff_plus_attractif%>%
  group_by(product_is_good_is_beautiful)%>%
  summarise(count=n())

# cluster buffet atypique 
buff_atypique<-buff %>%
  filter(cluster=="5")

#formatC(CA_Meuble_Total,format="f",big.mark = ".",decimal.mark = ",")

# création thème 
t<-theme(plot.title = element_text(face = "bold", colour = 'black', size = 12, hjust = 0.5, vjust = 0.5, angle = 0),
         axis.title.x = element_text(face = "bold", colour = '#577072', size = 10, hjust = 0.5, vjust = 0.5, angle = 0),
         axis.title.y = element_text(face = "bold", colour = '#577072', size = 10, hjust = 0.5, vjust = 0.5, angle = 90),
         # pour les chioffre de graduation
         axis.text.y = element_text(face = "bold"),
         # pour les tirets de graduation
         axis.ticks.y = element_blank(), )

t1 <- theme(axis.text.x = element_text(face = "bold", color = "black", 
                                       size = 8,hjust = 1))

gib_groupe<-gib%>%
  group_by(product_activity)%>%
  summarise(ca=sum(ca_total),qty=sum(qty_total))


