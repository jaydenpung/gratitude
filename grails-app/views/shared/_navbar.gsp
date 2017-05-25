<ul class="nav navbar-nav navbar-right">
  <li><a href="${createLink(action: 'landingPage', controller:'dashboard')}">Home</a>
  </li>
  <li class="dropdown"><a class="dropdown-toggle" href="#" data-toggle="dropdown">Shop</a>
    <ul class="dropdown-menu" role="menu">
      <li class="dropdown"><a class="dropdown-toggle" href="#" data-toggle="dropdown">Products</a>
        <ul class="dropdown-menu">
          <li><a href="${createLink(action: 'list', controller:'dashboard')}">Hampers</a></li>
        </ul>
      </li>
      <li><a href="${createLink(action: 'wip', controller:'dashboard')}">Promotions</a></li>
    </ul>
  </li>

  <sec:ifAllGranted roles="ROLE_ADMIN">
    <li class="dropdown"><a class="dropdown-toggle" href="#" data-toggle="dropdown">Maintenance</a>
      <ul class="dropdown-menu">
        <li><a href="${createLink(action: 'list', controller:'hamper')}">Hamper Maintenance</a></li>
        <li><a href="${createLink(action: 'wip', controller:'dashboard')}">Theme Maintenance</a></li>
        <li><a href="${createLink(action: 'wip', controller:'dashboard')}">Promotion Maintenance</a></li>
      </ul>
    </li>
  </sec:ifAllGranted>

  <li><a href="${createLink(action: 'wip', controller:'dashboard')}">About Us</a>
  <li><a href="${createLink(action: 'wip', controller:'dashboard')}">Contact Us</a>

  <sec:ifNotLoggedIn>
    <li><a href="${createLink(action: 'auth', controller:'login')}">Login</a>
  </sec:ifNotLoggedIn>
  <sec:ifLoggedIn>
    <li><a href="${createLink(action: 'logout', controller:'login')}">Logout</a>
  </sec:ifLoggedIn>

</ul>