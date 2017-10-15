<!DOCTYPE html>
<html lang="en-US" dir="ltr">
  <head>
    <meta name="layout" content="main" />
  </head>
  <body data-spy="scroll" data-target=".onpage-navigation" data-offset="60">
    <main>
      <div class="main">
        <div class="container">

          <%-- Title --%>
          <div class="row">
            <div class="col-sm-6 col-sm-offset-3">
              <br />
              <h1 class="module-title font-alt">Checkout</h1>
            </div>
          </div>

          <%-- Shopping Cart List Table --%>
          <div class="row">
            <div class="col-sm-12">
              <table class="table table-striped table-border checkout-table">
                <thead>
                    <tr>
                        <th colspan="2">Product</th>
                        <th>Quantity</th>
                        <th class="text-center">Price</th>
                        <th class="text-center">Total</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                  <g:if test="${products.isEmpty()}">
                    <td colspan="5" class="tkmCenter">No items in your cart.</td>
                  </g:if>
                  <g:else>
                      <g:each var="product" in="${products}">
                      <tr hamperId="${product.id}" hamperPrice="${product.price}">
                          <td class="col-sm-2">
                              <a class="thumbnail pull-left tkmSmallImage" href="${createLink(controller:'dashboard', action: 'view', params: [id: product.id])}">
                                  <img src="${createLink(action: 'renderImage', controller:'image', params: [id: product.imageGeneratedName])}"/>
                              </a>
                          </td>
                          <td class="col-sm-2">
                              <h4 class="media-heading"><a href="${createLink(controller:'dashboard', action: 'view', params: [id: product.id])}">${product.name}</a></h4>
                              <h5 class="media-heading">${product.shortDescription}</h5>
                              <span>Stock left: </span><span class="text-success"><strong>${product.quantity}</strong></span>
                          </td>
                          <td class="col-sm-2">
                              <input class="quantityValue" class="form-control input-lg" type="number" name="" value="${product.cartQuantity}" max="40" min="1" required="required"/>
                          </td>
                          <td class="col-sm-2 text-center text-nowrap">
                              <strong>RM ${product.price}</strong>
                          </td>
                          <td class="col-sm-2 text-center text-nowrap totalPrice">
                              <strong>RM ${product.totalPrice}</strong>
                          </td>
                          <td class="col-sm-2">
                              <button type="button" class="btn btn-danger removeCartBtn" hamperId="${product.id}">
                                  <span class="glyphicon glyphicon-remove"></span> Remove
                              </button>
                          </td>
                      </tr>
                      </g:each>
                  </g:else>
                </tbody>
              </table>
            </div>
          </div>

          <%-- Coupon --%>
          <%-- <div class="row">
            <div class="col-sm-3">
              <div class="form-group">
                <input class="form-control" type="text" id="" name="" placeholder="Coupon code"/>
              </div>
            </div>
            <div class="col-sm-3">
              <div class="form-group">
                <button class="btn btn-round btn-g" type="submit">Apply</button>
              </div>
            </div>
            <div class="col-sm-3 col-sm-offset-3">
              <div class="form-group">
                <button class="btn btn-block btn-round btn-d pull-right" type="submit">Update Cart</button>
              </div>
            </div>
          </div> --%>

          <%-- Total and Subtotals --%>
          <hr class="divider-w">
          <div class="row mt-70">
            <div class="col-sm-5 col-sm-offset-7">
              <div class="shop-Cart-totalbox">
                <h4 class="font-alt">Cart Totals</h4>
                <table class="table table-striped table-border checkout-table">
                  <tbody>
                    <tr>
                      <th>Cart Subtotal :</th>
                      <td id="cartSubTotal">RM ${totalAmount}</td>
                    </tr>
                    <tr>
                      <th>Shipping Total :</th>
                      <td>RM 0.00</td>
                    </tr>
                    <tr class="shop-Cart-totalprice">
                      <th>Total :</th>
                      <td id="cartTotal">RM ${totalAmount}</td>
                    </tr>
                  </tbody>
                </table>

                <sec:ifLoggedIn>
                  <a class="btn btn-lg btn-block btn-round btn-d">Proceed to Payment</a>
                </sec:ifLoggedIn>

                <sec:ifNotLoggedIn>
                  <a class="btn btn-lg btn-block btn-round btn-d" id="btnProceed">Proceed to Login / Register</a>
                </sec:ifNotLoggedIn>
                
              </div>
            </div>
          </div>

          <br/>
        </div>
      </div>
    </main>

    <script>
        $(document).ready(function(){

            $(".removeCartBtn").click(function() {
                var row = $(this).closest("tr");
                var quantity = row.find(".quantityValue").val();
                var hamperId = row.attr('hamperId');

                $.ajax({
                    url: "${createLink(controller: 'dashboard', action: 'removeFromCart')}",
                    type: 'POST',
                    data: { id: hamperId, quantity: quantity },
                    success: function(result) {
                      location.reload();
                    }
                });
            });

            var t;
            $('.quantityValue').change(function() {
                if ( t )
                {
                    clearTimeout( t );
                    t = setTimeout( myCallback.bind(this), 1000 );
                }
                else
                {
                    t = setTimeout( myCallback.bind(this), 1000 );
                }           
            });

            function myCallback()
            {           
                var row = $(this).closest("tr");
                var hamperId = row.attr('hamperId');
                var quantity = row.find(".quantityValue").val();
                var price = row.attr('hamperPrice');

                $.ajax({
                    url: "${createLink(controller: 'dashboard', action: 'setShoppingItemQuantity')}",
                    type: 'POST',
                    data: { id: hamperId, quantity: quantity },
                    success: function(result) {
                        row.find(".totalPrice").html('<strong> RM ' + (price * quantity).toFixed(2) + '</strong>');

                        updateTotal();
                    }
                });
            }

            function updateTotal() {
              $.ajax({
                    url: "${createLink(controller: 'dashboard', action: 'getTotal')}",
                    type: 'POST',
                    success: function(result) {
                        $("#cartSubTotal").html('RM ' + result);
                        $("#cartTotal").html('RM ' + result );
                    }
                });
            }

            $("#btnProceed").click(function() {
              window.location.href = "${createLink(controller: 'login', action: 'auth')}";
              localStorage.setItem("paying", "true");
            });
        });
    </script>
  </body>
</html>