<footer class="footer bg-dark">
  <div class="container">
    <div class="row">
      <div class="col-sm-6">
        <p id="copyrightYear" class="copyright font-alt">&copy; 2017&nbsp;<a href="#"><g:message code="client.name.label"/></a>, All Rights Reserved</p>
      </div>
      <div class="col-sm-6">
        <div class="footer-social-links"><a href="#"><i class="fa fa-facebook"></i></a><a href="#"><i class="fa fa-twitter"></i></a><a href="#"><i class="fa fa-dribbble"></i></a><a href="#"><i class="fa fa-skype"></i></a>
        </div>
      </div>
    </div>
  </div>
</footer>
<div class="scroll-up"><a href="#totop"><i class="fa fa-angle-double-up"></i></a></div>

<script type = "text/javascript">
	var dt = new Date().getFullYear();
	$("#copyrightYear").html(function(index, html){
        	return html.replace('2017', dt);
        });
</script>
