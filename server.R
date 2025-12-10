#SERVER
################################################################################
shinyServer(function(input, output) { 

################################################################################
# EXTRAIT DES DONNEES 
################################################################################
  
# extrait  
  output$view <- renderTable({
    head(product,n=input$nbdonnes)
  })  
  
################################################################################
# STATISTIQUES 
################################################################################  

  # structure des données  
  output$structure<-renderPrint({
    str(product)
  })
  
# summary   
  output$summary<-renderPrint({
    summary(product)
  })
  
################################################################################  
# GLOBAL 
####################################################################GLOBAL
  
# moyenne note tout store
  output$moyennenote_tout <- renderText({
    mean(product$note_produit[product$product_activity %in% input$var_global],na.rm = T)
  })
  
# CA tout $product_family %in% input$product_activity])/(dataset_product$nb_session_web[meuble
  output$CA_tout <- renderText({
    formatC(sum(product$ca_total[product$product_activity %in% input$var_global]),format="d",big.mark = " ",decimal.mark = ",")
  })
  
  
# taux de conversion tout web 
  output$taux_conv_tout <- renderText({
    mean(product$product_price[product$product_activity %in% input$var_global])
  })
  
  output$Nuage_CA_QTY_global <- renderPlotly({
    ggplot(global,aes(product_activity,`sum(qty_total)`))+
      geom_bar(stat = "identity")+
      xlab("Type de produit")+
      ylab("Somme des quantités vendues")+
      theme(axis.text.x = element_text(face = "bold", color = "black", 
                                       size = 8,hjust = 1))
  })
  
  output$bar_ca <- renderPlotly({
    ggplot(global,aes(product_activity,`sum(ca_total)`))+
      geom_bar(stat = "identity")+
      xlab("Type de produit")+
      ylab("Somme du chiffre d'affaire")+
      theme(axis.text.x = element_text(face = "bold", color = "black", 
                                       size = 8,hjust = 1))
  })
  
  output$taux_transaction_web <-renderText({
    mean(product$taux_transaction_web[product$product_activity %in% input$var_global])
  })
  
  output$taux_litige_global <- renderPlotly({
    ggplot(global,aes(product_activity,`mean(taux_litige)`))+
      geom_bar(stat = "identity")+
      xlab("Type de produit")+
      ylab("Moyenne taux de litige")+
      theme(axis.text.x = element_text(face = "bold", color = "black", 
                                       size = 8,hjust = 1))
  })
  
################################################################################
 
################################################################################  
   # GIB 
################################################################################  
  
# % de produit GIB vendus qty
    output$pourcentage_GIB_vendu<- renderText({
      GIB_pourcent<-GIB_pourcent %>% filter(product_is_good_is_beautiful==TRUE)
      (GIB_pourcent$`sum(qty_total)`/QTY_Meuble_Total)*100 #22% des ventes 
    })
    
# % de pdts GIB vendus en CA     
    output$pourcentage_CA_GIB_vendu<-renderText({
      GIB_pourcent<-GIB_pourcent %>% filter(product_is_good_is_beautiful==TRUE)
      (GIB_pourcent$`sum(ca_total)`/CA_Meuble_Total)*100 
    })
 
################################################################################       
# MEUBLE
################################################################################    

################################################################################    
  # GENERAL
################################################################################
    
# KPI moyenne note meuble store
    output$moyennenote_meuble <- renderText({
     mean(meuble$note_produit[meuble$product_family %in% input$family_meuble],na.rm = T)
    })
    
# KPI CA meuble 
    output$CA_MEUBLE <- renderText({
      formatC(sum(meuble$ca_total[meuble$product_family %in% input$family_meuble]),format="d",big.mark = " ",decimal.mark = ",")
    })
    
    
# KPI taux de conversion meuble web 
    output$taux_conv_meuble <- renderText({
      mean(((meuble$nb_transaction_web[meuble$product_family %in% input$family_meuble])/(meuble$nb_session_web[meuble$product_family %in% input$family_meuble])),na.rm=T)
    })
    

#nuage de points CA en fonction des qt sur le web
  output$Nuage_CA_family_meuble <- renderPlotly({
    nuage_un <- meuble %>% 
      filter(product_family==input$family_meuble)
        ggplot(nuage_un, aes(x = ca_total, y = qty_total,col = product_subfamily)) + 
          geom_point()+
          labs(title = paste("Dispersion du chiffre d'affaire total par la quantités vendues des",str_to_lower(input$family_meuble), x = "Somme du chiffre d'affaire", y = "Somme des quantités vendues"))+
          theme(axis.text.x = element_text(face = "bold", color = "black", 
                                           size = 8,hjust = 1))
  })
  
  
# prix moyen de tous les produits 
  output$prix_moyen_prod <- renderText({
    formatC(mean(meuble$product_price),format="d",big.mark = " ",decimal.mark = ",")
  })
  
# prix moyen de la sous catégorie sélectionnée 
  output$prix_moyen_prod_select <- renderText({
    formatC(mean(meuble$product_price[meuble$product_family %in% input$family_meuble]),format="d",big.mark = " ",decimal.mark = ",")
  }) 
 
  
# répartition CA en fonction de product family 
  output$ventes_par_family_store<-renderPlotly({
    ggplot(groupby_family,aes(x = product_family, y = ca))+
      geom_bar(stat = "identity")+
      theme(axis.text.x = element_text(face = "bold", color = "black", 
                                                                   size = 8, angle = 45,hjust = 1))
      
      
      
  })
  
################################################################################  
  # TOP 3 
################################################################################
  
# répartition des product family   
  output$nuage_ca_qty_subfamily <- renderPlotly({
    ggplot(plus_vendu,aes(x=plus_vendu$`sum(ca_total)`,y=plus_vendu$`sum(qty_total)`,col = product_subfamily))+
      geom_point()+
      labs(title = paste("Dispersion du chiffre d'affaire par la somme des quantités vendues des",str_to_lower(input$choix_top3), x = "Somme du chiffre d'affaire", y = "Somme des quantités vendues"))+
      theme(axis.text.x = element_text(face = "bold", color = "black", 
                                       size = 8,hjust = 1))
     
  })
  
# CA total top 3
  output$CA_TOP3 <- renderText({
    formatC(sum(top3$ca_total),format="d",big.mark = " ",decimal.mark = ",")
  })
  
# CA top 3 variable choisie   
  output$CA_TOP3_choix <- renderText({
    formatC(sum(top3$ca_total[top3$product_subfamily %in% input$choix_top3]),format="d",big.mark = " ",decimal.mark = ",")
  })
  

# table 3 subfamily les + vendus en qt
  output$trois_plus_vendu_qty<- renderTable({
    plus_vendu_qty %>% slice(1:3)
  })
  
# table 3 subfamily les + vendus en CA 
  output$trois_plus_vendu_ca<- renderTable({
    plus_vendu_ca %>% slice(1:3)
  }) 

  
  #Nuage de poins qty qty 
  output$nuage_qty_qty<-renderPlotly({
    nuage_deux <- meuble %>% 
      filter(product_family==input$family_meuble)
    ggplot(nuage_deux, aes(x = qty_web, y = qty_store,col = product_subfamily)) + 
      geom_point()+
      labs(title= paste("Dispersion des quantités vendues en ligne par rapport aux quantités vendues en magasin des ",str_to_lower(input$family_meuble)))+
      xlab("quantités vendues en ligne")+
      ylab("quantités vendues en magasin")+
      theme(axis.text.x = element_text(face = "bold", color = "black", 
                                       size = 8,hjust = 1))
  })
  
################################################################################


  ######################################################################### GIB
  
  output$moyenne_note_GIB <- renderText({
    mean(gib$note_produit,na.rm=T)
  })
  
  output$moyenne_prix_gib <- renderText({
    mean(gib$product_price)
  })
  
  output$moyenne_prix <-renderText({
    mean(product$product_price)
  })

  
  output$bar_ca_gib <- renderPlotly({
    ggplot(gib_groupe,aes(product_activity,ca))+
      geom_bar(stat = "identity")+
      labs(x = "Type de produit", y = "Chiffre d'affaire")+
      theme(axis.text.x = element_text(face = "bold", color = "black", 
                                       size = 8,hjust = 1))
  })
  
  output$bar_qty_gib <- renderPlotly({
    ggplot(gib_groupe,aes(product_activity,qty))+
      geom_bar(stat = "identity")+
      labs(x = "Type de produit", y = "Quantités vendues")+
      theme(axis.text.x = element_text(face = "bold", color = "black", 
                                       size = 8,hjust = 1))
  })
  
}) # fin server
