# Tenacity macOS Install

This is the macOS install path that worked for Tenacity 1.3.4 through MacPorts.

## Version Gate

Before repeating the workaround, check the current MacPorts package:

- https://ports.macports.org/port/tenacity/
- https://codeberg.org/tenacityteam/tenacity/releases

If MacPorts ships a version newer than 1.3.4, try the plain MacPorts install first:

```bash
sudo port selfupdate
sudo port install tenacity
open /Applications/MacPorts/Tenacity.app
```

Only apply the 1.3.4-specific config workarounds below if the same crash or AAC/M4A import failures reproduce.

## Why MacPorts

Prefer MacPorts over a source build for this app on macOS.

The source-build attempts were weaker:

- Tenacity `main` pulled `portaudio` with ASIO through `vcpkg`; ASIO is Windows-only.
- Tenacity `v1.3.4` source hit stale vcpkg/CMake/wxWidgets launch problems.

MacPorts produced a normal app bundle at:

```text
/Applications/MacPorts/Tenacity.app
```

## Install

Install MacPorts from the official package for the current macOS release:

```text
https://www.macports.org/install.php
```

For the macOS Tahoe package used in this run, the official package was:

```text
https://distfiles.macports.org/MacPorts/MacPorts-2.12.5-26-Tahoe.pkg
```

The package was Apple-notarized and signed by the MacPorts Developer ID. The SHA2-256 checksum used for that package was:

```text
405f99f70bba45e85dbc2145a19602ad8973d9896f0bc53f07b2a753c7c1629e
```

Verify a downloaded package before installing it:

```bash
pkgutil --check-signature "$HOME/Downloads/MacPorts-2.12.5-26-Tahoe.pkg"
shasum -a 256 "$HOME/Downloads/MacPorts-2.12.5-26-Tahoe.pkg"
```

Install Tenacity:

```bash
sudo port selfupdate
sudo port install tenacity
```

Create a user-facing launcher in `~/Applications`:

```bash
mkdir -p "$HOME/Applications"
ln -sfn /Applications/MacPorts/Tenacity.app "$HOME/Applications/Tenacity.app"
open "$HOME/Applications/Tenacity.app"
```

Do not copy the app bundle out of `/Applications/MacPorts`; use the symlink.

## Startup Crash Workaround

For Tenacity 1.3.4, the crash was not microphone permissions. The failing path was the wxWidgets/theme drawing path:

```text
AColor::UseThemeColour -> LWSlider::DrawToBitmap -> ASlider::OnPaint -> wxNSColorRefData::GetCGColor
```

Keep Tenacity on the default theme path with theme blending disabled.

Back up the profile first:

```bash
profile="$HOME/Library/Application Support/tenacity"
backup="$HOME/Library/Application Support/tenacity-backups/codex-$(date -u +%Y%m%dT%H%M%SZ)"
mkdir -p "$backup"
if [ -d "$profile" ]; then
  cp -R "$profile" "$backup/profile-copy"
fi
```

Edit:

```text
~/Library/Application Support/tenacity/tenacity.cfg
```

Under `[GUI]`, set:

```ini
[GUI]
BlendThemes=0
```

Remove any `Theme=` line from `[GUI]`.

If crash recovery keeps reopening failed project state, remove `[ActiveProjects]` from `tenacity.cfg` and inspect crash-session files:

```bash
find "$HOME/Library/Application Support/tenacity/SessionData" \
  -maxdepth 1 \
  -type f \
  -name 'New Project *.aup3unsaved*' \
  -print
```

After confirming there is no real unsaved work in that list, remove the blank crash-session files:

```bash
find "$HOME/Library/Application Support/tenacity/SessionData" \
  -maxdepth 1 \
  -type f \
  -name 'New Project *.aup3unsaved*' \
  -delete
```

After Tenacity opens, do not enable theme blending or change the app theme unless a newer Tenacity version has fixed this path.

## AAC and M4A Import

The MacPorts `ffmpeg` port installed FFmpeg 8 in this run, which exposed `libavformat.62`. Tenacity 1.3.4 only had FFmpeg import resolvers through `libavformat.61`, so AAC/M4A files still failed until FFmpeg 7 was installed.

Install FFmpeg 7:

```bash
sudo port install ffmpeg7
```

Configure Tenacity to use the FFmpeg 7 library:

```ini
[FFmpeg]
Enabled=1
FFmpegLibPath=/opt/local/libexec/ffmpeg7/lib/libavformat.61.dylib
```

The expected compatible libraries are:

```text
/opt/local/libexec/ffmpeg7/lib/libavformat.61.dylib
/opt/local/libexec/ffmpeg7/lib/libavcodec.61.dylib
/opt/local/libexec/ffmpeg7/lib/libavutil.59.dylib
```

Relaunch Tenacity. If the FFmpeg loader succeeds, `Enabled=1` stays in `tenacity.cfg`. If loading fails, Tenacity flips it back to `Enabled=0`.

Optional file check:

```bash
ffprobe7 -v error \
  -show_entries format=format_name,duration \
  -show_entries stream=codec_type,codec_name \
  -of default=noprint_wrappers=1 \
  path/to/file.m4a
```

## Cleanup From Failed Attempts

After moving to MacPorts, remove broken manual builds and copied apps:

```bash
rm -rf "$HOME/dev/tenacity"
rm -rf "$HOME/Applications/Tenacity.app"
ln -sfn /Applications/MacPorts/Tenacity.app "$HOME/Applications/Tenacity.app"
```

Optional MacPorts cleanup:

```bash
sudo port clean --all tenacity ffmpeg7
```

Small root-owned temp logs may remain from earlier runs, such as:

```text
/tmp/tenacity-macports-install.log
/tmp/tenacity-ffmpeg7-install.log
```

Delete those only if they are no longer useful.
