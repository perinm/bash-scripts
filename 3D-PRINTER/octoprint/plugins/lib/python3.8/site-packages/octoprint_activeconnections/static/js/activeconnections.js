/*
 * View model for Active Connections
 *
 * Author: jneilliii
 * License: AGPLv3
 */
$(function() {
    function ActiveconnectionsViewModel(parameters) {
        var self = this;

        self.settingsViewModel = parameters[0];

        self.active_connections = ko.observableArray([]);

        self.display_text = function(data) {
            return (data["remoteAddress"] + " (" + data["username"] + ")");
        };

        self.onDataUpdaterPluginMessage = function (plugin, data) {
            if (plugin !== "activeconnections") {
                return;
            }

            self.active_connections(data["active_connections"]);
        };
    }

    OCTOPRINT_VIEWMODELS.push({
        construct: ActiveconnectionsViewModel,
        dependencies: [ "settingsViewModel" ],
        elements: [ "#sidebar_plugin_activeconnections", "#settings_plugin_activeconnections" ]
    });
});
