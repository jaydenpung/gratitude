/**
 * Adds Select All/None functionality to checkboxes

 * checkBoxAll - selector string for the "Select All" checkbox
 * checkBoxes  - selector string for all the checkboxes except "Select All"
 * buttons     - selector string for buttons to enable if any checkBoxes are checked;
                 If all the checkBoxes are unchecked, they will be disabled instead.
 */
function selectAllCheckBox(checkBoxAll, checkBoxes, buttons) {
    // "All" checkbox changed
    $(checkBoxAll).change(function() {
        var checked = $(this).prop('checked');
        $(checkBoxes).prop('checked', checked);
        toggleButtonsBasedOnCheckBoxes(buttons, checkBoxes);
    });
    $('body').on('change', checkBoxes, function () {
        toggleButtonsBasedOnCheckBoxes(buttons, checkBoxes);
        if (!this.checked) {
            $(checkBoxAll).prop('checked', false);
        }
    });
}

function refreshSoppingList(ajaxUrl) {
    var modal = $("#cartModal");
    var target = $("#cartModalBody");

    $.get(ajaxUrl)
    .done(function(ajaxData){
        target.html(ajaxData);
        modal.modal('show');
    })
    .fail(function(){
        alert("Something went wrong");
    });
}