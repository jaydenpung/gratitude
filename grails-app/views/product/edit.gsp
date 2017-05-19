<!DOCTYPE html>
<html lang="en">

    <head>
        <meta name="layout" content="main" />
    </head>

    <body>
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header"><g:message code="product.edit.label" /></h1>
            </div>
        </div>
        <g:render template="/shared/messages"/>
        <g:form method="post" enctype="multipart/form-data"  action="update" name="editForm" class="form-horizontal" role="form">
            <input type="hidden" name="id" value="${product.id}">
            <div class="panel panel-default">
                <div class="panel-heading"><g:message code="product.edit.panel.label"/></div>
                <div class="panel-body">
                    <%-- Image --%>
                    <div class="form-group required">
                        <label for="name" class="col-sm-2 control-label input-sm required"><g:message code="product.image.label" /></label>
                        <div class="col-sm-3">
                            <g:if test="${product.image}">
                                <img src="${resource(file: product.image.path)}" height="300" width="400"/>
                            </g:if>
                            <g:else>
                                <asset:image src="NoPicAvailable.png" height="300" width="400"/>
                            </g:else>
                            <input type="file" name="image" />
                        </div>
                    </div>
                    <%-- Name --%>
                    <div class="form-group required">
                        <label for="name" class="col-sm-2 control-label input-sm required"><g:message code="product.name.label" /></label>
                        <div class="col-sm-5">
                            <g:textField class="form-control input-sm" name="name" maxlength="100" value="${product.name}"/>
                        </div>
                    </div>
                    <%-- Description --%>
                    <div class="form-group">
                        <label for="description" class="col-sm-2 control-label input-sm"><g:message code="product.description.label" /></label>
                        <div class="col-sm-8">
                            <g:textArea class="form-control input-sm" name="description" rows="7" maxlength="1000" value="${product.description}"/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="form-actions">
                <a href="${createLink(controller:'product', action: 'list')}" class="btn btn-default"><g:message code="default.button.back.label"/></a>
                <g:actionSubmit class="btn btn-default" action="update" value="${message(code: 'default.button.update.label')}" />
            </div>
        </g:form>
        <script>
            $(document).ready(function() {
                $('[name=editForm]').bootstrapValidator({
                    excluded: ':disabled',
                    message: 'This value is not valid',
                    feedbackIcons: {
                        valid: 'glyphicon glyphicon-ok',
                        invalid: 'glyphicon glyphicon-remove',
                        validating: 'glyphicon glyphicon-refresh'
                    },
                    fields: {
                        name: {
                            validators: {
                                notEmpty: {
                                    message: 'The product name is required and cannot be empty'
                                }
                            }
                        }
                    }
                });
            });
        </script>
    </body>

</html>
