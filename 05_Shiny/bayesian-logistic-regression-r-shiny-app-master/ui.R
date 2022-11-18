## This code determines the appearance of the Rshiny app.

shinyUI(fluidPage(

  ## Disable all download buttons until something is available to download!
  singleton(tags$head(HTML(
    '
  <script type="text/javascript">
    $(document).ready(function() {
      // disable download at startup. downloadSelectionPlot is the id of the downloadButton
      $("#downloadSelectionPlot").attr("disabled", "true").attr("onclick", "return false;");

      Shiny.addCustomMessageHandler("download_ready_selection_plot", function(message) {
        $("#downloadSelectionPlot").removeAttr("disabled").removeAttr("onclick").html(
          "<i class=\\"fa fa-download\\"></i>Download variable selection plot");
      });
    })
  </script>
'
  ))),
  
  singleton(tags$head(HTML(
    '
  <script type="text/javascript">
    $(document).ready(function() {
      // disable download at startup. downloadSummaryWithSelection is the id of the downloadButton
      $("#downloadSummaryWithSelection").attr("disabled", "true").attr("onclick", "return false;");

      Shiny.addCustomMessageHandler("download_ready_summary_with_selection", function(message) {
        $("#downloadSummaryWithSelection").removeAttr("disabled").removeAttr("onclick").html(
          "<i class=\\"fa fa-download\\"></i>Download variable selection summary");
      });
    })
  </script>
'
  ))),
  
  
  singleton(tags$head(HTML(
    '
  <script type="text/javascript">
    $(document).ready(function() {
      // disable download at startup. downloadSummary is the id of the downloadButton
      $("#downloadSummary").attr("disabled", "true").attr("onclick", "return false;");

      Shiny.addCustomMessageHandler("download_ready_summary", function(message) {
        $("#downloadSummary").removeAttr("disabled").removeAttr("onclick").html(
          "<i class=\\"fa fa-download\\"></i>Download model summary");
      });
    })
  </script>
'
  ))),
  
  singleton(tags$head(HTML(
    '
  <script type="text/javascript">
    $(document).ready(function() {
      // disable download at startup. downloadTestSummary is the id of the downloadButton
      $("#downloadTestSummary").attr("disabled", "true").attr("onclick", "return false;");

      Shiny.addCustomMessageHandler("download_ready_summary_test", function(message) {
        $("#downloadTestSummary").removeAttr("disabled").removeAttr("onclick").html(
          "<i class=\\"fa fa-download\\"></i>Download results from test data");
      });
    })
  </script>
'
  ))),
  
  singleton(tags$head(HTML(
    '
  <script type="text/javascript">
    $(document).ready(function() {
      // disable download at startup. downloadROC is the id of the downloadButton
      $("#downloadROC").attr("disabled", "true").attr("onclick", "return false;");

      Shiny.addCustomMessageHandler("download_ready_ROCplot", function(message) {
        $("#downloadROC").removeAttr("disabled").removeAttr("onclick").html(
          "<i class=\\"fa fa-download\\"></i>Download ROC plot");
      });
    })
  </script>
'
  ))),
  
  singleton(tags$head(HTML(
    '
  <script type="text/javascript">
    $(document).ready(function() {
      // disable download at startup. downloadPlots is the id of the downloadButton
      $("#downloadPlots").attr("disabled", "true").attr("onclick", "return false;");

      Shiny.addCustomMessageHandler("download_ready_plots", function(message) {
        $("#downloadPlots").removeAttr("disabled").removeAttr("onclick").html(
          "<i class=\\"fa fa-download\\"></i>Download plots");
      });
    })
  </script>
'
  ))),
  
  ## Originally diable all tabs other than 'Training data input' and 'Test data input'.
  tags$head(tags$script("
        window.onload = function() {
            $('#tabs a:contains(\"Training data\")').parent().addClass('disabled');
            $('#tabs a:contains(\"Test data\")').parent().addClass('disabled');
            $('#tabs a:contains(\"Prior\")').parent().addClass('disabled');
            $('#tabs a:contains(\"Model summary and plots\")').parent().addClass('disabled');
            $('#tabs a:contains(\"Variable selection information\")').parent().addClass('disabled');
            $('#tabs a:contains(\"Test data results\")').parent().addClass('disabled');

        };

        Shiny.addCustomMessageHandler('activeNavs', function(nav_label) {
            $('#tabs a:contains(\"' + nav_label + '\")').parent().removeClass('disabled');
        });
   ")),
  
  
  

  
  
  ## Define title of whole app.
  titlePanel("Bayesian Logistic Regression Analysis"),
  
  sidebarLayout(
    sidebarPanel(
      
      ## Create navigation list on the side panel. Include headings and tab names.
      ## This is always visible.
      navlistPanel(id='tabs', widths=c(12,1), well=F, selected='Training data input',
                   "Data Input",
                   tabPanel("Training data input"),          
                   tabPanel("Test data input"),
                   
                   "View Data and Define Model",
                   tabPanel("Training data"),
                   tabPanel("Test data"),
                   
                   "Prior Elicitation",
                   tabPanel("Prior"),
                   
                   "Model building",
                   tabPanel("Model summary and plots"),
                   tabPanel("Variable selection information"),
                   
                   "Test Data Results",
                   tabPanel("Test data results"))    

),

  mainPanel(
    
    ## Define what appears in the main panel.
    ## This will change accoridng to tab.
    
    ## Introduction text seen on all tabs.
    wellPanel(htmlOutput('intro')),
    
    wellPanel(
      
          ## Training data input
          conditionalPanel("$('li.active a').first().html()==='Training data input'",
                               
                     fileInput('datafile','Use the file selector below to upload your training data.'),
                     helpText('Data must be uploaded as a .csv file.'),         
                     helpText('Ensure all variables to be treated as factors have ".factor" as a suffix to their variable name.'),
                     helpText('All factor variables should be numerically coded from 0. 0 will be used as the reference level.'),
                     tabPanel("Training data input")
                     
                ),
          
          ## Test data input
          conditionalPanel("$('li.active a').first().html()==='Test data input'",
                                
                    fileInput('datafile_test','Use the file selector below to upload your test data.'),
                    helpText('Data must be uploaded as a .csv file.'),  
                    helpText('Ensure column names match those given in the training data.'),
                    helpText('Ensure all variables to be treated as factors have ".factor" as a suffix to their variable name.'),
                    helpText('All factor variables should be numerically coded from 0. 0 will be used as the reference level.'),
                    helpText('In addition, current functionality requires all factor levels in the training data to be present in the test data.'),
                    tabPanel("Test data input")
                     
                ),
    
          ## Visualise training data
          conditionalPanel("$('li.active a').first().html()==='Training data'",
                                 
                          uiOutput('dv'),
                          htmlOutput('dv_explain'),
                          uiOutput('iv'),
                          helpText('Please note this implementation does not currently support the inclusion of an interaction term between two factor variables.'),
                          htmlOutput('interactions_explain'),
                          helpText('   '),
                          uiOutput('var_selection'),
                          tabPanel("Training data", dataTableOutput('data_table'))
                     
                ),
    
          ## Define and visualise prior distributions
          conditionalPanel("$('li.active a').first().html()==='Prior'",
                                 
                     uiOutput('num_priors'),
                     conditionalPanel(condition='input.num_priors == "Yes"', uiOutput('norm_options')), 
                     tabPanel("Prior", conditionalPanel(condition='input.num_priors =="Yes"',
                     plotOutput('prior')))
                     
                  ),
                     
          ## Create and download model summary and plots
          conditionalPanel("$('li.active a').first().html()==='Model summary and plots'",
                                   
                          htmlOutput('model_explain'),
                          tabPanel("Model summary", verbatimTextOutput('model_summary'), helpText('    '), downloadButton('downloadSummary', 'Download model summary')),
                          helpText('    '),
                          helpText('Only plots of the last three variables are shown here. Download file below for plots of all variables.'),
                          helpText('   '),
                          tabPanel("Model plots", plotOutput('model_plot'), helpText('    '), downloadButton('downloadPlots', 'Download plots'))
                 
                           ),
                     
            
          ## View information on variable selection.
          conditionalPanel("$('li.active a').first().html()==='Variable selection information'",

                            tabPanel("Variable selection information", 
                                      
                                    htmlOutput('var_selection_explain'),                  
                                    verbatimTextOutput('model_with_selection_summary'),
                                    downloadButton('downloadSummaryWithSelection', 'Download variable selection summary'),
                                    helpText('   '),
                                    plotOutput('model_with_selection_plot'),
                                    helpText('   '),
                                    downloadButton('downloadSelectionPlot', 'Download variable selection plot'),
                                    helpText('   '),
                                    htmlOutput('variables_prob_0.5_text'),
                                    helpText('If one level of a factor variable meets the probability criterion, all are included in the re-modeling.'),
                                    uiOutput('cutoff_prob'),
                                    helpText('   '),
                                    uiOutput('remodel'))
                             
            ),
                     
          ## Visualize test data
          conditionalPanel("$('li.active a').first().html()==='Test data'",
                                   
                          tabPanel("Test data", htmlOutput('test_upload'), dataTableOutput('data_table_test'))
                                   
                  ),
                     
          ## View results in test data
          conditionalPanel("$('li.active a').first().html()==='Test data results'",
                                   
                          tabPanel("Test data results", verbatimTextOutput('test_summary'), downloadButton('downloadTestSummary', 'Download results from test data'), helpText('   '), plotOutput('roc_plot'), helpText('   '), downloadButton('downloadROC', 'Download ROC plot'))
                                     
                  )       
                     
                     )
      



    )
)
))

