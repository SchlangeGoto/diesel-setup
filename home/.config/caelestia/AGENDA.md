# Agenda tab

A local Caelestia shell extension that adds an **Agenda** dashboard tab with
Google Calendar events and Todoist tasks.

## Where it lives

- Shell checkout: `~/.config/quickshell/caelestia`
  - branch: `local/agenda`
  - base: `v2.5.0`
- Tab: `modules/dashboard/AgendaTab.qml`
- Service: `services/Agenda.qml`
- Tab registration: `modules/dashboard/Content.qml`
- Dashboard day click: `modules/dashboard/dash/Calendar.qml`, `modules/dashboard/Dash.qml`
- Clock popout: `modules/bar/popouts/ClockPopout.qml`, `modules/bar/popouts/MiniCalendar.qml`, `modules/bar/Bar.qml`
- `agenda` IPC target: `modules/Shortcuts.qml`
- Nexus toggles: `modules/nexus/pages/panels/DashboardPanel.qml`
- Helpers:
  - `~/.local/bin/agenda-calendar`
  - `~/.local/bin/agenda-todoist`
  - `~/.local/bin/agenda-todoist-close`
- Settings: `~/.config/caelestia/agenda.json`
- Todoist token: `~/.config/caelestia/secrets/todoist` (`chmod 600`)

The packaged shell under `/etc/xdg/quickshell/caelestia` is untouched and acts as
the fallback.

## Usage

- Open the dashboard and select the **Agenda** tab.
- Or run:

```sh
caelestia shell agenda open
```

- The **Calendar** and **Todoist** buttons in the Agenda header enable/disable
  each source. The same switches are in **Nexus → Panels → Dashboard → Agenda**.
- Clicking a calendar event or Todoist task opens a native detail card.
- The detail card has explicit **Open in Google Calendar** / **Open in Todoist** buttons.
- Use the date arrows in the Agenda header to move by day; **Today** jumps to today and **7 days** returns to the rolling view.
- Personal Todoist tasks have checkboxes.
- `Prüfungen` and `Eduvidual` tasks are marked `auto` and are read-only so they
  don't fight the school sync.

## Settings

`~/.config/caelestia/agenda.json`:

```json
{
    "calendar": {
        "enabled": true,
        "days": 7,
        "calendars": ["School", "Tests & Due Dates", "Privat"]
    },
    "todoist": {
        "enabled": true,
        "days": 3
    }
}
```

- `calendar.days`: rolling lookahead window when no day is selected.
- `calendar.calendars`: exact Google Calendar display names. The helper trims
  whitespace, so `"School "` matches `"School"`.
- `todoist.days`: how many days ahead to include in addition to overdue/today.

## Data sources

- Calendar: `gws calendar calendarList list` + `gws calendar events list` for the configured calendars. Supports a single day via `agenda-calendar --date YYYY-MM-DD`.
- Todoist: Todoist API v1, `/tasks` and `/projects`; the shell filters by day or rolling window.
- Both helpers cache their last successful output in `~/.cache/caelestia/` and
  serve the cache with `"stale": true` if the network/API is unavailable.
- The clock entry on the left bar has a lightweight hover calendar. Clicking a
  day opens it in Agenda.
- Clicking a day in the dashboard month grid also opens that day in Agenda.

The Todoist token is read from, in order:

1. `TODOIST_TOKEN`
2. `~/.config/caelestia/secrets/todoist`
3. `~/.config/untis/config.json`
4. `ssh sync ...` fallback

## Updating Caelestia

Keep the checkout on the same tag as the installed `caelestia-shell` package,
then rebase the local branch:

```sh
cd ~/.config/quickshell/caelestia
git fetch --tags
git rebase v2.6.0        # replace with the new tag
caelestia shell -r
```

Conflicts should normally only be in the tab registration in
`modules/dashboard/Content.qml` and the `agenda` IPC handler in
`modules/Shortcuts.qml`. New files are unaffected.

If the shell breaks after an update, fall back to the packaged copy:

```sh
mv ~/.config/quickshell/caelestia ~/.config/quickshell/caelestia.broken
caelestia shell -r
```

## Optional keybind

`caelestia shell agenda open` can be bound like any other command. For example,
add this to `~/.config/caelestia/hypr-user.lua`:

```lua
hl.bind("SUPER + A", hl.dsp.exec_cmd("caelestia shell agenda open"))
```

This is not added automatically; adjust the key to your liking.
