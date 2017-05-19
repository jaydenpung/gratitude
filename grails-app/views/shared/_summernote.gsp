<asset:javascript src="summernote.js"/>
<g:javascript>
    $(document).ready(function($) {
        $("#summernote").summernote ({
            height: 500,
            width: '100%',
            minHeight: 200,
            focus: false,

            toolbar: [
                ['style', ['style', 'bold', 'italic', 'underline', 'clear']],
                ['fontsize', ['fontsize']],
                ['color', ['color']],
                ['para', ['ul', 'ol', 'paragraph']]
            ]
        });
    });
</g:javascript>
