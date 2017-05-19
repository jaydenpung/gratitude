<!DOCTYPE html>
<html lang="en">

    <head>
        <meta name="layout" content="main" />
    </head>

    <body>
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header"><g:message code="product.create.label" /></h1>
            </div>
        </div>
        <g:render template="/shared/messages"/>
        <g:form method="post" enctype="multipart/form-data"  action="save" name="addForm" class="form-horizontal" role="form">
            <div class="panel panel-default">
                <div class="panel-heading"><g:message code="product.create.panel.label"/></div>
                <div class="panel-body">
                    <%-- Image --%>
                    <div class="form-group">
                        <label for="image" class="col-sm-2 control-label input-sm"><g:message code="product.image.label" /></label>
                        <div class="col-sm-3">
                            <input type="file" name="image" />
                        </div>
                    </div>
                    <%-- Name --%>
                    <div class="form-group required">
                        <label for="name" class="col-sm-2 control-label input-sm required"><g:message code="product.name.label" /></label>
                        <div class="col-sm-5">
                            <g:textField class="form-control input-sm" name="name" maxlength="100"/>
                        </div>
                    </div>
                    <%-- Description --%>
                    <div class="form-group">
                        <label for="description" class="col-sm-2 control-label input-sm"><g:message code="product.description.label" /></label>
                        <div class="col-sm-8">
                            <g:textArea class="form-control input-sm" name="description" rows="7" maxlength="1000"/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="form-actions">
                <a href="${createLink(controller:'product', action: 'list')}" class="btn btn-default"><g:message code="default.button.back.label"/></a>
                <g:actionSubmit class="btn btn-default" action="save" value="${message(code: 'default.button.save.label')}" />
            </div>
        </g:form>

        <script>
            $(document).ready(function() {

                $('[name=addForm]').bootstrapValidator({
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
