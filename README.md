# Restaurant City `game.swf` — decompiled & rebuildable source

Full ActionScript 3 decompilation of `game.swf` (Restaurant City 0.9.143a),
set up as a buildable project that recompiles **byte-complete** back to a SWF.

## What this is

`game.swf` is a **pure-code SWF** — its only meaningful tags are one `DoABC2`
(the ~1 MB ActionScript 3 bytecode blob) and a `SymbolClass` binding the SWF's
document class to `com.playfish.games.cooking.Engine`. All graphics, sounds and
3D models live in the *sibling* SWFs (`game_asset.swf`, `indoor_asset.swf`,
`avatar_asset.swf`, `sound_asset.swf`, …), so rebuilding `game.swf` needs no
asset embedding — just recompiling the 798 classes.

```
scripts/            798 .as source files (the full decompilation)
  away3d/           183  — the Away3D 2.x 3D engine
  com/playfish/     ...  — the actual game + PlayFish "coretech" engine
  com/facebook/     ...  — Facebook Connect API bindings
  com/adobe/        ...  — JSON / crypto / image helpers
  mx/                 3  — three standalone Flex utility classes
build.bat           canonical build → bin/game.swf
asconfig.json       IntelliSense config for the AS3&MXML VS Code extension
bin/                build output (game.swf, build.log)
```

## How to build

```bat
build.bat
```

Requires the Apache Flex SDK at `C:\flex` (the same one `habbo-client-cc` uses)
and Java on `PATH`. The build invokes the compiler directly:

```
java -jar C:\flex\lib\mxmlc.jar +flexlib=C:\flex\frameworks -load-config= ...
```

Note we call `mxmlc.jar` through **Java directly**, not the Royale
`node_modules/.bin/mxmlc` shim — that shim throws `EINVAL` on current Node
because it `execFileSync`s a `.bat` without `shell:true`.

### Why a "bare" compile

The game was originally a plain AS3 project, **not** a Flex/MXML app. It pulls in
only three `mx.*` utility classes (`mx_internal`, `PropertyChangeEvent`,
`PropertyChangeEventKind`), which are present here as source. So the build
suppresses the default `flex-config.xml` (`-load-config=`) and links **only**
`playerglobal.swc` as an external library. Nothing from the Flex framework is
compiled in — the decompiled source is authoritative, avoiding any
framework-version drift.

## Debugging in VS Code

Open **this folder** (`decompiled/game`) in VS Code with the
[AS3 & MXML extension](https://marketplace.visualstudio.com/items?itemName=bowlerhatllc.vscode-as3mxml)
installed (it's in `.vscode/extensions.json` as a recommendation). Then press
**F5** and pick a config from `.vscode/launch.json`:

- **Build (debug) + Launch game.swf** — runs `build.bat debug` (embeds
  source-debug info via `-debug=true`), then launches
  `C:\flex\Player\flashplayer_32_sa_debug.exe`. Set breakpoints in any
  `scripts/**/*.as` file and they bind to the running SWF.
- **Launch game.swf (no rebuild)** — launches the current `bin/game.swf` as-is.
- **Attach to running Flash debug player** — attaches to an already-running debug
  player.

Breakpoints only bind against a **debug** SWF, so use a "debug" build (F5, or
`build.bat debug`) when debugging and a plain `build.bat` for release.

> **Runtime caveat.** `game.swf` is a Facebook/PlayFish networked game. Launched
> standalone it will *not* fully play — it expects container `FlashVars`, the
> sibling asset SWFs served over HTTP, and the PlayFish/Facebook backend, none of
> which exist in a bare projector. The debug player will surface uncaught runtime
> errors early. That's expected: the value here is setting breakpoints, stepping,
> and inspecting exactly where/why it stops. A full playable run would need the
> asset SWFs hosted plus a stubbed backend (the same shape as `habbo-client-cc`'s
> asset-proxy / tcp-relay setup).

## Verification

| | Original | Rebuilt |
|---|---|---|
| Document class | `com.playfish.games.cooking.Engine` | ✅ same |
| SWF size | 513,510 B | 508,542 B |
| AS3 classes (round-trip re-decompile) | 798 | ✅ 798 |
| Compiler errors | — | 0 |

The ~5 KB size delta is just a newer compiler + different zlib compression; the
class set is identical. `away3d.events.BillboardEvent` is dead code (unreachable
from `Engine`) that an application compile would strip, so it is force-included
via `-includes+=away3d.events.BillboardEvent` to keep all 798 classes.

## Stage size / frame rate (important)

`game.swf` has **no** `SetBackgroundColor`/size metadata tags of its own — the
original SWF header declares the movie as **760 × 600 @ 25 fps**, and the game
code positions its whole UI assuming a 600 px-tall stage (e.g. the "Error detail:"
box is drawn at `y = stageHeight(600) − 80 = 520`).

If you compile **without** `-default-size`, mxmlc stamps its *default* **500 × 375**
stage, so everything the game draws below y≈375 or right of x≈500 is off-screen —
the SWF looks blank even though the code is running correctly. `build.bat`
therefore sets `-default-size 760 600` and `-default-frame-rate 25` to match the
original header. Verified: rebuilt header reads `760x600 @ 25fps`.

## Decompiler fixes applied

JPEXS (FFDec) produced clean, high-level AS3 with **no `§§` P-code stubs**. Only
three spots needed hand-fixing to recompile — all documented here so the diff
from raw decompiler output is transparent:

1. **`com/facebook/data/XMLDataParser.as`** — JPEXS emitted a spurious `this.`
   before every namespace-qualified E4X access, e.g.
   `node.this.fb_namespace::uid` and `xml..this.fb_namespace::photo`. Removed the
   bogus `this.` → `node.fb_namespace::uid` / `xml..fb_namespace::photo`
   (203 occurrences).

2. **`away3d/core/utils/Cast.as`** — inside `parseMaterial()` a local
   `var color:uint` shadows the static `Cast.color()` method, so the decompiled
   unqualified `color(...)` calls resolved to the `uint` and failed. Qualified
   them as `Cast.color(...)` — matching the already-qualified `Cast.bitmap(...)`
   in the same method (11 call sites).

3. **`away3d/loaders/utils/TextureLoadQueue.as`** — the file-private helper class
   `LoaderAndRequest` (declared after the `package` block, so it does not inherit
   the package's imports) references `TextureLoader`. Added
   `import away3d.loaders.utils.TextureLoader;` to the file-private import list.

4. **`com/playfish/games/cooking/ui/CashPanel.as`** — removed a dangling
   `import com.playfish.coretech.skeleton.billing.*;` (that package exists in no
   SWF here and nothing referenced it).

## Reference artifacts

- `../game_pcode/` — the same classes exported as ActionScript **P-code**
  (assembly). Handy as ground truth if a future hand-edit needs to be compared
  against the exact original bytecode.
