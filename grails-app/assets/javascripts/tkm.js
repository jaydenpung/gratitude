function callAjax(url, data, success, defaultError) {
    $.ajax({
        type: "POST",
        url: url,
        data: data,
        success: function(result) {
            if (result.status == true) {
                window.location.replace(success);
            }
            else {
                // show error div
                $('#errorMsg').html(result.errorMessage);
                $('#errorMsg').fadeIn('fast');
            }
        },
        error: function(result) {
            alert(defaultError);
        }
    });
}

/**
 * Toggle buttons based on the checked status the specified checkBoxes.
 *
 * buttons    - selector string for buttons to enable if any checkBoxes are checked;
                 If all the checkBoxes are unchecked, they will be disabled instead.
 * checkBoxes - selector string for the checkBoxes
 */
function toggleButtonsBasedOnCheckBoxes(buttons, checkBoxes) {
    var anyChecked = $(checkBoxes + ":checked").length > 0;
    if (anyChecked) {
      $(buttons).removeAttr('disabled');
    }
    else {
      $(buttons).attr('disabled','disabled');
    }
}

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

window.onload = function() {
    $('.btn-number').click(function(e){
        e.preventDefault();

        fieldName = $(this).attr('data-field');
        type      = $(this).attr('data-type');
        var input = $("input[name='"+fieldName+"']");
        var currentVal = parseInt(input.val());
        if (!isNaN(currentVal)) {
            if (type == 'minus') {

                if (currentVal > input.attr('min')) {
                    input.val(currentVal - 1).change();
                }
                if (parseInt(input.val()) == input.attr('min')) {
                    $(this).attr('disabled', true);
                }

            } else if (type == 'plus') {

                if (currentVal < input.attr('max')) {
                    input.val(currentVal + 1).change();
                }
                if (parseInt(input.val()) == input.attr('max')) {
                    $(this).attr('disabled', true);
                }

            }
        } else {
            input.val(0);
        }
    });

    $('.input-number').focusin(function(){
       $(this).data('oldValue', $(this).val());
    });

    $('.input-number').change(function() {

        minValue =  parseInt($(this).attr('min'));
        maxValue =  parseInt($(this).attr('max'));
        valueCurrent = parseInt($(this).val());

        name = $(this).attr('name');
        if (valueCurrent >= minValue) {
            $(".btn-number[data-type='minus'][data-field='"+name+"']").removeAttr('disabled')
        } else {
            alert('Sorry, the minimum value was reached');
            $(this).val($(this).data('oldValue'));
        }
        if (valueCurrent <= maxValue) {
            $(".btn-number[data-type='plus'][data-field='"+name+"']").removeAttr('disabled')
        } else {
            alert('Sorry, the maximum value was reached');
            $(this).val($(this).data('oldValue'));
        }
    });

    $(".input-number").keydown(function (e) {
        // Allow: backspace, delete, tab, escape, enter and .
        if ($.inArray(e.keyCode, [46, 8, 9, 27, 13, 190]) !== -1 ||
             // Allow: Ctrl+A
            (e.keyCode == 65 && e.ctrlKey === true) ||
             // Allow: home, end, left, right
            (e.keyCode >= 35 && e.keyCode <= 39)) {
                 // let it happen, don't do anything
                 return;
        }
        // Ensure that it is a number and stop the keypress
        if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
            e.preventDefault();
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
