<!DOCTYPE html>
<html lang="en">

    <head>
        <meta name="layout" content="main" />
    </head>

    <body>
        <asset:javascript src="datatables.min.js"/>
        <asset:stylesheet src="datatables.min.css"/>
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header"><g:message code="product.list.label" /></h1>
            </div>
        </div>
        <g:render template="/shared/messages"/>
        <form class="form-horizontal" role="form" id="searchForm">
            <div class="panel panel-default" id="#tableWrapper">
                <div class="panel-heading"><g:message code="product.list.panel.label"/></div>
                <div class="panel-body">
                    <div class="form-group">
                        <label for="product" class="col-sm-2 control-label  input-sm"><g:message code="product.name.label"/></label>
                        <div class="col-sm-5">
                            <input type="text" class="form-control input-sm" id="productName" name="productName">
                        </div>
                    </div>

                    <button type="button" id="searchButton" class="btn btn-default"><g:message code="default.button.search.label"/></button>

                    <div class="table-responsive tablewrapper">
                        <table id="productTable" class="table table-striped table-bordered table-hover table-condensed">
                            <thead>
                                <tr>
                                    <th class="selectAll"><input type="checkbox" id="selectAllCheckBox"/></th>
                                    <th><g:message code="product.id.label"/></th>
                                    <th><g:message code="product.name.label"/></th>
                                    <th><g:message code="product.description.label"/></th>
                                    <th><g:message code="default.actions.label"/></th>
                                </tr>
                            </thead>

                            <tfoot>
                            </tfoot>

                            <tbody>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="row">
            <div class="col-sm-12">
                <a href="${createLink(controller:'product', action: 'create')}" class="btn btn-default"><g:message code="default.button.create.label"/></a>
                <g:actionSubmit class="btn btn-default buttons" action="delete" value="${message(code: 'default.button.delete.label')}" disabled="true"/>
            </div>
          </div>
        </form>

        <script>
            selectAllCheckBox('#selectAllCheckBox', '[name=id]', '.buttons');

            $(document).ready(function() {
                $('#productTable').dataTable( {
                    "processing": true,
                    "serverSide": true,
                    "searching": false,
                    "bLengthChange": false,
                    "ajax": {
                        url: "${createLink(controller:'product', action: 'search')}",
                        "data": function ( d ) {
                            d.name = $("#productName").val();
                        }
                    },
                    "columns": [
                        {
                            "data": function ( row, type, val, meta ) {
                                return '<input type=\"checkbox\" name=\"id\" value=\"' + row.id + '\"/>'
                            }
                        },
                        { data: 'id' },
                        { data: 'name'},
                        { data: 'description' },
                        { // buttons
                            "data": function ( row, type, val, meta ) {

                                return "<a href=\"${createLink(controller:'product', action: 'edit')}/" +
                               row.id + "\" class=\"btn btn-default btn-xs\"><g:message code="default.button.viewUpdate.label"/></a>"
                            }
                        },
                    ],
                    "columnDefs": [
                        { "targets": 0, "orderable":false  },
                        { "name": "id",  "targets": 1 },
                        { "name": "name",  "targets": 2 },
                        { "name": "description", "targets": 3 },
                        { "name": "actions", "targets": 4, "orderable":false }
                    ]
                });
            } );

            $("#searchForm").bind("keypress", function (e) {
                if (e.keyCode == 13) {
                    e.preventDefault();
                    var table = $('#productTable').DataTable();
                    table.draw();
                }
            });

            $("#searchButton").click( function() {
                var table = $('#productTable').DataTable();
                table.draw();
            });
        </script>
    </body>

</html>
