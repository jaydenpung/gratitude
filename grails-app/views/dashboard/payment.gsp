<!DOCTYPE html>
<html lang="en-US" dir="ltr">
  <head>
    <meta name="layout" content="main" />
  </head>
  <body data-spy="scroll" data-target=".onpage-navigation" data-offset="60">
    <script src="https://www.paypalobjects.com/api/checkout.js"></script>

    <style>
      .footer {
        width: 100%;
        position: absolute;
        bottom: 0;
      }
    </style>

    <main>
      <div class="main">
        <div class="container">

          <%-- Title --%>
          <div class="row">
            <div class="col-sm-6 col-sm-offset-3">
              <br />
              <h1 class="module-title font-alt">Payment</h1>
            </div>
          </div>

          <div class="text-center" style="font-size: 20px">
            Total: RM ${totalAmount}
          </div>

          <br/>

          <div id="paypal-button-container"></div>

          <br/>
        </div>
      </div>
    </main>

    <script>
        $(document).ready(function(){

            function completePayment() {
              window.location.href = "${createLink(controller: 'dashboard', action: 'completePayment')}"
            }

            $('#cartBtn').hide();
            paypalPayment(${totalAmount});

            function paypalPayment(totalAmount) {
              paypal.Button.render({

                // Set your environment

                env: 'sandbox', // sandbox | production

                // Specify the style of the button

                style: {
                    label: 'pay',
                    size:  'responsive', // small | medium | large | responsive
                    shape: 'rect',   // pill | rect
                    color: 'gold'   // gold | blue | silver | black
                },

                // PayPal Client IDs - replace with your own
                // Create a PayPal app: https://developer.paypal.com/developer/applications/create

                client: {
                    sandbox:    'AVV9NKQph2T_WuxzwIQ8OnJAtBMqWJPY8UxISREd2oSd4KyvcFeMXKMWf3R1zB5sFmKaRiifvrn7Sgd-',
                    production: 'AXa6lkJFgvRSfNoDqQMi4r_LvRT9r1Qbn0bODK5SX2yBIivGbwCJnzwhKhQ-lLOjePf4yTOl2ZHIGwXZ'
                },

                // Wait for the PayPal button to be clicked

                payment: function(data, actions) {
                    return actions.payment.create({
                        payment: {
                            transactions: [
                                {
                                    amount: { total: totalAmount, currency: 'MYR' }
                                }
                            ]
                        }
                    });
                },

                // Wait for the payment to be authorized by the customer

                onAuthorize: function(data, actions) {
                    return actions.payment.execute().then(function() {
                        completePayment();
                    });
                }

                }, '#paypal-button-container');
            }
        });
    </script>
  </body>
</html>