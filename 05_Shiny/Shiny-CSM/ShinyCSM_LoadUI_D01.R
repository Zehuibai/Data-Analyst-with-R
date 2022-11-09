UISidebar <- function(id = "A") {
  ns <- NS(id)
  print("Loading Sidebar...")
  tagList(
    menuItem(paste("Patient data"),
             id = "CSMCont",
             tabName = "CSMCont",
             icon = icon("clipboard"),
             startExpanded = T,
             lapply(modules, function(mdl){
               menuSubItem(CSM.meta.continuous %>% filter(item == mdl) %>% pluck("name"), tabName = paste0(mdl), href = NULL)
             })
    ),
    menuItem(paste("Site data"),
             id = "CSMSite",
             tabName = "CSMSite",
             icon = icon("hospital"),
             startExpanded = T,
             lapply(sites, function(ste){
               print(paste("Test", ste))
               menuSubItem(paste("Site", ste), tabName = paste0(ste), href = NULL)
             })
             
            # lapply(modules, function(mdl){
            #   menuSubItem(paste0(mdl), tabName = paste0(mdl), href = NULL)
            # })
    )#,
    #menuItem(paste("Site data (cat.)"),
    #         id = "CSMCatSite",
    #         tabName = "CSMCat",
    #         icon = icon("bar-chart"),
    #         startExpanded = T,
    #         lapply(1:3, function(mdl){
    #           menuSubItem(paste0("Variable ",mdl), tabName = paste0(mdl), href = NULL)
    #         })
    #)        
  )
}

#itemsubs <- if(scope == "cont"){
#  lapply(modules, function(mdl){
#    print(paste0("Loading UI for ",mdl,"...") )
#    UIBodyCont(mdl)
#  })
#} else if (scope == "sites"){
#  lapply(modules, function(ste){
#    print(paste0("Loading UI for ",ste,"...") )
#    UIBodySite(ste)
#  })
#}




UIBodyWrapper <- function ( id = "A"){
  ns <- NS(id)
  print("Loading body UI...")
   
  scopes <- c("cont", "sites")
  
  tabs <- lapply(scopes, function(scp)
    switch(
      scp,
      cont = lapply(modules, function(mdl){
              print(paste0("Loading UI for ",mdl,"...") )
              UIBodyCont(mdl)
            }),
      sites = lapply(sites, function(ste){
            UIBodySite(ste)
          })
    )
  ) %>% unlist(recursive = F)
  do.call(tabItems, tabs)
}

### UI for site
UIBodySite <- function(id){
  ns <- NS(id)
  print(paste0("Loading UI for ",id,"...") )
  tabItem(tabName = paste0(id),
          UIPagePanelSite(id),
          uiOutput(paste0(id))
  )
}

UIPagePanelSite <- function(id) {
  ns <- NS(id)
  print(paste0("Loading page for ",id,"...") )
  title <- paste0("Site: ",id)
  
  pages.mod1 <- lapply(site.modules.cont$items ,function(mdl){
   UIPageContentSite(mdl)
  })
  
  pages.mod2 <- lapply(site.modules.cat$items ,function(mdl){
    UIPageContentSite(mdl)
  }) 
  
  pages.mod3 <- lapply(site.modules.ord$items ,function(mdl){
    UIPageContentSite(mdl)
  }) 
  
  #pages$id <- "Variables"
  #sidebarLayout(
  sidebarPanel(
    do.call(navlistPanel, c("Cont",pages.mod1)),
    do.call(navlistPanel, c("Cat",pages.mod2)),
    do.call(navlistPanel, c("Ord",pages.mod3))
  )
  #  mainPanel()
 # )
  #navlistPanel(
  #  "Variables",
  #  tagList(pages)
  #)
  
  #pages <- lapply(site.modules.cont$items ,function(mdl){
  #    list(title=mdl, UIPageContentSite(mdl), box_height = "80px")
  #  })
  #
#
  #
  #do.call(
  #  what = verticalTabsetPanel, 
  #  args = lapply(pages, do.call, what = verticalTabPanel)
  #)
  

}


#### ToDo: Start here (somewhere)
UIPageContentSite <- function(id) {
  ns <- NS(id)
  title <- paste0(id)
  tabPanel(id,
    fluidRow(
      box(width = 12,
          title = paste0("ID: ",id) ,
          paste("Hello World")
      )
    )#, uiOutput(paste0(id) )
  )
  #print(paste("creating",id))
 # do.call(tabPanel, list(title = id, page))
}

### UI for cont
UIBodyCont <- function(id){
  ns <- NS(id)
  tabItem(tabName = paste0(id),
          UIPageContentCont(id),
          uiOutput(paste0(id))
  )
}

UIPageContentCont <- function(id) {
  ns <- NS(id)
  title <- paste0(CSM.meta.continuous$name[which(CSM.meta.continuous$item == id)], 
                  " [",
                  CSM.meta.continuous$unit[which(CSM.meta.continuous$item == id)],
                  "]")
  fluidRow(
    box(width = 12,
        title = paste0("ID: ",id) ,
        visitSelectionUI(id),
        siteSelectionUI(id),
        contScatterPlotUI(id)
    ),
    box(width = 12,
        title = paste0("Subject data for ",id) ,
        contSubjectLinePlotUI(id)
    )
  )
}
