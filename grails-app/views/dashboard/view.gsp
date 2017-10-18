<!DOCTYPE html>
<html lang="en-US" dir="ltr">
  <head>
    <meta name="layout" content="main2" />
  </head>
  <body data-spy="scroll" data-target=".onpage-navigation" data-offset="60">

    <style>
      .footer {
        position: relative;
      }
    </style>

    <input type="hidden" value="${hamper.id}" id="id">

    <main>
        <!-- Product Card -->
        <section class="module">
          <div class="container">
            <div class="row">
              <!-- Images -->
              <div class="col-sm-6 mb-sm-40">
                <a class="gallery" href="${createLink(action: 'renderImage', controller:'image', params: [id: hamper.image.generatedName])}">
                  <img src="${createLink(action: 'renderImage', controller:'image', params: [id: hamper.image.generatedName])}"/>
                </a>

                <%--
                <ul class="product-gallery">
                  <li><a class="gallery" href="../assets/images/shop/product-8.jpg"></a><img src="../assets/images/shop/product-8.jpg" alt="Single Product"/></li>
                  <li><a class="gallery" href="../assets/images/shop/product-9.jpg"></a><img src="../assets/images/shop/product-9.jpg" alt="Single Product"/></li>
                  <li><a class="gallery" href="../assets/images/shop/product-10.jpg"></a><img src="../assets/images/shop/product-10.jpg" alt="Single Product"/></li>
                </ul>
                --%>
              </div>

              <!-- Product Overall -->
              <div class="col-sm-6">
                <div class="row">
                  <div class="col-sm-12">
                    <h1 class="product-title font-alt">
                      ${hamper.name}
                    </h1>
                  </div>
                </div>

                <div class="row mb-20">
                  <div class="col-sm-12"><span><i class="fa fa-star star"></i></span><span><i class="fa fa-star star"></i></span><span><i class="fa fa-star star"></i></span><span><i class="fa fa-star star"></i></span><span><i class="fa fa-star star-off"></i></span><a class="open-tab section-scroll" href="#reviews">-Popularity</a>
                  </div>
                </div>

                <div class="row mb-20">
                  <div class="col-sm-12">
                    <div class="price font-alt">
                      <span class="amount">
                        RM ${hamper.price}
                      </span>
                    </div>
                  </div>
                </div>

                <div class="row mb-20">
                  <div class="col-sm-12">
                    <div class="description">
                      <p>
                        ${hamper.shortDescription}
                      </p>
                    </div>
                  </div>
                </div>

                <div class="row mb-20">
                  <div class="col-sm-4 mb-sm-20">
                    <input id="quantity" class="form-control input-lg" type="number" name="" value="1" max="40" min="1" required="required"/>
                  </div>
                  <div class="col-sm-8"><button class="btn btn-lg btn-block btn-round btn-b" id="addCartBtn">Add To Cart</button></div>
                </div>

                <div class="row mb-20">
                  <div class="col-sm-12">
                    <div class="product_meta">Items Included:<a href="#"> Wine, </a><a href="#">Chocloate, </a><a href="#">Ginseng</a>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            <a class="btn btn-g btn-round" type="submit" href="${createLink(action: 'list', controller:'dashboard')}">Back</a>

            <!-- Product Details -->
            <div class="row mt-70">
              <div class="col-sm-12">
                <ul class="nav nav-tabs font-alt" role="tablist">
                  <li class="active"><a href="#description" data-toggle="tab"><span class="icon-tools-2"></span>Description</a></li>
                  <li><a href="#data-sheet" data-toggle="tab"><span class="icon-tools-2"></span>Data sheet</a></li>
                  <%-- <li><a href="#reviews" data-toggle="tab"><span class="icon-tools-2"></span>Reviews (2)</a></li>--%>
                </ul>

                <div class="tab-content">
                  <div class="tab-pane active" id="description">
                    ${raw(hamper.description)}
                  </div>

                  <div class="tab-pane" id="data-sheet">
                    <table class="table table-striped ds-table table-responsive">
                      <tbody>
                        <tr>
                          <th>Name</th>
                          <th>${hamper.name}</th>
                        </tr>
                        <tr>
                          <td>Stock Left</td>
                          <td>${hamper.quantity}</td>
                        </tr>
                      </tbody>
                    </table>
                  </div>

                  <%--<div class="tab-pane" id="reviews">
                    <div class="comments reviews">
                      <div class="comment clearfix">
                        <div class="comment-avatar"><img src="" alt="avatar"/></div>
                        <div class="comment-content clearfix">
                          <div class="comment-author font-alt"><a href="#">John Doe</a></div>
                          <div class="comment-body">
                            <p>The European languages are members of the same family. Their separate existence is a myth. For science, music, sport, etc, Europe uses the same vocabulary. The European languages are members of the same family. Their separate existence is a myth.</p>
                          </div>
                          <div class="comment-meta font-alt">Today, 14:55 -<span><i class="fa fa-star star"></i></span><span><i class="fa fa-star star"></i></span><span><i class="fa fa-star star"></i></span><span><i class="fa fa-star star"></i></span><span><i class="fa fa-star star-off"></i></span>
                          </div>
                        </div>
                      </div>
                      <div class="comment clearfix">
                        <div class="comment-avatar"><img src="" alt="avatar"/></div>
                        <div class="comment-content clearfix">
                          <div class="comment-author font-alt"><a href="#">Mark Stone</a></div>
                          <div class="comment-body">
                            <p>Europe uses the same vocabulary. The European languages are members of the same family. Their separate existence is a myth.</p>
                          </div>
                          <div class="comment-meta font-alt">Today, 14:59 -<span><i class="fa fa-star star"></i></span><span><i class="fa fa-star star"></i></span><span><i class="fa fa-star star"></i></span><span><i class="fa fa-star star-off"></i></span><span><i class="fa fa-star star-off"></i></span>
                          </div>
                        </div>
                      </div>
                    </div>
                    <div class="comment-form mt-30">
                      <h4 class="comment-form-title font-alt">Add review</h4>
                      <form method="post">
                        <div class="row">
                          <div class="col-sm-4">
                            <div class="form-group">
                              <label class="sr-only" for="name">Name</label>
                              <input class="form-control" id="name" type="text" name="name" placeholder="Name"/>
                            </div>
                          </div>
                          <div class="col-sm-4">
                            <div class="form-group">
                              <label class="sr-only" for="email">Name</label>
                              <input class="form-control" id="email" type="text" name="email" placeholder="E-mail"/>
                            </div>
                          </div>
                          <div class="col-sm-4">
                            <div class="form-group">
                              <select class="form-control">
                                <option selected="true" disabled="">Rating</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                              </select>
                            </div>
                          </div>
                          <div class="col-sm-12">
                            <div class="form-group">
                              <textarea class="form-control" id="" name="" rows="4" placeholder="Review"></textarea>
                            </div>
                          </div>
                          <div class="col-sm-12">
                            <button class="btn btn-round btn-d" type="submit">Submit Review</button>
                          </div>
                        </div>
                      </form>
                    </div>
                  </div>--%>

                </div>
              </div>
            </div>
          </div>
        </section>

        <hr class="divider-w">

        <!-- Related Products -->
        <section class="module">
          <div class="container">

            <div class="row">
              <div class="col-sm-6 col-sm-offset-3">
                <h2 class="module-title font-alt">Related products</h2>
              </div>
            </div>

            <div class="row">
              <div class="owl-carousel text-center" data-items="5" data-pagination="false" data-navigation="false">

                <g:each var="relatedHamper" in="${relatedHampers}">
                  <div class="owl-item">
                    <div class="col-sm-12">
                      <div class="ex-product">
                        <a href="${createLink(action: 'view', controller:'dashboard', params: [id: relatedHamper.id])}">
                          <img src="${createLink(action: 'renderImage', controller:'image', params: [id: relatedHamper.image.generatedName])}"/>
                        </a>
                        <h4 class="shop-item-title font-alt">
                          <a href="${createLink(action: 'view', controller:'dashboard', params: [id: relatedHamper.id])}">
                            ${relatedHamper.name}
                          </a>
                        </h4>
                        RM ${relatedHamper.price}
                      </div>
                    </div>
                  </div>
                </g:each>

              </div>
            </div>
          </div>
        </section>

      </div>
    </main>

    <script>
        $("#addCartBtn").click(function() {
          $.ajax({
              url: "${createLink(controller: 'dashboard', action: 'addToCart')}",
              type: 'POST',
              data: { id: $("#id").val(), quantity: $("#quantity").val() },
              success: function(result) {
                  $('#cartModal').modal('show');
              }
          });
          $("#quantity").val("1");
        });
    </script>

  </body>
</html>