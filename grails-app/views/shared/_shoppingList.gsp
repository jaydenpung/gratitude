<div class="row">
        <table class="table table-hover">
            <thead>
                <tr>
                    <th colspan="2">Product</th>
                    <th>
                    <th>Quantity</th>
                    <th class="text-center">Price</th>
                    <th class="text-center">Total</th>
                    <th> </th>
                </tr>
            </thead>
            <tbody>
                <g:if test="${products.isEmpty()}">
                    <td colspan="5" class="tkmCenter">No items in your cart.</td>
                </g:if>
                <g:else>
                    <g:each var="product" in="${products}">
                    <tr hamperId="${product.id}">
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
                        <td class="col-sm-2 text-center text-nowrap">
                            <strong>RM ${product.totalPrice}</strong>
                        </td>
                        <td class="col-sm-2">
                            <button type="button" class="btn btn-danger removeCartBtn" hamperId="${product.id}">
                                <span class="glyphicon glyphicon-remove"></span> Remove
                            </button>
                        </td>
                    </tr>
                    </g:each>
                    <%-- SubTotals and Totals --%>
                    <tr>
                        <td colspan="4"></td>
                        <td><h5>Subtotal</h5></td>
                        <td class="text-right text-nowrap"><h5><strong>RM ${totalAmount}</strong></h5></td>
                    </tr>
                    <tr>
                        <td colspan="4"></td>
                        <td><h5>Estimated shipping</h5></td>
                        <td class="text-right text-nowrap"><h5><strong>RM 0.00</strong></h5></td>
                    </tr>
                    <tr>
                        <td colspan="4"></td>
                        <td><h3>Total</h3></td>
                        <td class="text-right text-nowrap"><h3><strong>RM ${totalAmount}</strong></h3></td>
                    </tr>
                    <tr>
                        <td colspan="4"></td>
                        <td>
                            <button type="button" class="btn btn-default" data-dismiss="modal">
                                <span class="glyphicon glyphicon-shopping-cart"></span> Continue Shopping
                            </button>
                        </td>
                        <td>
                            <button type="button" class="btn btn-success">
                                Checkout <span class="glyphicon glyphicon-play"></span>
                            </button>
                        </td>
                    </tr>
                </g:else>
            </tbody>
        </table>
    </div>
</div>

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
                    var ajaxUrl = "${createLink(controller: 'dashboard', action: 'getCartList')};"
                    refreshSoppingList(ajaxUrl);
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

            $.ajax({
                url: "${createLink(controller: 'dashboard', action: 'setShoppingItemQuantity')}",
                type: 'POST',
                data: { id: hamperId, quantity: quantity },
                success: function(result) {
                    var ajaxUrl = "${createLink(controller: 'dashboard', action: 'getCartList')};"
                    refreshSoppingList(ajaxUrl);
                }
            });
        }
    });
</script>
