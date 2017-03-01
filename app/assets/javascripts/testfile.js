/*global updateStatusMessage, toggleSlide, generateCountSummary */
/* exported toggleSlide, generateCountSummary, updateStatusMessage */
/* exports far_run_comparison, generateAgentCountSummary */
// eslint-disable-next-line
function far_run_comparison() {
    var advertiser_id = $('#txtAdvertiserId').val();
    updateStatusMessage("#status-wrapper img.loadicon", true, "#status", "Generating result table...");
    $('#summary-table').show();
    $.ajax({
        dataType: "json",
        url: "/far_admin/id?id=" + advertiser_id,
        cache: false
    }).done(function (data) {
        updateStatusMessage("#status-wrapper img.loadicon", false, "#status", "Received response.");
        far_display_comparison_results(data);
    });
}
function far_display_comparison_results(data) {
    var results = data.result;
    // Add summary table to details place holder
    $('#diffresults').html("<table class=\"table table-bordered\" id=\"summary-table\"><tr><th width=\"10%\">Field Name</th><th width=\"20%\">Result</th><th width=\"35%\">SOLR</th><th width=\"35%\">ElasticSearch</th></tr></table>");
    // Display results in summary table
    far_populate_table("#summary-table", results);
    //$('#diffwraper').show();
    updateStatusMessage("#status-wrapper img.loadicon", false, "#status", "Received response.");
    $('#summary-toggle-button').show();
    $('#summary-table').show();
    toggleSlide('#summary-table');
}
function far_populate_table(tableid, results) {
    if (results === undefined)
        updateStatusMessage("#status-wrapper img.loadicon", false, "#status", "Failed to get results."); 
    if (results.diff === undefined)
        updateStatusMessage("#status-wrapper img.loadicon", false, "#status", "Failed to get results.diff"); 
    for (var item in results.diff) { 
        var field = results.diff[item.toString()];
        if (field === undefined) continue;
        var field_value = field.solr_value;
        var es_value = field.es_value;
        if (field_value != null && field_value.indexOf != undefined && field_value.indexOf(',') > -1) field_value = field_value.replace(/,/g, ', ');
        if (typeof (field_value) == 'object') field_value = JSON.stringify(field.solr_value);
        if (typeof (es_value) == 'object') es_value = JSON.stringify(field.es_value);
        var newrow = $("<tr><td>" + field.name + "</td><td>" + field.msg + "</td><td>" + field_value + "</td><td>" + es_value + "</td></tr>");
        if (field.fail != undefined && field.fail == '1') {
            newrow.addClass("alert-danger");
        }
        $(tableid).append(newrow);
    } 
}
// Generate Property Count per State summary table
// eslint-disable-next-line
function generateAgentCountSummary() {
    generateCountSummary("FAR", "/far_admin/health");
}
