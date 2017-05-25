<!DOCTYPE html>
<html lang="en">

    <head>

        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="description" content="">
        <meta name="author" content="">
        <meta name="layout" content="main" />

        <title>Shop Homepage - Start Bootstrap Template</title>
    </head>

    <body>
        <div class="row carousel-holder">
            <div class="col-md-12">
                <div id="carousel-example-generic" class="carousel slide" data-ride="carousel">
                    <ol class="carousel-indicators">
                        <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
                        <li data-target="#carousel-example-generic" data-slide-to="1"></li>
                        <li data-target="#carousel-example-generic" data-slide-to="2"></li>
                    </ol>
                    <div class="carousel-inner" align="center">
                        <div class="item active">
                            <img src="${resource(file: '/themeImages/cover1.png')}" class="coverImage"/>
                        </div>
                        <div class="item">
                            <img src="${resource(file: '/themeImages/cover2.png')}" class="coverImage"/>
                        </div>
                        <div class="item">
                            <img src="${resource(file: '/themeImages/cover3.png')}" class="coverImage"/>
                        </div>
                    </div>
                    <a class="left carousel-control" href="#carousel-example-generic" data-slide="prev">
                        <span class="glyphicon glyphicon-chevron-left"></span>
                    </a>
                    <a class="right carousel-control" href="#carousel-example-generic" data-slide="next">
                        <span class="glyphicon glyphicon-chevron-right"></span>
                    </a>
                </div>
            </div>
        </div>

        <div id="products" class="row list-group">
            <g:each var="hamper" in="${hampers}">
                <input type="hidden" name="id" value="${hamper.id}"/>
                <div class="item  col-xs-4 col-lg-4">
                    <div class="thumbnail">
                        <a href="${createLink(controller:'hamper', action: 'view', params: [id: hamper.id])}">
                            <img src="${createLink(action: 'renderImage', controller:'image')}/${hamper.image.generatedName}" style="max-height:250px; min-height:250px">
                        </a>
                        <div class="caption">
                            <h4 class="group inner list-group-item-heading">
                                <a href="${createLink(controller:'hamper', action: 'view', params: [id: hamper.id])}">${hamper.name}</a>
                            </h4>
                            <p class="group inner list-group-item-text">${hamper.shortDescription}</p>
                            <div class="row">
                                <div class="col-xs-12 col-md-6">
                                    <p class="lead">RM ${hamper.price}</p>
                                </div>
                                <div class="col-xs-12 col-md-6">
                                    <a class="btn btn-success" href="${createLink(controller:'hamper', action: 'view', params: [id: hamper.id])}">View Details</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </g:each>
        </div>
    </body>

</html>
