AjaxAutoCompleter.prototype.log = function (e) {
}

function AjaxAutoCompleter(params) {
    this.url = params.url;
    this.match_params = params.match_params;
    this.select_element = params.select_element;
    this.display_element = params.display_element;
    this.min_length = params.min_length;
    this.label_property = params.label_property;
    this.result_properties = params.result_properties;
}

AjaxAutoCompleter.setup_ajax_form = function(author_select, author_display_data, ajax_url, ajax_params) {
    var params = {
        url: ajax_url,
        match_params: ajax_params,
        select_element: author_select + " .ui-widget input",
        display_element: author_display_data,
        result_properties: ['first_name', 'last_name', 'preferred_name', 'department', 'unique_id', 'email'],
        label_property: 'preferred_name',
        min_length: 2
    };

    var completer = new AjaxAutoCompleter(params);
    completer.log("builder: " + params['url']);
    completer.log("builder: " + params['select_element']);
    $(params.select_element).data("ajax_completer", completer).
        val("").
        autocomplete({
            minLength: completer.min_length,
            source: completer.query_data,
            select: completer.select_callback
        });

    var pref_name = $(author_display_data + ' .preferred_name').val();
    if (pref_name) {
        $(author_select  + ' .ui-widget input').val(pref_name);
    }
}


AjaxAutoCompleter.clear_ajax_form = function(author_select) {
    var completer = $(author_select + ' .ui-widget input').data("ajax_completer");
    if (undefined != completer) {
        completer.set_element_with_ajax_result({});
    }
}


AjaxAutoCompleter.prototype.query_data = function (query, callback) {
    var term = query.term;
    var completer = this.element.data("ajax_completer");
    if (term) {
        var query_params = completer.match_params.replace("MATCH", term);
        completer.log("query_data ?" + query_params);
        completer.set_element_with_ajax_result({});
        $.ajax({
            url: completer.url,
            data: query_params,
            dataType: 'jsonp',
            success: function (response, xhr) {
                results = response;
                if (results.length > 0) {
                    for (var i = 0; i < results.length; i++) {
                        results[i].label = results[i][completer.label_property];
                    }
                } else {
                    completer.set_element_with_ajax_result({});
                }
                callback(results);
            },
            error: function () {
                callback([]);
            }
        });
    } else {
        completer.log("query_data term empty");
    }
};

AjaxAutoCompleter.prototype.select_callback = function (event, ui) {
    var completer = $(this).data("ajax_completer");
    var ajax_data = ui.item;
    completer.log("select_callback");
    completer.set_element_with_ajax_result(ajax_data);
}


AjaxAutoCompleter.Solr_props = ["unique_id"];

AjaxAutoCompleter.prototype.set_element_with_ajax_result = function (ajax_data) {
    this.log("set_element_with_ajax_result " + ($.isEmptyObject(ajax_data) ? "{}" : JSON.stringify(ajax_data)));
    var data_dest = this.display_element;
    var ajax_keys = this.result_properties;

    for (var i = 0; i < ajax_keys.length; i++) {
        var ajax_prop = ajax_keys[i];
        var elements = $(data_dest + " ." + ajax_prop);
        var text = ajax_data[ajax_prop];
        if (!text) {
            text = "";
        }
        for (var eli in elements) {
            var el = elements[eli];
            // determine whether to use val or text fct to assign text value
            if (el.form == undefined) {
                el.textContent = text;
            } else {
                el.value = text;
            }
        }
    }
}