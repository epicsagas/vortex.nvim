# Live Coding Setup Guide - TidalCycles & Strudel

Complete setup guide for live coding music with TidalCycles and Strudel in Neovim.

## 🎵 Overview

This configuration provides full IDE support for:
- **TidalCycles**: Haskell-based live coding for algorithmic music patterns
- **Strudel**: JavaScript/TypeScript-based live coding (inspired by TidalCycles)

Both environments support:
- Syntax highlighting
- LSP integration
- REPL integration
- Real-time pattern evaluation
- F5/F6 shortcuts for quick running

---

## 🚀 TidalCycles Setup

### Prerequisites

1. **Haskell Toolchain**
   ```bash
   # Install GHC and Cabal
   brew install ghc cabal-install  # macOS
   # or
   sudo apt install ghc cabal-install  # Linux
   ```

2. **SuperCollider**
   ```bash
   brew install supercollider  # macOS
   # or
   sudo apt install supercollider  # Linux
   ```

3. **SuperDirt (SuperCollider Quark)**
   ```bash
   # Start SuperCollider
   sclang

   # In SuperCollider, install SuperDirt
   Quarks.checkForUpdates()
   Quarks.install("SuperDirt")
   ```

4. **TidalCycles**
   ```bash
   cabal update
   cabal install tidal
   ```

5. **BootTidal.hs**

   Create `~/.ghci` or `BootTidal.hs` in your project:
   ```haskell
   :set -XOverloadedStrings
   :set prompt ""

   import Sound.Tidal.Context

   tidal <- startTidal (superdirtTarget {oLatency = 0.1, oAddress = "127.0.0.1", oPort = 57120}) (defaultConfig {cVerbose = True, cFrameTimespan = 1/20})

   let p = streamReplace tidal
   let hush = streamHush tidal
   let list = streamList tidal
   let mute = streamMute tidal
   let unmute = streamUnmute tidal
   let solo = streamSolo tidal
   let unsolo = streamUnsolo tidal
   let once = streamOnce tidal
   let asap = once
   let nudgeAll = streamNudgeAll tidal
   let all = streamAll tidal
   let resetCycles = streamResetCycles tidal
   let setcps = asap . cps
   let xfade i = transition tidal True (Sound.Tidal.Transition.xfadeIn 4) i
   let xfadeIn i t = transition tidal True (Sound.Tidal.Transition.xfadeIn t) i
   let histpan i t = transition tidal True (Sound.Tidal.Transition.histpan t) i
   let wait i t = transition tidal True (Sound.Tidal.Transition.wait t) i
   let waitT i f t = transition tidal True (Sound.Tidal.Transition.waitT f t) i
   let jump i = transition tidal True (Sound.Tidal.Transition.jump) i
   let jumpIn i t = transition tidal True (Sound.Tidal.Transition.jumpIn t) i
   let jumpIn' i t = transition tidal True (Sound.Tidal.Transition.jumpIn' t) i
   let jumpMod i t = transition tidal True (Sound.Tidal.Transition.jumpMod t) i
   let mortal i lifespan release = transition tidal True (Sound.Tidal.Transition.mortal lifespan release) i
   let interpolate i = transition tidal True (Sound.Tidal.Transition.interpolate) i
   let interpolateIn i t = transition tidal True (Sound.Tidal.Transition.interpolateIn t) i
   let clutch i = transition tidal True (Sound.Tidal.Transition.clutch) i
   let clutchIn i t = transition tidal True (Sound.Tidal.Transition.clutchIn t) i
   let anticipate i = transition tidal True (Sound.Tidal.Transition.anticipate) i
   let anticipateIn i t = transition tidal True (Sound.Tidal.Transition.anticipateIn t) i
   let forId i t = transition tidal False (Sound.Tidal.Transition.mortalOverlay t) i
   let d1 = p 1 . (|< orbit 0)
   let d2 = p 2 . (|< orbit 1)
   let d3 = p 3 . (|< orbit 2)
   let d4 = p 4 . (|< orbit 3)
   let d5 = p 5 . (|< orbit 4)
   let d6 = p 6 . (|< orbit 5)
   let d7 = p 7 . (|< orbit 6)
   let d8 = p 8 . (|< orbit 7)
   let d9 = p 9 . (|< orbit 8)

   :set prompt "tidal> "
   ```

### File Setup

Create a file with `.tidal` extension:
```bash
nvim mypattern.tidal
```

### Usage Workflow

1. **Start SuperCollider and SuperDirt**
   ```bash
   # Terminal 1: Start SuperCollider
   sclang

   # In SuperCollider
   SuperDirt.start
   ```

2. **Open TidalCycles file in Neovim**
   ```bash
   nvim mypattern.tidal
   ```

3. **Start TidalCycles REPL**
   - Press `F5` or `<Space>ts`
   - REPL will start with BootTidal.hs loaded

4. **Write and evaluate patterns**
   ```haskell
   d1 $ sound "bd sd"
   d2 $ sound "arpy*4" # speed 2
   d3 $ sound "bass3 bass3:1"
   ```

5. **Evaluate code**
   - Single line: `F6` or `<Space>tp`
   - Visual selection: Select lines, then `F6` or `<Space>tp`
   - Entire buffer: `<Space>tb`

6. **Stop patterns**
   - Stop all: `<Space>th` (hush)
   - Stop specific: `<Space>t1` (silence d1)

### Key Bindings

| Key | Action |
|-----|--------|
| `F5` | Start TidalCycles REPL |
| `F6` | Evaluate current line/selection |
| `<Space>ts` | Start REPL |
| `<Space>th` | Hush (stop all) |
| `<Space>tp` | Play line/selection |
| `<Space>tb` | Play entire buffer |
| `<Space>t1-4` | Silence d1-d4 |
| `<Space>td1-9` | Send to d1-d9 |
| `<Space>tS` | Start SuperCollider |
| `<Space>tB` | Boot SuperDirt |

### Example Patterns

```haskell
-- Basic drum pattern
d1 $ sound "bd sd bd sd"

-- With transformations
d1 $ sound "bd*4" # speed 2

-- Euclidean rhythms
d1 $ sound "bd(3,8)"

-- Multiple patterns
d1 $ sound "bd sd"
d2 $ sound "hh*8" # gain 0.8
d3 $ sound "bass3" # speed 0.5

-- Effects
d1 $ sound "arpy*4" # lpf 1000 # resonance 0.3

-- Stop all
hush
```

---

## 🎹 Strudel Setup

### Prerequisites

1. **Node.js**
   ```bash
   brew install node  # macOS
   # or
   sudo apt install nodejs npm  # Linux
   ```

2. **Strudel REPL**
   ```bash
   npm install -g @strudel.cycles/repl
   ```

3. **Optional: Web REPL**
   ```bash
   npm install -g @strudel.cycles/web
   ```

### File Setup

Create a file with `.strudel`, `.strudel.js`, or `.strudel.ts` extension:
```bash
nvim mypattern.strudel
```

Or use regular JavaScript/TypeScript files with Strudel imports.

### Usage Workflow

1. **Open Strudel file in Neovim**
   ```bash
   nvim mypattern.strudel
   ```

2. **Start Strudel REPL**
   - Press `F5` or `<Space>ss` for Node.js REPL
   - Press `<Space>sw` for web-based REPL
   - Press `<Space>so` to open web REPL in browser

3. **Write patterns**
   ```javascript
   // Basic pattern
   sound("bd sd").fast(2)

   // With effects
   sound("hh*8").gain(0.8).lpf(1000)

   // Stacking patterns
   stack(
     sound("bd sd"),
     sound("hh*8").gain(0.5)
   )
   ```

4. **Evaluate code**
   - Single line: `F6` or `<Space>sp`
   - Visual selection: Select lines, then `F6`
   - Entire buffer: `<Space>sb`

5. **Control playback**
   - Stop all: `<Space>sh` (hush)
   - Clear patterns: `<Space>sc`
   - Reset: `<Space>sr`

### Key Bindings

| Key | Action |
|-----|--------|
| `F5` | Start Strudel REPL |
| `F6` | Evaluate line/selection |
| `<Space>ss` | Start Node.js REPL |
| `<Space>sw` | Start web REPL |
| `<Space>sh` | Hush (stop all) |
| `<Space>sp` | Play line/selection |
| `<Space>sb` | Play entire buffer |
| `<Space>sc` | Clear all |
| `<Space>sr` | Reset |
| `<Space>so` | Open web REPL |
| `<Space>sH` | Open docs |

### Example Patterns

```javascript
// Basic patterns
sound("bd sd").fast(2)
sound("hh*8").gain(0.6)

// Effects
sound("arpy*4")
  .lpf(1000)
  .resonance(0.3)
  .speed(2)

// Stacking
stack(
  sound("bd sd"),
  sound("hh*4").gain(0.5),
  sound("bass3").speed(0.5)
)

// Euclidean rhythms
sound("bd(3,8)")

// Using mini notation (TidalCycles style)
note("c3 e3 g3 c4")
  .s("piano")
  .fast(2)

// Stop all
hush()
```

### Web REPL Features

The web-based REPL provides:
- Visual pattern editor
- Real-time waveform display
- Pattern visualization
- Built-in examples
- Shareable patterns

Access it via:
- `<Space>so` in Neovim
- Direct URL: https://strudel.tidalcycles.org/

---

## 🎼 Common Workflows

### Live Performance Setup

1. Start audio backend (SuperCollider for Tidal, or browser for Strudel)
2. Open multiple pattern files in splits:
   ```vim
   :split drums.tidal
   :vsplit melody.tidal
   ```
3. Evaluate patterns from different buffers
4. Use `hush` to stop all when transitioning

### Composing and Saving

1. Write patterns in files
2. Save frequently (`<Space>w`)
3. Version control with Git
4. Share patterns as code

### Tips for Both Environments

**TidalCycles:**
- Use `d1`-`d9` for different pattern layers
- `hush` stops everything
- `solo` isolates specific patterns
- Transitions: `xfade`, `jump`, `anticipate`

**Strudel:**
- Chain methods for complex patterns
- Use `stack()` for layers
- `hush()` stops everything
- Browser REPL for visual feedback

---

## 🔧 Troubleshooting

### TidalCycles Issues

**REPL won't start:**
```bash
# Check GHC installation
ghc --version

# Check Cabal
cabal --version

# Reinstall TidalCycles
cabal update
cabal install tidal --overwrite-policy=always
```

**SuperCollider connection error:**
```bash
# Restart SuperCollider
killall sclang scsynth
sclang
# Then in SuperCollider:
SuperDirt.start
```

**BootTidal.hs not found:**
```bash
# Create in project directory or ~/.ghci
cp /path/to/BootTidal.hs ~/.ghci
```

### Strudel Issues

**REPL not found:**
```bash
# Install globally
npm install -g @strudel.cycles/repl

# Check installation
npx @strudel.cycles/repl --version
```

**Audio not playing:**
- Check browser permissions for audio
- Ensure Web Audio API is enabled
- Try different browser (Chrome/Firefox recommended)

**Import errors:**
```bash
# Install Strudel locally in project
npm install @strudel.cycles/core @strudel.cycles/webaudio
```

---

## 📚 Resources

### TidalCycles
- Official Site: https://tidalcycles.org/
- Documentation: https://tidalcycles.org/docs/
- Community: https://club.tidalcycles.org/
- YouTube Tutorials: https://www.youtube.com/@tidalcycles

### Strudel
- Official Site: https://strudel.tidalcycles.org/
- Documentation: https://strudel.tidalcycles.org/learn/
- Web REPL: https://strudel.tidalcycles.org/
- GitHub: https://github.com/tidalcycles/strudel

### Learning Resources
- **Algorave**: https://algorave.com/
- **Toplap**: https://toplap.org/ (Live coding community)
- **TidalCycles Workshop**: https://github.com/yaxu/workshop
- **Strudel Tutorial**: https://strudel.tidalcycles.org/learn/getting-started/

---

## 🎯 Next Steps

1. Complete the setup for your chosen environment
2. Try the example patterns
3. Experiment with the keybindings
4. Join the community forums
5. Share your patterns!

Happy live coding! 🎵✨
