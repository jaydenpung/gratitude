<html>
<head>
	<meta name='layout' content='main'/>
	<title><g:message code="springSecurity.login.title"/></title>
	<style type='text/css' media='screen'>
	</style>
</head>

<body>
	<div class="main">
		<%-- CoverImage --%>
        <section class="module bg-dark-30" data-background="../assets/images/shop/cover6.png">
          <div class="container">
            <div class="row">
              <div class="col-sm-6 col-sm-offset-3">
                <h1 class="module-title font-alt mb-0">Reset Password</h1>
              </div>
            </div>
          </div>
        </section>

        <%-- Forgot Password --%>
        <section class="module" id="contact">
          <div class="container">
            <div class="row">
              <div class="col-sm-6 col-sm-offset-3">
                <h2 class="module-title font-alt">Forgot Password?</h2>
                <div class="module-subtitle font-serif">
        No worries! Just tell us your email, and we will send you a link to reset your password!</div>
              </div>
            </div>
        	  <div class="col-sm-6 col-sm-offset-3 align-center">
                <g:render template="/shared/messages"/>
              </div>
            </div>
            <div class="row">
              <div class="col-sm-6 col-sm-offset-3">
                <form name="forgotPasswordForm" role="form" method="post" action="submitForgotPassword">
                  <div class="form-group">
                    <label class="sr-only" for="email">Email</label>
                    <input class="form-control" type="email" id="email" name="email" placeholder="Your Email*" required="required" data-validation-required-message="Please enter your email address."/>
                    <p class="help-block text-danger"></p>
                  </div>
                  <div class="text-center">
                    <button class="btn btn-block btn-round btn-d" id="cfsubmit" type="submit">Submit</button>
                  </div>
                </form>
                <div class="ajax-response font-alt" id="contactFormResponse"></div>
              </div>
            </div>
          </div>
        </section>

	<script type='text/javascript'>

		(function() {
			document.forms['forgotPasswordForm'].elements['email'].focus();
		})();

		$('[name=forgotPasswordForm]').bootstrapValidator({
	        excluded: ':disabled',
	        message: 'This value is not valid',
	        feedbackIcons: {
	            valid: 'glyphicon glyphicon-ok',
	            invalid: 'glyphicon glyphicon-remove',
	            validating: 'glyphicon glyphicon-refresh'
	        },
	        fields: {
	            email: {
	                validators: {
	                    email: {
	                        message: 'This is not a valid email'
	                    },
	                    notEmpty: {
	                    	message: 'Email cannot be empty'
	                    }
	                }
	            }
	        }
	    });		

	</script>
</body>
</html>
