<%@ page contentType="text/html"%>
<html lang="en-US" dir="ltr">
  <head>

  </head>
  <body data-spy="scroll" data-target=".onpage-navigation" data-offset="60">
    
    <main>
      <div class="main">
        <div class="container">

          <h3>${message}</h3>
          <br/>
          <br/>

          <h1>Order Details</h1>

          <%-- Order Details --%>
            <div class="row">
              <div class="col-sm-12">
                <table class="table table-striped table-border checkout-table">
                  <tr>
                    <th>Order Id: </th>
                    <td>${order.id}</td>
                  </tr>
                  <tr>
                    <th>Order Date: </th>
                    <td><g:formatDate date="${order.dateCreated}" type="datetime" format="${g.message(code: 'default.simpleDateTime.format')}"/></td>
                  </tr>
                  <tr>
                    <th>Order Status: </th>
                    <td><g:message code="label.pendingStatus.${order.pendingStatus}" /></td>
                  </tr>
                </table>
              </div>
            </div>

            <h1>Item List</h1>

          <g:form name="checkoutForm" class="form-horizontal" role="form">

            <%-- Shopping Cart List Table --%>
            <div class="row">
              <div class="col-sm-12">
                <table class="table table-striped table-border checkout-table">
                  <thead>
                      <tr>
                          <th>Product</th>
                          <th class="text-center">Price</th>
                          <th class="text-center">Recipient</th>
                          <th class="text-center">Gift Message</th>
                      </tr>
                  </thead>
                  <tbody>
                    <g:each var="product" in="${products}">
                      <input type="hidden" name="hamperId" class="form-control input-sm" value="${product.id}"/>
                      <tr hamperId="${product.id}" hamperPrice="${product.price}">
                          <td class="col-sm-3">
                              <h4 class="media-heading">${product.name}</h4>
                              <h5 class="media-heading">${product.shortDescription}</h5>
                          </td>
                          <td class="col-sm-2 text-center text-nowrap">
                              <strong>RM ${product.price}</strong>
                          </td>
                          <td class="col-sm-3 text-center text-nowrap">
                              <strong>Name: </strong> ${product.recipient.name} <br/>
                              <strong>Contact No: </strong> ${product.recipient.contactNo} <br/>
                              <strong>Address: </strong> ${product.recipient.address} 
                          </td>
                          <td class="col-sm-4 text-center">
                              ${product.giftMessage}
                          </td>
                      </tr>
                    </g:each>
                  </tbody>
                </table>
              </div>
            </div>

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
                </div>
              </div>
            </div>

          </g:form>

          <br/>
        </div>
      </div>
    </main>

    <script>
        $(document).ready(function(){
        });
    </script>
  </body>
</html>