

header = dashboardHeader(title="Application")

#Liste des onglets

sidebar = dashboardSidebar(  
  
  sidebarMenu(
    menuItem("Extrait des données", tabName = "Extrait", icon=icon("dashboard")),
    
    menuItem("Statistiques", icon=icon("th"),tabName="Statistiques"),
    
    menuItem("Global",tabName="Global",icon=icon("magnifying-glass-chart")),
    
    menuItem("Meubles",tabName="Meuble",icon=icon("cabinet-filing")),
    
    submitButton("", icon=("GO"))
      
  )#fin sidebarMenu
  
)#fin sideBar



body = dashboardBody(  
  
  tabItems(
  
    tabItem(tabName = "Extrait",
            fluidRow(
              box(
                sliderInput("nbdonnes", label = h3("Nombre de lignes affichées"), min = 0, 
                        max = 100, value = 10)
            )#fin box
            ),#fin fluidrow
            
            fluidRow(
            box(h3("Extrait des données"),tableOutput("view"),style='overflow-x: scroll;',width = 12)
            )#fin fluidRow
            ), #fin tabItem
    
    tabItem(tabName = "Statistiques",
            
            tabBox(width="100",
                   tabPanel("Structure des données",
                            box(verbatimTextOutput("structure"), width="100")
                   ),#fin tabPanel
                   
                   tabPanel("Résumé des données",
                            box(verbatimTextOutput("summary"),width="100")
                   )#fin tabPanel
            )#fin tabBox
            ), #fin tabItem
  
    tabItem(tabName = "Meuble",
            
            tabBox(width = "100",
              
              tabPanel("Generale",
                       selectInput("family_meuble", "Variable:",
                                   c("BUFFETS ET VAISSELIERS","BUREAUX ET SECRETAIRES","FAUTEUILS ET CANAPES","TABLES ET CHAISES","LITS ET CHEVETS","ARMOIRES ET COMMODES","BIBLIOTHEQUES ET ETAGERES","MEUBLES TV","MEUBLES DE SALLE DE BAIN","TABLES BASSES,BOUTS DE CANAPES","MEUBLES ENFANTS","MEUBLES OUTDOOR","MEUBLES DE CUISINE","CONSOLES ET COIFFEUSES")),
                          fluidRow(
                         infoBox("Moyenne des notes des produits",textOutput("moyennenote_meuble"),color = "teal", fill=TRUE, width = 4),
                         infoBox("Chiffre d'affaire", textOutput("CA_MEUBLE"),color = "teal", fill=TRUE,width = 4),
                         infoBox("Taux de conversion", textOutput("taux_conv_meuble"),color = "teal", fill=TRUE,width = 4),
                         
                        ),
                       fluidRow(
                         infoBox("Prix moyen des meubles",textOutput("prix_moyen_prod"),color = "yellow", fill=TRUE,width = 6),
                         infoBox("Prix moyen des meubles selectionne",textOutput("prix_moyen_prod_select"),color = "yellow", fill=TRUE,width = 6)
                         ),
                       fluidRow(
                       box(plotlyOutput("Nuage_CA_family_meuble"),width = 12),
                       box(plotlyOutput("ventes_par_family_store"),width = 10),
                       ),
                   

                       fluidRow(
                         box(plotlyOutput("nuage_qty_qty"),width = 6)
                         
                       )
                         

                         #moyenne des produits GIB 
                         #quelque chose avec product emission CO2 un box plot par famille 

                      
            
                       ), #fin tabPanel
              
              
              tabPanel("Top 3",
                       selectInput("choix_top3", "Variable:", sous_famille),
                       fluidRow(
                         infoBox("CA representer par les 3 sous categories",textOutput("CA_TOP3"),color = "yellow", fill=TRUE,width = 4),
                         infoBox("CA representer par la truc select",textOutput("CA_TOP3_choix"),color = "yellow", fill=TRUE,width = 4),
                       ), #fin fluidRow
                       
                       fluidRow(
                       box(h3("Les 3 produits les plus vendu en quantite"),tableOutput("trois_plus_vendu_qty"),width = 6),
                       box(h3("Les 3 produits qui ont genere le plus en chiffre d'affaire"),tableOutput("trois_plus_vendu_ca"),width = 6),
                       ),#fin fluidRow
                       
                       fluidRow(
                       box(plotlyOutput("nuage_ca_qty_subfamily"),width = 16)
                       )#fin fluidRow
                       
                       
                       #on peux faire 2 top 3 avec le top 3 GIB 
                       #emmission co2 * qte = nb kg CO2 que l'ont peut comparer 
                       #delai d'attente 
                       #VERIFIER AVEC LES AUTRES ONGLETS ET DEPLACER LES IDEE
                       


                       )#fin tab panel
               ) #fin tabBox
          
          ), #fin tabItem
  
    tabItem(tabName = "Global",
            tabBox(width="100",
              tabPanel("Global",
                       selectInput("var_global", "Variable :",
                                   c("mlp","deco","meuble")),
                       fluidRow(
                         infoBox("Moyenne des notes des produits",textOutput("moyennenote_tout"),color = "teal", fill=TRUE, width = 3),
                         infoBox("Chiffre d'affaire", textOutput("CA_tout"),color = "teal", fill=TRUE,width = 3),
                         infoBox("Prix moyen", textOutput("taux_conv_tout"),color = "teal", fill=TRUE,width = 3),
                         infoBox("Taux de transaction web", textOutput("taux_transaction_web"),color = "teal", fill=TRUE,width = 3),
                       ),
                       fluidRow(
                         box(plotlyOutput("Nuage_CA_QTY_global"),width=6),
                         box(plotlyOutput("bar_ca"),width=6)
                       ),
                       fluidRow(
                         box(plotlyOutput("taux_litige_global"),width=6)
                         
                         
                       )
                       ),
              tabPanel("GIB", 
                       h2("Good is Beautiful"),
                       fluidRow( 
                             infoBox("Pourcentage de produit GIB vendu parrapport au total",textOutput("pourcentage_GIB_vendu"),color = "olive",width = 6),
                             infoBox("Pourcentage du CA representer par la gamme GIB",textOutput("pourcentage_CA_GIB_vendu"),color = "olive",width = 6)
                       ),#fin fluidRow
                       fluidRow(
                         infoBox("Moyenne des note produits",textOutput("moyenne_note_GIB"),width = 4),
                         infoBox("Moyenne des prix GIB",textOutput("moyenne_prix_gib"),width = 4),
                         infoBox("Moyenne des prix de tous les produits",textOutput("moyenne_prix"),width = 4)
                       ),
                       fluidRow(
                         
                         box(plotlyOutput("bar_ca_gib"),width=6),
                         box(plotlyOutput("bar_qty_gib"),width=6),
                         
                         
                         
                       )
                       )#fin tabPanel
            )#fin tabBox
      
    )#fin tabItem
  ) #fin tabItems 

  ) #fin dashboardbody




dashboardPage(
  skin = 'green',
  header = header,
  sidebar = sidebar,
  body = body
) #fin dashboardpage 
