#!/bin/bash

add_custom_shortcut() {
    local NAME="$1"
    local COMMAND="$2"
    local BINDING="$3"
    local KEYBINDINGS_PATH="org.gnome.settings-daemon.plugins.media-keys custom-keybindings"
    local CURRENT_BINDINGS_LIST_STR
    CURRENT_BINDINGS_LIST_STR=$(gsettings get $KEYBINDINGS_PATH)

    local i=0
    local existing_path_for_this_name=""

    # Iterate through existing custom keybindings to find if one with this NAME already exists
    while true; do
        local current_custom_path_segment="/custom${i}/"
        if echo "$CURRENT_BINDINGS_LIST_STR" | grep -qF "$current_custom_path_segment"; then
            local full_custom_path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${i}/"
            
            local existing_name_raw
            existing_name_raw=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$full_custom_path" name 2>/dev/null)
            
            if [ -n "$existing_name_raw" ]; then
                local existing_name="${existing_name_raw#\'}"
                existing_name="${existing_name%\'}"

                if [ "$existing_name" == "$NAME" ]; then
                    existing_path_for_this_name="$full_custom_path"
                    break # Found our named shortcut path
                fi
            fi
            ((i++))
        else
            break # No more /custom${i}/ paths in the list
        fi
    done

    local target_path=""
    local new_path_added_to_list=false

    if [ -n "$existing_path_for_this_name" ]; then
        # A shortcut with this NAME exists, check if command and binding need updating
        target_path="$existing_path_for_this_name"
        local existing_command_raw
        local existing_binding_raw
        existing_command_raw=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$target_path" command)
        existing_binding_raw=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$target_path" binding)

        local existing_command="${existing_command_raw#\'}"
        existing_command="${existing_command%\'}"
        local existing_binding="${existing_binding_raw#\'}"
        existing_binding="${existing_binding%\'}"

        if [ "$existing_command" == "$COMMAND" ] && [ "$existing_binding" == "$BINDING" ]; then
            echo "Shortcut '$NAME' with command '$COMMAND' and binding '$BINDING' already exists at $target_path and is correct. Skipping."
            # Still run conflict clearing for good measure, as defaults might have been reset
        else
            echo "Shortcut '$NAME' found at $target_path. Updating command/binding."
            gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$target_path" command "$COMMAND"
            gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$target_path" binding "$BINDING"
            echo "Updated shortcut '$NAME' at $target_path to command '$COMMAND' and binding '$BINDING'."
        fi
    else
        # No shortcut with this NAME exists, find a new slot and add it
        local NEXT_INDEX=0
        while true; do # Loop to find the first unused /customN/ slot for the new path
            local check_path_segment="/custom${NEXT_INDEX}/"
            # We need to check if *any* dconf path exists at /customN/, not just if it's in the list,
            # as another app might have created it without adding it to the main list yet.
            if gsettings list-schemas | grep -q "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${NEXT_INDEX}/"; then
                 # A path /customN/ exists, try next index.
                 # This check is a bit broad with list-schemas, more precise would be to try a get and check error, but this is simpler for now.
                 # A more robust check would be: `gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/.../custom${NEXT_INDEX}/ name >/dev/null 2>&1`
                 # For simplicity, we'll just check against the CURRENT_BINDINGS_LIST_STR first, then refine if needed.
                if echo "$CURRENT_BINDINGS_LIST_STR" | grep -q "/custom${NEXT_INDEX}/"; then # Check if in the current active list
                    ((NEXT_INDEX++))
                    continue
                fi
                # If it exists in dconf but not in the list, it's an orphaned or externally managed path.
                # We should still try to find a truly new numeric slot that isn't even in dconf.
                # A simple way for now: iterate until we find a number N such that /customN/ is NOT in CURRENT_BINDINGS_LIST_STR.
                # This might lead to sparse numbering if other apps create high-numbered custom paths.
                # A truly robust method would query all child nodes of .../custom-keybindings/ in dconf.
                # Let's stick to the current logic of finding the next N not in the *list*.
                if gsettings list-recursively "org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${NEXT_INDEX}/" > /dev/null 2>&1; then                    
                    ((NEXT_INDEX++))
                else
                    break # Found an index N where no dconf path exists yet.
                fi                
            else
                break # Found an unused index based on list-schemas (less reliable)
                      # Fallback: Use the original logic based on CURRENT_BINDINGS_LIST_STR if the above is too complex/unreliable
            fi
        done
        # Reverting to simpler next index finding based on the active list to avoid overcomplication for now.
        NEXT_INDEX=0
        while echo "$CURRENT_BINDINGS_LIST_STR" | grep -q "/custom${NEXT_INDEX}/"; do
            ((NEXT_INDEX++))
        done

        target_path="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${NEXT_INDEX}/"
        echo "Adding new shortcut '$NAME' at $target_path."

        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$target_path" name "$NAME"
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$target_path" command "$COMMAND"
        gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:"$target_path" binding "$BINDING"

        # Update the main list of custom keybindings
        local NEW_BINDINGS_LIST_STR
        if [[ "$CURRENT_BINDINGS_LIST_STR" == "@as []" ]] || [[ "$CURRENT_BINDINGS_LIST_STR" == "[]" ]]; then
            NEW_BINDINGS_LIST_STR="['$target_path']"
        else
            NEW_BINDINGS_LIST_STR="${CURRENT_BINDINGS_LIST_STR%]*}, '$target_path']"
        fi
        gsettings set $KEYBINDINGS_PATH "$NEW_BINDINGS_LIST_STR"
        new_path_added_to_list=true
        echo "Added shortcut '$NAME' -> '$COMMAND' ('$BINDING') to list."
    fi

    # Wipe any existing built-in GNOME binding under media-keys that uses the same accelerator.
    # This should run regardless of whether we added/updated or found existing, 
    # as defaults might have been reset by other events.
    echo "Checking for conflicting built-in shortcuts for accelerator: $BINDING"
    gsettings list-recursively org.gnome.settings-daemon.plugins.media-keys | \
      command awk -v acc_val="$BINDING" '
        BEGIN {
          quoted_acc = sprintf("'\''%s'\''", acc_val);
        }
        $1 == "org.gnome.settings-daemon.plugins.media-keys" && $3 == quoted_acc {
          print $2
        }
      ' | \
      while IFS= read -r key_to_clear; do
        if [ -n "$key_to_clear" ] && [ "$key_to_clear" != "custom-keybindings" ]; then
          echo "Clearing conflicting built-in binding: org.gnome.settings-daemon.plugins.media-keys $key_to_clear - was using $BINDING"
          gsettings set org.gnome.settings-daemon.plugins.media-keys "$key_to_clear" "[]"
        fi
      done

    # If we added a new path to the list, we MIGHT need to ensure the list is still sorted for dconf,
    # but gsettings should handle this. For now, no explicit sort.

    # Optional: Show resulting keybindings array (for debugging)
    # gsettings get $KEYBINDINGS_PATH
}

add_custom_shortcut 'CopyQ' 'copyq show' '<Super>v'
add_custom_shortcut 'Open Alacritty Terminal' 'alacritty' '<Control><Alt>T'