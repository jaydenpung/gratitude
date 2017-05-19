<g:if test="${flash.message}">
    <div class="alert alert-${flash.level ?: 'info'} alert-dismissible" role="alert">
        <button type="button" class="close" data-dismiss="alert" aria-label="${message(code: 'default.button.close.label')}">
            <span aria-hidden="true">&times;</span>
        </button>
        <g:if test="${flash.message instanceof Collection}">
             <g:each var="message" in="${flash.message}">
                ${raw(message)}
            </g:each>
        </g:if>
        <g:else>
            ${raw(flash.message)}
        </g:else>
    </div>
</g:if>
<g:if test="${flash.errors}">
    <div class="alert alert-warning" role="alert">
        <button type="button" class="close" data-dismiss="alert" aria-label="${message(code: 'default.button.close.label')}">
            <span aria-hidden="true">&times;</span>
        </button>
        <g:if test="${flash.message instanceof Collection}">
             <g:each var="message" in="${flash.message}">
                ${raw(message)}
            </g:each>
        </g:if>
        <g:else>
            ${raw(flash.errors)}
        </g:else>
    </div>
</g:if>