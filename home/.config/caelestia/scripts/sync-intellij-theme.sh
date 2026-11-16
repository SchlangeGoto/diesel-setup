#!/bin/bash
# Sync the Caelestia colour scheme into the local IntelliJ-platform theme
# plugins (IntelliJ IDEA, PyCharm, and any other JetBrains IDE that has the
# Caelestia theme plugin installed).
set -euo pipefail

STATE="${XDG_STATE_HOME:-$HOME/.local/state}/caelestia/theme"
JETBRAINS_DATA="${XDG_DATA_HOME:-$HOME/.local/share}/JetBrains"
JETBRAINS_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/JetBrains"

if [[ ! -f "$STATE/caelestia-intellij-theme.json" || ! -f "$STATE/caelestia-intellij-editorscheme.xml" ]]; then
    echo "error: Caelestia JetBrains templates have not been rendered yet" >&2
    exit 1
fi

ensure_live_reload() {
    local product="$1"
    local classes_dir="$2"
    local live_plugin="$JETBRAINS_DATA/$product/LivePlugin"
    local script_dir="$JETBRAINS_CONFIG/$product/live-plugins/reload-theme"
    local script="$script_dir/plugin.groovy"

    # Only install for IDEs that already have LivePlugin; never overwrite a
    # script that is already running (that would spawn duplicate watchers).
    [[ -d "$live_plugin" ]] || return 0
    [[ -f "$script" ]] && return 0

    mkdir -p "$script_dir"
    cat > "$script" <<'GROOVY'
import com.intellij.ide.plugins.DynamicPlugins
import com.intellij.ide.plugins.PluginManagerCore
import com.intellij.openapi.extensions.PluginId
import com.intellij.openapi.application.ApplicationManager
import java.nio.file.*

def pluginIdString = "com.caelestia.theme"
Path watchDir = Paths.get("__WATCH_DIR__")

def pluginId = PluginId.getId(pluginIdString)
def watcher = FileSystems.default.newWatchService()
watchDir.register(watcher, StandardWatchEventKinds.ENTRY_MODIFY, StandardWatchEventKinds.ENTRY_CREATE)

println "Auto-reloader active. Watching directory: ${watchDir}"

new Thread({
    while (true) {
        def key = watcher.take()
        boolean hasChanged = false
        for (def event : key.pollEvents()) {
            hasChanged = true
        }
        if (hasChanged) {
            Thread.sleep(300)
            ApplicationManager.application.invokeLater {
                def pluginDescriptor = PluginManagerCore.getPlugin(pluginId)
                if (pluginDescriptor != null) {
                    boolean unloaded = DynamicPlugins.INSTANCE.unloadPlugin(pluginDescriptor, new DynamicPlugins.UnloadPluginOptions())
                    if (unloaded) {
                        DynamicPlugins.INSTANCE.loadPlugin(pluginDescriptor)
                        println "Theme auto-reloaded successfully at ${new Date().format('HH:mm:ss')}"
                    } else {
                        println "Failed to unload theme plugin."
                    }
                } else {
                    println "Plugin ID '${pluginIdString}' not found."
                }
            }
        }
        key.reset()
    }
}).start()
GROOVY

    sed -i "s|__WATCH_DIR__|$classes_dir|" "$script"
    echo "  ✓ live reload watcher: $product"
}

mode="${SCHEME_MODE:-$(caelestia scheme get -m 2>/dev/null || echo dark)}"
case "$mode" in
    light)
        dark=false
        parent_theme="Islands Light"
        parent_scheme="Default"
        ;;
    *)
        dark=true
        parent_theme="Islands Dark"
        parent_scheme="Darcula"
        ;;
esac

found=0

while IFS= read -r classes_dir; do
    theme_dir="$(dirname "$classes_dir")"
    product="$(basename "$(dirname "$theme_dir")")"

    cp "$STATE/caelestia-intellij-theme.json" "$classes_dir/caelestia.theme.json"
    cp "$STATE/caelestia-intellij-editorscheme.xml" "$classes_dir/caelestia.theme.xml"

    sed -i \
        -e "s/__DARK_MODE__/$dark/g" \
        -e "s/__PARENT_THEME__/$parent_theme/g" \
        "$classes_dir/caelestia.theme.json"
    sed -i \
        -e "s/__PARENT_SCHEME__/$parent_scheme/g" \
        "$classes_dir/caelestia.theme.xml"

    # The IDE sometimes stores a partial copy of the editor scheme. It only
    # contains stale file-status colours, so let the plugin scheme provide them.
    user_scheme="$JETBRAINS_CONFIG/$product/colors/_@user_Caelestia.icls"
    if [[ -f "$user_scheme" ]]; then
        mv "$user_scheme" "$user_scheme.caelestia-backup"
    fi

    ensure_live_reload "$product" "$classes_dir"
    echo "  ✓ $product ($classes_dir)"
    found=1
done < <(find "$JETBRAINS_DATA" -maxdepth 4 -type d -path '*/Caelestia/classes' 2>/dev/null | sort)

if [[ "$found" -eq 0 ]]; then
    echo "No Caelestia theme plugin found under $JETBRAINS_DATA" >&2
    echo "Install the plugin into an IDE first." >&2
    exit 1
fi

echo
echo "Done. IntelliJ and PyCharm reload live through the reload-theme"
echo "LivePlugin script; other JetBrains IDEs pick it up on next start."
