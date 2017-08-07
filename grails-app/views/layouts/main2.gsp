<!DOCTYPE html>
<html lang="en-US" dir="ltr">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!--  
    Document Title
    =============================================
    -->
    <title>Gratitude Hampers</title>
    <!--  
    Favicons
    =============================================
    -->
    <link rel="apple-touch-icon" sizes="57x57" href="../../assets/images/favicons/apple-icon-57x57.png">
    <link rel="apple-touch-icon" sizes="60x60" href="../../assets/images/favicons/apple-icon-60x60.png">
    <link rel="apple-touch-icon" sizes="72x72" href="../../assets/images/favicons/apple-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="76x76" href="../../assets/images/favicons/apple-icon-76x76.png">
    <link rel="apple-touch-icon" sizes="114x114" href="../../assets/images/favicons/apple-icon-114x114.png">
    <link rel="apple-touch-icon" sizes="120x120" href="../../assets/images/favicons/apple-icon-120x120.png">
    <link rel="apple-touch-icon" sizes="144x144" href="../../assets/images/favicons/apple-icon-144x144.png">
    <link rel="apple-touch-icon" sizes="152x152" href="../../assets/images/favicons/apple-icon-152x152.png">
    <link rel="apple-touch-icon" sizes="180x180" href="../../assets/images/favicons/apple-icon-180x180.png">
    <link rel="icon" type="image/png" sizes="192x192" href="../../assets/images/favicons/android-icon-192x192.png">
    <link rel="icon" type="image/png" sizes="32x32" href="../../assets/images/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="96x96" href="../../assets/images/favicons/favicon-96x96.png">
    <link rel="icon" type="image/png" sizes="16x16" href="../../assets/images/favicons/favicon-16x16.png">
    <link rel="manifest" href="/manifest.json">
    <meta name="msapplication-TileColor" content="#ffffff">
    <meta name="msapplication-TileImage" content="assets/images/favicons/ms-icon-144x144.png">
    <meta name="theme-color" content="#ffffff">
    <!--  
    Stylesheets
    =============================================
    
    -->
    <!-- Default stylesheets-->
    <link href="../../assets/lib/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Template specific stylesheets-->
    <link href="../../assets/css/roboto_condensed.css" rel="stylesheet">
    <link href="../../assets/css/volkhov.css" rel="stylesheet">
    <link href="../../assets/css/open_sans.css" rel="stylesheet">
    <link href="../../assets/lib/animate.css/animate.css" rel="stylesheet">
    <link href="../../assets/lib/components-font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <link href="../../assets/lib/et-line-font/et-line-font.css" rel="stylesheet">
    <link href="../../assets/lib/flexslider/flexslider.css" rel="stylesheet">
    <link href="../../assets/lib/owl.carousel/dist/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="../../assets/lib/owl.carousel/dist/assets/owl.theme.default.min.css" rel="stylesheet">
    <link href="../../assets/lib/magnific-popup/dist/magnific-popup.css" rel="stylesheet">
    <link href="../../assets/lib/simple-text-rotator/simpletextrotator.css" rel="stylesheet">
    <!-- Main stylesheet and color file-->
    <link href="../../assets/css/style.css" rel="stylesheet">
    <link id="color-scheme" href="../../assets/css/colors/default.css" rel="stylesheet">

    <!--  
    JavaScripts
    =============================================
    -->
    <script src="../../assets/lib/jquery/dist/jquery.js"></script>
    <script src="../../assets/lib/bootstrap/dist/js/bootstrap.min.js"></script>
    <script src="../../assets/lib/wow/dist/wow.js"></script>
    <script src="../../assets/lib/jquery.mb.ytplayer/dist/jquery.mb.YTPlayer.js"></script>
    <script src="../../assets/lib/isotope/dist/isotope.pkgd.js"></script>
    <script src="../../assets/lib/imagesloaded/imagesloaded.pkgd.js"></script>
    <script src="../../assets/lib/flexslider/jquery.flexslider.js"></script>
    <script src="../../assets/lib/owl.carousel/dist/owl.carousel.min.js"></script>
    <script src="../../assets/lib/smoothscroll.js"></script>
    <script src="../../assets/lib/magnific-popup/dist/jquery.magnific-popup.js"></script>
    <script src="../../assets/lib/simple-text-rotator/jquery.simple-text-rotator.min.js"></script>
    <script src="../../assets/js/plugins.js"></script>
    <script src="../../assets/js/main.js"></script>
    <script src="../../assets/lib/bootstrapValidator.min.js"></script>
    <asset:javascript src="gratitude.js"/>

  </head>
  <body data-spy="scroll" data-target=".onpage-navigation" data-offset="60">
    <main>

      <!-- Loader -->
      <div class="page-loader">
        <div class="loader">Loading...</div>
      </div>

      <!-- Cart Modal -->
      <g:render template="/shared/cartModal"/>

      <!-- Navigation Bar -->
      <nav class="navbar navbar-custom navbar-fixed-top" role="navigation">
        <div class="container">

          <!-- Navigation Bar Header -->
          <div class="navbar-header">
            <button class="navbar-toggle" type="button" data-toggle="collapse" data-target="#custom-collapse"><span class="sr-only">Toggle navigation</span><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></button><a class="navbar-brand" href="${createLink(controller:'dashboard', action: 'landingPage')}"><g:message code="client.name.label"/></a>
          </div>

          <!-- Navigation Bar Menu -->
          <div class="collapse navbar-collapse" id="custom-collapse">
            <g:render template="/shared/navbar"/>
          </div>

        </div>
      </nav>

      <!-- Content -->
      <div class="main">
        <g:layoutBody />
      </div>

      <!-- Footer -->      
      <g:render template="/shared/footer"/>

    </main>

    <script>
        $(document).ready(function(){
            $('#cartModal').on('shown.bs.modal', function() {
                var ajaxUrl = "${createLink(controller: 'dashboard', action: 'getCartList')};"
                refreshSoppingList(ajaxUrl);
            });
        });
    </script>

  </body>
</html>