spawn.ui.define([
    "sap/m/MessageToast"
], function(MessageToast) {
    'use strict';

    return {
        SetAlumini: function(oBindingcontext,aSelectedContexts) {
            aSelectedContexts.forEach(element =>{
                MessageToast.show("hello World");
                var aData = j.Query.ajax({
                    type:'PATCH',
                    contentType: "application/json",
                    url:"/odata/v4/student-db"+aSelectedContexts[0].sPath,
                    dataType: "json",
                    async: false,
                    json: {'is_alumini':true}

                });

            });
            console.log(element);
        }
    };
});