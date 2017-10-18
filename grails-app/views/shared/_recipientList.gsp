<div class="row">
        <table class="table table-hover">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Contact No</th>
                    <th>Address</th>
                    <th></th>
                </tr>
            </thead>
            <tbody>
                <g:each var="recipient" in="${recipients}">
                <tr recipientId="${recipient.id}">
                    <div>
                        <td class="col-sm-2">
                            <div class="valueDiv">
                                ${recipient.name}
                            </div>
                            <div class="editDiv" style="display: none">
                                <g:textField class="form-control input-sm" name="name" maxlength="100" value="${recipient.name}"/>
                            </div>
                        </td>
                        <td class="col-sm-2">
                            <div class="valueDiv">
                                ${recipient.contactNo}
                            </div>
                            <div class="editDiv" style="display: none">
                                <g:textField class="form-control input-sm" name="contactNo" maxlength="20" value="${recipient.contactNo}"/>
                            </div>
                        </td>
                        <td class="col-sm-4">
                            <div class="valueDiv">
                                ${recipient.address}
                            </div>
                            <div class="editDiv" style="display: none">
                                <textarea rows="4" class="form-control input-sm" name="address" maxlength="150" row="4">${recipient.address}</textarea>
                            </div>
                        </td>
                        <td class="text-center">
                            <div class="valueDiv">
                                <button type="button" class="btn btn-default editRecipientBtn">Edit</button>
                                <button type="button" class="btn btn-danger deleteRecipientBtn">
                                    <span class="glyphicon glyphicon-remove"></span> Remove
                                </button>
                            </div>
                            <div class="editDiv" style="display: none">
                                <button type="button" class="btn btn-default btn-success updateRecipientBtn">Update</button>
                                <button type="button" class="btn btn-default cancelRecipientBtn">Cancel</button>
                            </div>
                        </td>
                    </div>
                </tr>
                </g:each>

                <tr>
                    <td class="col-sm-2">
                        <g:textField class="form-control input-sm" name="name" maxlength="100"/>
                    </td>
                    <td class="col-sm-2">
                        <g:textField class="form-control input-sm" name="contactNo" maxlength="20"/>
                    </td>
                    <td class="col-sm-4">
                        <textarea rows="4" class="form-control input-sm" name="address" maxlength="150" row="4"></textarea>
                    </td>
                    <td class="text-center">
                        <button type="button" class="btn btn-default btn-success addRecipientBtn">Add</button>
                    </td>
                </tr>

            </tbody>
        </table>
    </div>
</div>

<script>
    $(document).ready(function(){
        $(".addRecipientBtn").click(function() {
            var row = $(this).closest("tr");

            var name = row.find("[name='name']").val();
            var contactNo = row.find("[name='contactNo']").val();
            var address = row.find("[name='address']").val();

            $.ajax({
                url: "${createLink(controller: 'dashboard', action: 'addRecipient')}",
                type: 'POST',
                data: { name: name, contactNo: contactNo, address: address },
                success: function(result) {
                    if (result.success) {
                        var ajaxUrl = "${createLink(controller: 'dashboard', action: 'getRecipientList')};"
                        refreshRecipientList(ajaxUrl);
                        addRecipientInCheckout(result.id, name);
                    }
                    else {
                        alert(result.errorMessage);
                    }
                }
            });

        });

        $(".editRecipientBtn").click(function() {
            var row = $(this).closest("tr");

            row.find(".editDiv").show();
            row.find(".valueDiv").hide();
        });

        $(".cancelRecipientBtn").click(function() {
            var row = $(this).closest("tr");

            row.find(".editDiv").hide();
            row.find(".valueDiv").show();
        });

        $(".updateRecipientBtn").click(function() {
            var row = $(this).closest("tr");

            var id = row.attr('recipientId');
            var name = row.find("[name='name']").val();
            var contactNo = row.find("[name='contactNo']").val();
            var address = row.find("[name='address']").val();

            $.ajax({
                url: "${createLink(controller: 'dashboard', action: 'updateRecipient')}",
                type: 'POST',
                data: { id: id, name: name, contactNo: contactNo, address: address },
                success: function(result) {
                    if (result.success) {
                        var ajaxUrl = "${createLink(controller: 'dashboard', action: 'getRecipientList')};"
                        refreshRecipientList(ajaxUrl);
                        updateRecipientInCheckout(result.id, name);
                    }
                    else {
                        alert(result.errorMessage);
                    }
                }
            });
        });

        $(".deleteRecipientBtn").click(function() {
            var row = $(this).closest("tr");
            var id = row.attr('recipientId');

            $.ajax({
                url: "${createLink(controller: 'dashboard', action: 'deleteRecipient')}",
                type: 'POST',
                data: { id: id },
                success: function(result) {
                    if (result.success) {
                        var ajaxUrl = "${createLink(controller: 'dashboard', action: 'getRecipientList')};"
                        refreshRecipientList(ajaxUrl);
                        deleteRecipientInCheckout(result.id, name);
                    }
                    else {
                        alert(result.errorMessage);
                    }
                }
            });
        });

        function addRecipientInCheckout(id, name) {
            var option = new Option(name, id);
            $('.recipientDdl').append(option);
        }

        function updateRecipientInCheckout(id, name) {
            $(".recipientDdl option[value='" + id + "']").text(name);
        }

        function deleteRecipientInCheckout(id, name) {
            $(".recipientDdl option[value='" + id + "']").remove();
        }

    });
</script>
