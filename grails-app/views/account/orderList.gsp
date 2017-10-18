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
                        <div class="panel-heading">My Sales Orders</div>
                        <div class="panel-body">
                            <div class="table-responsive tablewrapper">
                                <table id="orderTable" class="table table-striped table-bordered table-hover table-condensed">
                                    <thead>
                                        <tr>
                                            <th>Order Id</th>
                                            <th>Order Time</th>
                                            <th>Total Amount</th>
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
                </form>
            </div>
        </section>

        <script>

            $(document).ready(function() {
                $('#orderTable').dataTable( {
                    "processing": true,
                    "serverSide": true,
                    "searching": false,
                    "bLengthChange": false,
                    "order": [[ 0, "desc" ]],
                    "ajax": {
                        url: "${createLink(controller:'account', action: 'search')}",
                        "data": function ( d ) {
                            d.name = $("#orderName").val();
                        }
                    },
                    "columns": [
                        { data: 'id' },
                        { data: 'dateCreated'},
                        { data: 'totalAmount' },
                        { data: 'status' },
                        { // buttons
                            "data": function ( row, type, val, meta ) {

                                return "<a href=\"${createLink(controller:'account', action: 'viewOrder')}/" +
                               row.id + "\" class=\"btn btn-default btn-xs\">View</a>"
                            }
                        },
                    ],
                    "columnDefs": [
                        { "name": "id",  "targets": 0 },
                        { "name": "dateCreated",  "targets": 1 },
                        { "name": "totalAmount", "targets": 2 },
                        { "name": "status", "targets": 3 },
                        { "name": "actions", "targets": 4, "orderable":false }
                    ]
                });
            } );
        </script>
    </body>

</html>
