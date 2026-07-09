# Restaurant City `game.swf` — decompiled, rebuildable source

The complete ActionScript 3 source of `game.swf` (Restaurant City 0.9.143a),
recovered with JPEXS (FFDec) and set up as a project that recompiles back into a
working SWF with the Apache Flex SDK.

## What's in the SWF

`game.swf` is a **pure-code SWF**: its only meaningful tags are one `DoABC2`
(the ~1 MB AS3 bytecode) and a `SymbolClass` binding the document class to
`com.playfish.games.cooking.Engine`. Every graphic, sound, and 3D model lives in
separate asset SWFs (`game_asset.swf`, `indoor_asset.swf`, `avatar_asset.swf`,
`sound_asset.swf`, …). So rebuilding `game.swf` embeds nothing — it just
recompiles the source classes.

```
scripts/            799 .as files — the full decompilation
  away3d/           183  the Away3D 3D engine
  com/playfish/          the game + PlayFish "coretech" engine
  com/facebook/          Facebook Connect bindings
  com/adobe/             JSON / crypto / image helpers
  mx/                 3  three standalone Flex utility classes
build.bat           canonical build -> bin/game.swf
asconfig.json       matching config for the AS3 & MXML VS Code extension
.vscode/            launch + build tasks for F5 debugging
bin/                build output (game.swf, build.log)
```

## Build

```bat
build.bat           REM release build -> bin/game.swf
build.bat debug     REM same, with embedded source-debug info
```

Requires the Apache Flex SDK at `C:\flex` and Java on `PATH`. The build calls the
compiler directly (`java -jar C:\flex\lib\mxmlc.jar …`) rather than the Royale
`node_modules/.bin/mxmlc` shim — that shim `execFileSync`s a `.bat` without
`shell: true` and throws `EINVAL` on current Node.

### Why a bare compile

The game was a plain AS3 project, not a Flex/MXML app. It uses only three `mx.*`
utility classes (`mx_internal`, `PropertyChangeEvent`, `PropertyChangeEventKind`),
all present here as source. The build therefore suppresses the default
`flex-config.xml` (`-load-config=`) and links **only** `playerglobal.swc` as an
external library. No Flex framework is compiled in, so the decompiled source
stays authoritative and there's no framework-version drift.

### Stage size (don't skip this)

`game.swf` carries no size metadata of its own; the original SWF header declares
the movie as **760 × 600 @ 25 fps**, and the game code positions its UI assuming a
600 px-tall stage. Without `-default-size`, mxmlc stamps its default **500 × 375**
and everything drawn below y≈375 or right of x≈500 falls off-screen — the SWF
looks blank while running fine. `build.bat` passes `-default-size 760 600` and
`-default-frame-rate=25` to match the original header.

## Running

A bare projector won't fully run this: the game loads its asset SWFs over HTTP
and talks to a PlayFish/Facebook backend, neither of which a standalone player
provides. It needs those assets served and that backend answered before it can
actually play. The debug player is still useful for stepping through the code —
see below.

## Debug in VS Code

Open **this folder** in VS Code with the
[AS3 & MXML extension](https://marketplace.visualstudio.com/items?itemName=bowlerhatllc.vscode-as3mxml)
(recommended via `.vscode/extensions.json`), press **F5**, and pick a config:

- **Build (debug) + Launch game.swf** — runs `build.bat debug`, then launches the
  standalone debug player. Breakpoints in any `scripts/**/*.as` bind to the run.
- **Launch game.swf (no rebuild)** — launches the current `bin/game.swf` as-is.
- **Attach to running Flash debug player** — attaches to an already-running player.

Breakpoints only bind against a **debug** build, so use the debug config (or
`build.bat debug`) when stepping through code.

Debugging a bare launch is still useful even though the game won't fully play: the
debug player surfaces exactly where and why execution stops.

## Verification

| | Original | Rebuilt |
|---|---|---|
| Document class | `com.playfish.games.cooking.Engine` | same |
| AS3 source classes | 799 | all compiled |
| Compiler errors | — | 0 |
| SWF size | 513,510 B | 514,155 B |

The rebuild reproduces the full class set and document class; it is not
byte-identical — the ~1 KB size delta is a newer compiler and different zlib
compression. `away3d.events.BillboardEvent` is unreachable from `Engine`, so an
application compile would strip it; `-includes+=away3d.events.BillboardEvent`
keeps the class set complete.

## Decompiler fixes applied

JPEXS produced clean high-level AS3 with no `§§` P-code stubs. Four spots needed
hand-fixing to recompile — listed here so the diff from raw decompiler output is
transparent:

1. **`com/facebook/data/XMLDataParser.as`** — JPEXS inserted a spurious `this.`
   before namespace-qualified E4X access (`node.this.fb_namespace::uid`). Removed
   it → `node.fb_namespace::uid` (203 occurrences).

2. **`away3d/core/utils/Cast.as`** — in `parseMaterial()` a local `var color:uint`
   shadows the static `Cast.color()` method, so unqualified `color(...)` calls
   bound to the `uint`. Qualified them as `Cast.color(...)` (11 sites).

3. **`away3d/loaders/utils/TextureLoadQueue.as`** — the file-private class
   `LoaderAndRequest` (after the `package` block, so it misses the package
   imports) references `TextureLoader`. Added
   `import away3d.loaders.utils.TextureLoader;`.

4. **`com/playfish/games/cooking/ui/CashPanel.as`** — removed a dangling
   `import com.playfish.coretech.skeleton.billing.*;` for a package present in no
   SWF and referenced by nothing.
