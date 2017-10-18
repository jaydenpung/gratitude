<!DOCTYPE html>
<html lang="en">

    <head>
        <meta name="layout" content="main" />
    </head>

    <body>
        <asset:javascript src="datatables.min.js"/>
        <asset:stylesheet src="datatables.min.css"/>

        <section class="module-small" style="padding-top: 0px">
            <div class="container">
                <div class="row">
                    <div class="col-lg-12">
                        <h1 class="page-header">Order - List</h1>
                    </div>
                </div>
                <g:render template="/shared/messages"/>
                <form class="form-horizontal" role="form" id="searchForm">
                    <div class="panel panel-default" id="#tableWrapper">
                        <div class="panel-heading">Search Orders</div>
                        <div class="panel-body">
                            <div class="form-group">
                                <label for="hamper" class="col-sm-2 control-label  input-sm">Name</label>
                                <div class="col-sm-5">
                                    <input type="text" class="form-control input-sm" id="orderName" name="orderName">
                                </div>
                            </div>

                            <button type="button" id="searchButton" class="btn btn-default"><g:message code="default.button.search.label"/></button>

                            <div class="table-responsive tablewrapper">
                                <table id="orderTable" class="table table-striped table-bordered table-hover table-condensed">
                                    <thead>
                                        <tr>
                                            <th class="selectAll"><input type="checkbox" id="selectAllCheckBox"/></th>
                                            <th>Order Id</th>
                                            <th>Name</th>
                                            <th>Total Amount</th>
                                            <th>Order Time</th>
                                            <th>Status</th>
                                            <th>Actions</th>
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
                        <g:actionSubmit class="btn btn-default buttons" action="confirmOrder" value="Confirm" disabled="true"/>
                        <g:actionSubmit class="btn btn-default buttons" action="completeOrder" value="Complete" disabled="true"/>
                    </div>
                  </div>
                </form>
            </div>
        </section>

        <script>
            selectAllCheckBox('#selectAllCheckBox', '[name=id]', '.buttons');

            $(document).ready(function() {
                $('#orderTable').dataTable( {
                    "processing": true,
                    "serverSide": true,
                    "searching": false,
                    "bLengthChange": false,
                    "order": [[ 1, "desc" ]],
                    "ajax": {
                        url: "${createLink(controller:'order', action: 'search')}",
                        "data": function ( d ) {
                            d.name = $("#orderName").val();
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
                        { data: 'totalAmount' },
                        { data: 'dateCreated' },
                        { data: 'status' },
                        { // buttons
                            "data": function ( row, type, val, meta ) {

                                return "<a href=\"${createLink(controller:'order', action: 'edit')}/" +
                               row.id + "\" class=\"btn btn-default btn-xs\"><g:message code="default.button.viewUpdate.label"/></a>"
                            }
                        },
                    ],
                    "columnDefs": [
                        { "targets": 0, "orderable":false  },
                        { "name": "id",  "targets": 1 },
                        { "name": "name",  "targets": 2 },
                        { "name": "totalAmount", "targets": 3 },
                        { "name": "dateCreated", "targets": 4 },
                        { "name": "status", "targets": 5 },
                        { "name": "actions", "targets": 6, "orderable":false }
                    ]
                });
            } );

            $("#searchForm").bind("keypress", function (e) {
                if (e.keyCode == 13) {
                    e.preventDefault();
                    var table = $('#orderTable').DataTable();
                    table.draw();
                }
            });

            $("#searchButton").click( function() {
                var table = $('#orderTable').DataTable();
                table.draw();
            });
        </script>
    </body>

</html>
