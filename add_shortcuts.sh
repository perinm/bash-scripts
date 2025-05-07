#!/bin/bash

add_custom_shortcut() {
    local NAME="$1"
    local COMMAND="$2"
    local BINDING="$3"
    local KEYBINDINGS_PATH="org.gnome.settings-daemon.plugins.media-keys custom-keybindings"
    local CURRENT_BINDINGS=$(gsettings get $KEYBINDINGS_PATH)

    # Check if this exact shortcut (name, command, binding) already exists
    local i=0
    while true; do
        local check_path_segment="/custom${i}/"
        # Check if this path segment exists in the current bindings string
        if echo "$CURRENT_BINDINGS" | grep -qF "$check_path_segment"; then
            local existing_custom_path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${i}/"
            
            # Fetch existing properties
            local existing_name_raw
            local existing_command_raw
            local existing_binding_raw
            existing_name_raw=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$existing_custom_path" name)
            existing_command_raw=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$existing_custom_path" command)
            existing_binding_raw=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$existing_custom_path" binding)

            # Strip single quotes (e.g., 'value' -> value)
            local existing_name="${existing_name_raw#\'}"
            existing_name="${existing_name%\'}"
            local existing_command="${existing_command_raw#\'}"
            existing_command="${existing_command%\'}"
            local existing_binding="${existing_binding_raw#\'}"
            existing_binding="${existing_binding%\'}"

            # Compare with the shortcut to be added
            if [ "$existing_name" == "$NAME" ] && \
               [ "$existing_command" == "$COMMAND" ] && \
               [ "$existing_binding" == "$BINDING" ]; then
                echo "Shortcut '$NAME' with command '$COMMAND' and binding '$BINDING' already exists at /custom${i}/. Skipping."
                return 0 # Indicate success, no action taken
            fi
            ((i++))
        else
            # No more /custom${i}/ found, break the loop
            break
        fi
    done

    # Determine the next available index
    local NEXT_INDEX=0
    while echo "$CURRENT_BINDINGS" | grep -q "/custom${NEXT_INDEX}/"; do
        ((NEXT_INDEX++))
    done
    local NEW_PATH="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${NEXT_INDEX}/"

    # Create the new keybinding path string
    if [[ "$CURRENT_BINDINGS" == "@as []" ]] || [[ "$CURRENT_BINDINGS" == "[]" ]]; then
        NEW_BINDINGS="['${NEW_PATH}']"
    else
        # Remove trailing ] and append the new path
        NEW_BINDINGS="${CURRENT_BINDINGS%]*}, '${NEW_PATH}']"
    fi

    # Set the new array of keybindings
    gsettings set $KEYBINDINGS_PATH "$NEW_BINDINGS"

    # Assign the properties to the new keybinding
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$NEW_PATH name "$NAME"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$NEW_PATH command "$COMMAND"

    # Wipe any existing built-in GNOME binding under media-keys that uses the same accelerator.
    # This helps prevent conflicts that stop custom shortcuts from working after reboot.
    echo "Checking for conflicting built-in shortcuts for accelerator: $BINDING"
    gsettings list-recursively org.gnome.settings-daemon.plugins.media-keys | \
      command awk -v acc_val="$BINDING" '
        BEGIN {
          # GSettings outputs values with single quotes, e.g., '\''<Super>v'\''
          # So, construct the target string to match this format.
          quoted_acc = "'\''" acc_val "'\''";
        }
        # Check if the schema is the main media-keys schema and the value matches the accelerator.
        $1 == "org.gnome.settings-daemon.plugins.media-keys" && $3 == quoted_acc {
          print $2  # Print the key (e.g., "terminal", "screensaver")
        }
      ' | \
      while IFS= read -r key_to_clear; do
        # Ensure key_to_clear is not empty and not "custom-keybindings" (which holds the list of custom ones)
        if [ -n "$key_to_clear" ] && [ "$key_to_clear" != "custom-keybindings" ]; then
          echo "Clearing conflicting built-in binding: org.gnome.settings-daemon.plugins.media-keys $key_to_clear (was using $BINDING)"
          gsettings set org.gnome.settings-daemon.plugins.media-keys "$key_to_clear" "[]"
        fi
      done

    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$NEW_PATH binding "$BINDING"

    echo "Added shortcut: '$NAME' -> '$COMMAND' ('$BINDING')"
    # Optional: Show resulting keybindings array (for debugging)
    # gsettings get $KEYBINDINGS_PATH
}

add_custom_shortcut 'CopyQ' 'copyq show' '<Super>v'
add_custom_shortcut 'Open Alacritty Terminal' 'alacritty' '<Control><Alt>T'