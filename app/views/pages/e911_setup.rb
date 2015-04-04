.toparea.container-fluid
  .row
    .leftarea.col-md-9
      %h1 Main Page
    
    .rightarea.col-md-3
      - unless @auth.authorized?
        %a.auth-btn.btn.btn-primary.btn-lg.btn-block{ href: "#{@auth.auth_url}", role: 'button' } Authorize your phone
      - else
        %button.btn.btn-warning.btn-lg{type: "button"}
          %span.glyphicon.glyphicon-phone-alt{'aria-hidden': "true"}
          Star
        %button.btn.btn-success.btn-lg{type: "button"}
          %span.glyphicon.glyphicon-earphone{'aria-hidden': "true"}
          Call in progress

      - if @auth.authorized?
        -  unless @auth.has_e911id?
          .panel-group#accordion{ role: "tablist", 'aria-multiselectable': "true"}
            .panel.panel-info
              .panel-heading#headingOne{ role: "tab" }
                %h4.panel-title
                  %a{'data-toggle': "collapse", 'data-parent': "#accordion", href: "#collapseOne", 'aria-expanded': "true", 'aria-controls': "collapseOne" }
                    Select E911
              #collapseOne.panel-collapse.collapse.in{role: "tabpanel", 'aria-labelledby': "headingOne"}
                .panel-body
                  = render :partial => 'authorizations_e911_contexts/form'
            .panel.panel-info
              .panel-heading#headingTwo{role: "tab"}
                %h4.panel-title
                  %a.collapsed{'data-toggle': "collapse", 'data-parent': "#accordion", href: "#collapseTwo", 'aria-expanded': "false", 'aria-controls': "collapseTwo"}
                    Create New E911
              #collapseTwo.panel-collapse.collapse{role: "tabpanel", 'aria-labelledby': "headingTwo"}
                .panel-body
                  = render :partial => 'e911_contexts/new'


-#           .panel-group#accordian{role: "tablist", 'aria-multiselectable': "true"}
-#           = render :partial => 'authorizations/edit'
-# .panel.panel-info
-#   .panel-heading
-#     %h3.panel-title 
-#       %a{'data-toggle': "collapse", 'data-parent': "#accordion", href: "#collapseTwo", 'aria-expanded': "true", 'aria-controls': "collapseTwo"}
-#         Create New E911
-#           = render :partial => 'e911_contexts/new'




