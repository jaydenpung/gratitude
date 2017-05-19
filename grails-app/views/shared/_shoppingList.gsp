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
                    <tr>
                        <td class="col-sm-2">
                            <a class="thumbnail pull-left tkmSmallImage" href="${createLink(controller:'hamper', action: 'view', params: [id: product.id])}"> <img src="${resource(file: product.imagePath)}"/> </a>
                        </td>
                        <td class="col-sm-2">
                            <h4 class="media-heading"><a href="${createLink(controller:'hamper', action: 'view', params: [id: product.id])}">${product.name}</a></h4>
                            <h5 class="media-heading">${product.shortDescription}</h5>
                            <span>Stock left: </span><span class="text-success"><strong>${product.quantity}</strong></span>
                        </td>
                        <td class="col-sm-2">
                            <div class="input-group">
                                <span class="input-group-btn">
                                    <button type="button" class="btn btn-danger btn-number btn-quantityValue" data-type="minus" data-field="quantity${product.id}" ${product.cartQuantity <= 1?'disabled':''}>
                                        <span class="glyphicon glyphicon-minus"></span>
                                    </button>
                                </span>
                                <input type="text" id="quantity" name="quantity${product.id}" hamperId="${product.id}" class="form-control input-number quantityValue" min="1" max="${product.quantity}" value="${product.cartQuantity}">
                                <span class="input-group-btn">
                                    <button type="button" class="btn btn-success btn-number btn-quantityValue" data-type="plus" data-field="quantity${product.id}" ${product.cartQuantity >= product.quantity?'disabled':''}>
                                        <span class="glyphicon glyphicon-plus"></span>
                                    </button>
                                </span>
                            </div>
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
            var hamperId = $(this).attr('hamperId');

            $.ajax({
                url: "${createLink(controller: 'hamper', action: 'removeFromCart')}",
                type: 'POST',
                data: { id: hamperId, quantity: quantity },
                success: function(result) {
                    var ajaxUrl = "${createLink(controller: 'dashboard', action: 'getCartList')};"
                    refreshSoppingList(ajaxUrl);
                }
            });
        });

        $('.btn-quantityValue').click(function(e){
            e.preventDefault();

            fieldName = $(this).attr('data-field');
            type      = $(this).attr('data-type');
            var input = $("input[name='"+fieldName+"']");
            var currentVal = parseInt(input.val());
            if (!isNaN(currentVal)) {
                if (type == 'minus') {

                    if (currentVal > input.attr('min')) {
                        input.val(currentVal - 1).change();
                    }
                    if (parseInt(input.val()) == input.attr('min')) {
                        $(this).attr('disabled', true);
                    }

                } else if (type == 'plus') {

                    if (currentVal < input.attr('max')) {
                        input.val(currentVal + 1).change();
                    }
                    if (parseInt(input.val()) == input.attr('max')) {
                        $(this).attr('disabled', true);
                    }

                }
            } else {
                input.val(0);
            }
        });

        $('.quantityValue').focusin(function(){
           $(this).data('oldValue', $(this).val());
        });

        $('.quantityValue').change(function() {
            minValue =  parseInt($(this).attr('min'));
            maxValue =  parseInt($(this).attr('max'));
            valueCurrent = parseInt($(this).val());

            name = $(this).attr('name');

            if (valueCurrent >= minValue) {
                $(".btn-quantityValue[data-type='minus'][data-field='"+name+"']").removeAttr('disabled');
            } else {
                alert('Sorry, the minimum value was reached');
                $(this).val($(this).data('oldValue'));
            }
            if (valueCurrent <= maxValue) {
                $(".btn-quantityValue[data-type='plus'][data-field='"+name+"']").removeAttr('disabled');
            } else {
                alert('Sorry, the maximum value was reached');
                $(this).val($(this).data('oldValue'));
            }

            var hamperId = $(this).attr('hamperId');
            var quantity = $(this).val();

            $.ajax({
                url: "${createLink(controller: 'hamper', action: 'setShoppingItemQuantity')}",
                type: 'POST',
                data: { id: hamperId, quantity: quantity },
                success: function(result) {
                    var ajaxUrl = "${createLink(controller: 'dashboard', action: 'getCartList')};"
                    refreshSoppingList(ajaxUrl);
                }
            });
        });

        $(".quantityValue").keydown(function (e) {
            // Allow: backspace, delete, tab, escape, enter and .
            if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 190]) !== -1 ||
                 // Allow: Ctrl+A
                (e.keyCode == 65 && e.ctrlKey === true) ||
                 // Allow: home, end, left, right
                (e.keyCode >= 35 && e.keyCode <= 39)) {
                     // let it happen, don't do anything
                     return;
            }
            // Ensure that it is a number and stop the keypress
            if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                e.preventDefault();
            }
        });
    });
</script>
