<!DOCTYPE html>
<html lang="en-US" dir="ltr">
  <head>
    <meta name="layout" content="main" />
  </head>
  <body data-spy="scroll" data-target=".onpage-navigation" data-offset="60">

    <style>
      .footer {
        position: relative;
      }
    </style>
    
    <main>
      <div class="main">

        <section class="module bg-dark-60 shop-page-header" data-background="../assets/images/shop/cover6.png">
          <div class="container">
            <div class="row">
              <div class="col-sm-6 col-sm-offset-3">
                <h2 class="module-title font-alt">Shop Products</h2>
                <div class="module-subtitle font-serif">A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart.</div>
              </div>
            </div>
          </div>
        </section>

        <!-- Filter and Sorting -->
        <section class="module-small">
          <div class="container">
            <form class="row">
              <div class="col-sm-4 mb-sm-20">
                <select class="form-control">
                  <option selected="selected">Default Sorting</option>
                  <option>Popular</option>
                  <option>Latest</option>
                  <option>Average Price</option>
                  <option>High Price</option>
                  <option>Low Price</option>
                </select>
              </div>
              <div class="col-sm-2 mb-sm-20">
                <select class="form-control">
                  <option selected="selected">All</option>
                  <option>With Wine</option>
                  <option>With Chocloate</option>
                </select>
              </div>
              <div class="col-sm-3 mb-sm-20">
                <select class="form-control">
                  <option selected="selected">All</option>
                  <option>Christmas</option>
                  <option>New Year</option>
                  <option>Hari Gawai</option>
                </select>
              </div>
              <div class="col-sm-3">
                <button class="btn btn-block btn-round btn-g" type="submit">Apply</button>
              </div>
            </form>
          </div>
        </section>

        <hr class="divider-w">

        <!-- Products List -->
        <section class="module-small">
          <div class="container">
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
          </div>
        </section>

      </div>
    </main>
  </body>
</html>