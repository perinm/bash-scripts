# coding=utf-8
from __future__ import absolute_import

import octoprint.plugin
from octoprint.events import Events


class ActiveconnectionsPlugin(octoprint.plugin.AssetPlugin,
                              octoprint.plugin.TemplatePlugin,
                              octoprint.plugin.EventHandlerPlugin,
                              octoprint.plugin.SettingsPlugin
                              ):

    def __init__(self):
        self.active_connections = []

    # ~~ EventHandlerPlugin mixin

    def on_event(self, event, payload):
        if event not in [Events.CLIENT_AUTHED, Events.CLIENT_CLOSED]:
            return

        if self._settings.get(["remove_string"]) != "" and payload.get("remoteAddress", False):
            payload["remoteAddress"] = payload["remoteAddress"].replace(self._settings.get(["remove_string"]), "")

        if event == Events.CLIENT_AUTHED and not any(
            connection["remoteAddress"] == payload["remoteAddress"] and connection["username"] == payload["username"]
            for connection in self.active_connections):
            self.active_connections.append(payload)

        if event == Events.CLIENT_CLOSED and any(
            connection["remoteAddress"] == payload["remoteAddress"] for connection in self.active_connections):
            self.active_connections = [connection for connection in self.active_connections if
                                       not (connection['remoteAddress'] == payload["remoteAddress"])]

        self._logger.debug(self.active_connections)
        self._plugin_manager.send_plugin_message(self._identifier, {"active_connections": self.active_connections})

    # ~~ SettingsPlugin mixin

    def get_settings_defaults(self):
        return {
            "remove_string": ""
        }

    # ~~ TemplatePlugin mixin

    def get_template_vars(self):
        return {"plugin_version": self._plugin_version}

    def get_template_configs(self):
        return [{'type': "sidebar", 'icon': "network-wired", 'custom_bindings': True,
                 'template': "activeconnections_sidebar.jinja2"}]

    # ~~ AssetPlugin mixin

    def get_assets(self):
        return {
            "css": ["css/activeconnections.css"],
            "js": ["js/activeconnections.js"]
        }

    # ~~ Softwareupdate hook

    def get_update_information(self):
        return {
            "activeconnections": {
                "displayName": "Active Connections",
                "displayVersion": self._plugin_version,

                # version check: github repository
                "type": "github_release",
                "user": "jneilliii",
                "repo": "OctoPrint-ActiveConnections",
                "current": self._plugin_version,
                "stable_branch": {'name': "Stable", 'branch': "master", 'comittish': ["master"]},
                "prerelease_branches": [
                    {'name': "Release Candidate", 'branch': "rc", 'comittish': ["rc", "master"]}
                ],
                "pip": "https://github.com/jneilliii/OctoPrint-ActiveConnections/archive/{target_version}.zip",
            }
        }


__plugin_name__ = "Active Connections"
__plugin_pythoncompat__ = ">=3,<4"  # only python 3


def __plugin_load__():
    global __plugin_implementation__
    __plugin_implementation__ = ActiveconnectionsPlugin()

    global __plugin_hooks__
    __plugin_hooks__ = {
        "octoprint.plugin.softwareupdate.check_config": __plugin_implementation__.get_update_information
    }
