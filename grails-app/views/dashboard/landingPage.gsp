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
    <link rel="apple-touch-icon" sizes="57x57" href="../assets/images/favicons/apple-icon-57x57.png">
    <link rel="apple-touch-icon" sizes="60x60" href="../assets/images/favicons/apple-icon-60x60.png">
    <link rel="apple-touch-icon" sizes="72x72" href="../assets/images/favicons/apple-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="76x76" href="../assets/images/favicons/apple-icon-76x76.png">
    <link rel="apple-touch-icon" sizes="114x114" href="../assets/images/favicons/apple-icon-114x114.png">
    <link rel="apple-touch-icon" sizes="120x120" href="../assets/images/favicons/apple-icon-120x120.png">
    <link rel="apple-touch-icon" sizes="144x144" href="../assets/images/favicons/apple-icon-144x144.png">
    <link rel="apple-touch-icon" sizes="152x152" href="../assets/images/favicons/apple-icon-152x152.png">
    <link rel="apple-touch-icon" sizes="180x180" href="../assets/images/favicons/apple-icon-180x180.png">
    <link rel="icon" type="image/png" sizes="192x192" href="../assets/images/favicons/android-icon-192x192.png">
    <link rel="icon" type="image/png" sizes="32x32" href="../assets/images/favicons/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="96x96" href="../assets/images/favicons/favicon-96x96.png">
    <link rel="icon" type="image/png" sizes="16x16" href="../assets/images/favicons/favicon-16x16.png">
    <link rel="manifest" href="/manifest.json">
    <meta name="msapplication-TileColor" content="#ffffff">
    <meta name="msapplication-TileImage" content="assets/images/favicons/ms-icon-144x144.png">
    <meta name="theme-color" content="#ffffff">
    <!--  
    Stylesheets
    =============================================
    
    -->
    <!-- Default stylesheets-->
    <link href="../assets/lib/bootstrap/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Template specific stylesheets-->
    <link href="../assets/css/roboto_condensed.css" rel="stylesheet">
    <link href="../assets/css/volkhov.css" rel="stylesheet">
    <link href="../assets/css/open_sans.css" rel="stylesheet">
    <link href="../assets/lib/animate.css/animate.css" rel="stylesheet">
    <link href="../assets/lib/components-font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <link href="../assets/lib/et-line-font/et-line-font.css" rel="stylesheet">
    <link href="../assets/lib/flexslider/flexslider.css" rel="stylesheet">
    <link href="../assets/lib/owl.carousel/dist/assets/owl.carousel.min.css" rel="stylesheet">
    <link href="../assets/lib/magnific-popup/dist/magnific-popup.css" rel="stylesheet">
    <link href="../assets/lib/simple-text-rotator/simpletextrotator.css" rel="stylesheet">
    <!-- Main stylesheet and color file-->
    <link href="../assets/css/style.css" rel="stylesheet">
    <link id="color-scheme" href="../assets/css/colors/default.css" rel="stylesheet">

    <!--  
    JavaScripts
    =============================================
    -->
    <script src="../assets/lib/jquery/dist/jquery.js"></script>
    <script src="../assets/lib/bootstrap/dist/js/bootstrap.min.js"></script>
    <script src="../assets/lib/wow/dist/wow.js"></script>
    <script src="../assets/lib/jquery.mb.ytplayer/dist/jquery.mb.YTPlayer.js"></script>
    <script src="../assets/lib/isotope/dist/isotope.pkgd.js"></script>
    <script src="../assets/lib/imagesloaded/imagesloaded.pkgd.js"></script>
    <script src="../assets/lib/flexslider/jquery.flexslider.js"></script>
    <script src="../assets/lib/owl.carousel/dist/owl.carousel.min.js"></script>
    <script src="../assets/lib/smoothscroll.js"></script>
    <script src="../assets/lib/magnific-popup/dist/jquery.magnific-popup.js"></script>
    <script src="../assets/lib/simple-text-rotator/jquery.simple-text-rotator.min.js"></script>
    <script src="../assets/js/plugins.js"></script>
    <script src="../assets/js/main.js"></script>
	 <asset:javascript src="gratitude.js"/>

   <style>
      .footer {
        position: relative;
      }
    </style>

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
      <nav class="navbar navbar-custom navbar-fixed-top navbar-transparent" role="navigation">
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

      <!-- Slider -->
      <section class="home-section home-fade home-full-height" id="home">
        <div class="hero-slider">
          <ul class="slides">

            <li class="bg-dark-30 bg-dark shop-page-header" style="background-image:url('../assets/images/shop/cover5.jpg');">
              <div class="titan-caption">
                <div class="caption-content">
                  <div class="font-alt mb-30 titan-title-size-1"><g:message code="client.name.label"/></div>
                  <div class="font-alt mb-40 titan-title-size-4">Exclusive products</div><a class="section-scroll btn btn-border-w btn-round" href="${createLink(action: 'list', controller:'dashboard')}">Learn More</a>
                </div>
              </div>
            </li>

            <li class="bg-dark-30 bg-dark shop-page-header" style="background-image:url('../assets/images/shop/cover6.png');">
              <div class="titan-caption">
                <div class="caption-content">
                  <div class="font-alt mb-30 titan-title-size-1"><g:message code="client.name.label"/></div>
                  <div class="font-alt mb-30 titan-title-size-4">2017</div>
                  <div class="font-alt mb-40 titan-title-size-1">Your online gift destination</div><a class="section-scroll btn btn-border-w btn-round" href="${createLink(action: 'list', controller:'dashboard')}">Learn More</a>
                </div>
              </div>
            </li>

          </ul>
        </div>
      </section>

      <!-- Content -->
      <div class="main">
        <section class="module-small">
          <div class="container">
            <!-- Header -->
            <div class="row">
              <div class="col-sm-6 col-sm-offset-3">
                <h2 class="module-title font-alt">Latest in Store</h2>
              </div>
            </div>
            <!-- Item -->
            <div class="row multi-columns-row">

              <g:each var="hamper" in="${hampers}">
                <div class="col-sm-6 col-md-3 col-lg-3">

                    <div class="shop-item">
                      <div class="shop-item-image">
                        <!-- Image -->
                        <img src="${createLink(action: 'renderImage', controller:'image', params: [id: hamper.image.generatedName])}" style="min-height: 250px; max-height: 250px;"/>
                        <!-- On Hover -->
                        <div class="shop-item-detail">
                          <a class="btn btn-round btn-b" href="${createLink(action: 'view', controller:'dashboard', params: [id: hamper.id])}">View Details</a>
                        </div>
                      </div>
                      <!-- Detail -->
                      <h4 class="shop-item-title font-alt"><a href="${createLink(action: 'view', controller:'dashboard', params: [id: hamper.id])}">${hamper.name}</a></h4>RM ${hamper.price}

                    </div>
                </div>
              </g:each>

            </div>
            <!-- Bottom -->
            <div class="row mt-30">
              <div class="col-sm-12 align-center">
                <a class="btn btn-b btn-round" href="${createLink(action: 'list', controller:'dashboard')}">See all products</a>
              </div>
            </div>
          </div>
        </section>

        <!-- Content 2 -->
        <section class="module">
          <div class="container">

            <div class="row">
              <div class="col-sm-6 col-sm-offset-3">
                <h2 class="module-title font-alt">Exclusive products</h2>
                <div class="module-subtitle font-serif">The languages only differ in their grammar, their pronunciation and their most common words.</div>
              </div>
            </div>

            <div class="row">
              <div class="owl-carousel text-center" data-items="5" data-pagination="false" data-navigation="false">

                <g:each var="exclusiveHamper" in="${exclusiveHampers}">
                  <div class="owl-item">
                    <div class="col-sm-12">
                      <div class="ex-product">
                        <a href="${createLink(action: 'view', controller:'dashboard', params: [id: exclusiveHamper.id])}">
                          <img src="${createLink(action: 'renderImage', controller:'image', params: [id: exclusiveHamper.image.generatedName])}"/>
                        </a>
                        <h4 class="shop-item-title font-alt">
                          <a href="${createLink(action: 'view', controller:'dashboard', params: [id: exclusiveHamper.id])}">
                            ${exclusiveHamper.name}
                          </a>
                        </h4>
                        RM ${exclusiveHamper.price}
                      </div>
                    </div>
                  </div>
                </g:each>

              </div>
            </div>
          </div>
        </section>

      </div>

      <!-- Footer -->      
      <g:render template="/shared/footer"/>
	  
	  <script>
        $(document).ready(function(){
            $('#cartModal').on('shown.bs.modal', function() {
                var ajaxUrl = "${createLink(controller: 'dashboard', action: 'getCartList')};"
                refreshSoppingList(ajaxUrl);
            });

            <sec:ifLoggedIn>

              if (localStorage.getItem("previousSessionId") != null) {

                $.ajax({
                  url: "${createLink(controller: 'dashboard', action: 'transferShoppingCart')}",
                  type: 'POST',
                  data: { previousSessionId: localStorage.getItem("previousSessionId") },
                  success: function(result) {
                    localStorage.removeItem("previousSessionId");

                    if (localStorage.getItem("paying") == "true") {
                      localStorage.removeItem("paying");
                      window.location.href="${createLink(controller: 'dashboard', action: 'checkout')}";
                    }
                  },
                  error: function(result) {
                  }
                });

              }

            </sec:ifLoggedIn>           

        });
    </script>

    </main>
  </body>
</html>