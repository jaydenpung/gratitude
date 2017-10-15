<html>
<head>
	<meta name='layout' content='main'/>
	<title><g:message code="springSecurity.login.title"/></title>
	<style type='text/css' media='screen'>
	#login {
		margin: 15px 0px;
		padding: 0px;
		text-align: center;
	}

	#login .inner {
		width: 340px;
		padding-bottom: 6px;
		margin: 60px auto;
		text-align: left;
		border: 1px solid #aab;
		background-color: #f0f0fa;
		-moz-box-shadow: 2px 2px 2px #eee;
		-webkit-box-shadow: 2px 2px 2px #eee;
		-khtml-box-shadow: 2px 2px 2px #eee;
		box-shadow: 2px 2px 2px #eee;
	}

	#login .inner .fheader {
		padding: 18px 26px 14px 26px;
		background-color: #f7f7ff;
		margin: 0px 0 14px 0;
		color: #2e3741;
		font-size: 18px;
		font-weight: bold;
	}

	#login .inner .cssform p {
		clear: left;
		margin: 0;
		padding: 4px 0 3px 0;
		padding-left: 105px;
		margin-bottom: 20px;
		height: 1%;
	}

	#login .inner .cssform input[type='text'] {
		width: 120px;
	}

	#login .inner .cssform label {
		font-weight: bold;
		float: left;
		text-align: right;
		margin-left: -105px;
		width: 110px;
		padding-top: 3px;
		padding-right: 10px;
	}

	#login #remember_me_holder {
		padding-left: 120px;
	}

	#login #submit {
		margin-left: 15px;
	}

	#login #remember_me_holder label {
		float: none;
		margin-left: 0;
		text-align: left;
		width: 200px
	}

	#login .inner .login_message {
		padding: 6px 25px 20px 25px;
		color: #c33;
	}

	#login .inner .text_ {
		width: 120px;
	}

	#login .inner .chk {
		height: 12px;
	}
	</style>
</head>

<body>
	<div class="main">
		<%-- CoverImage --%>
        <section class="module bg-dark-30" data-background="../assets/images/shop/cover6.png">
          <div class="container">
            <div class="row">
              <div class="col-sm-6 col-sm-offset-3">
                <h1 class="module-title font-alt mb-0">Login-Register</h1>
              </div>
            </div>
          </div>
        </section>

        <%-- Login and Register --%>
        <section class="module">
          <div class="container">
            <div class="row">

              <%-- Login --%>
              <div class="col-sm-5 col-sm-offset-1 mb-sm-40" id="login">
                <h4 class="font-alt">Login</h4>
                <hr class="divider-w mb-10">
                <g:if test='${flash.message}'>
					<div class='login_message'>${flash.message}</div>
				</g:if>
                <form class="form cssform" action='${postUrl}' method='POST' id='loginForm'>
                  <div class="form-group">
                    <input class="form-control" type="text" name='j_username' id='username' placeholder="Username"/>
                  </div>
                  <div class="form-group">
                    <input class="form-control" type="password" name='j_password' id='password' placeholder="Password"/>
                  </div>
                  <p id="remember_me_holder">
					<input type='checkbox' class='chk' name='${rememberMeParameter}' id='remember_me' <g:if test='${hasCookie}'>checked='checked'</g:if>/>
					<label for='remember_me'><g:message code="springSecurity.login.remember.me.label"/></label>
				  </p>
                  <div class="form-group">
                    <input type='submit' class="btn btn-round btn-b" id="submit" value="Login"/>
                  </div>
                  <div class="form-group"><a href="">Forgot Password?</a></div>
                </form>
              </div>

              <%-- Register --%>
              <div class="col-sm-5">
                <h4 class="font-alt">Register</h4>
                <hr class="divider-w mb-10">
                <div id="registerMessage" class='login_message'>${registerMessage}</div>
                <form class="form" name= "registerForm">
                  <div class="form-group">
                    <input class="form-control" id="register_email" type="email" name="email" placeholder="Email" value="${email}"/>
                  </div>
                  <div class="form-group">
                    <input class="form-control" id="register_password" type="password" name="password" placeholder="Password"/>
                  </div>
                  <div class="form-group">
                    <input class="form-control" id="register_re-password" type="password" name="re-password" placeholder="Re-enter Password"/>
                  </div>
                  <div class="form-group">
                    <button id="btnRegister" class="btn btn-block btn-round btn-b">Register</button>
                  </div>
                </form>
              </div>

            </div>
          </div>
        </section>

	<script type='text/javascript'>

		(function() {
			document.forms['loginForm'].elements['j_username'].focus();
		})();

		$(document).ready(function() {
			saveSessionId();

			$("#btnRegister").click(function() {
				$.ajax({
				  url: "${createLink(controller: 'secUser', action: 'register')}",
				  type: 'POST',
				  data: { email: $("#register_email").val(), password: $("#register_password").val(), rePassword: $('#register_re-password').val() },
				  success: function(result) {
				  	if(result.success == false) {
				  		$('#registerMessage').html(result.registerMessage);
				  	}
				  	else {
				  		$("#username").val($("#register_email").val());
				  		$("#password").val($("#register_password").val());

				  		$("#submit").trigger("click");
				  	}
				  },
				  error: function(result) {
				  	$('#registerMessage').html("Error: Please contact admin");
				  }
				});

				return false;
		  });
		});

		function saveSessionId() {
			$.ajax({
			  url: "${createLink(controller: 'secUser', action: 'getSessionId')}",
			  type: 'POST',
			  success: function(result) {
			  	localStorage.setItem("previousSessionId", result.sessionId);
			  },
			  error: function(result) {
			  	$('#registerMessage').html("Error: Please contact admin");
			  }
			});
		}

		$('[name=registerForm]').bootstrapValidator({
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
	            },
	            password: {
	            	validators: {
	            		identical: {
	            			field: 're-password',
	            			message: 'Passwords not matched'
	            		},
	            		notEmpty: {
	                    	message: 'password cannot be empty'
	                    }
	            	}
	            },
	            're-password': {
	            	validators: {
	            		identical: {
	            			field: 'password',
	            			message: 'Passwords not matched'
	            		},
	            		notEmpty: {
	                    	message: 'password cannot be empty'
	                    }
	            	}
	            }
	        }
	    });		

	</script>
</body>
</html>
