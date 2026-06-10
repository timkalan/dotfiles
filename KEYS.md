# Keyboard layout

General outline of my keyboard layout(s). I use multiple boards with varying
key counts, all being split:

- Corne 42 key (the base of the layout)
- Silakka54 54 key (Corne + number row)
- Libra mini (Alice layout, roughly the same # of keys as Corne)
- Scylla mk2 (Dactyl style, build in progress)

The base layout is designed for the smallest among these - the Corne:

- 3 thumb keys per thumb
- 3 rows
- 6 columns of keys per side

## Design principles

- Layer 0 is standard QWERTY. Familiar punctuation stays in place (`, . / ; '`).
- Layer 1 has all 32 symbols except `,` (left on L0), no numbers. Optimized for
  TS/Go/Rust digraphs as inward rolls.
- Layer 2 has numbers, navigation, F-keys, and media. Pure utility, nothing you
  type in code.
- `;` `'` `.` `/` keep their base positions on the symbol layer for muscle
  memory. `[ ]` slot in next to `( )` `{ }` on the index/middle pair, pushing
  `,` off the layer (it stays on L0).
- Space on the right thumb (offload from the busier left hand on QWERTY).
- Either thumb activates a layer; single symbols are typed cross-hand.

## Layer 0 — Base QWERTY

```
[      Q      W      E      R      T          Y      U      I      O      P      ]
ESC    A/ALT  S/GUI  D/CTL  F/SFT  G          H      J/SFT  K/CTL  L/GUI  ;/ALT  '
LSFT   Z      X      C      V      B          N      M      ,      .      /      RSFT
                     CAPS   TAB/L2 ENT/L1     SPC/L1 BSP/L2 CAPS_W
```

Standard QWERTY with home row mods. Pinky to index: Alt, GUI, Ctrl, Shift
(AGCS — GUI on ring instead of pinky so Cmd lands on a stronger finger on Mac).
Subject to change.

`[` `]` in the top corners. Caps Lock on left bottom. Caps Word on right bottom.
I use the Caps on thumbs because the inner keys are uncomfortable for me to reach.

## Layer 1 — Symbols

```
___    ~      |      #      _      \          `      }      {      @      $      ___
!      <      -      =      >      &          :      (      )      "      ;      '
___    ^      +      ?      *      ___        %      [      ]      .      /      ___
                            GUI    CTL        CTL    GUI
```

All 32 symbols except `,` (which stays on L0), no numbers — built so common
TS/Go/Rust digraphs fall out as inward rolls. Either thumb activates the layer;
single symbols are typed cross-hand.

### Left hand — operators and comparisons

Home row reads `! < - = > &` (outer-pinky through inner-index), arranged so every
comparison/arrow/compound-op bigram is an inward roll except `>=`:

- `<-` pinky→ring, inward adjacent
- `->` ring→index, inward skip-middle
- `<=` pinky→middle, inward skip-ring
- `-=` ring→middle, inward adjacent
- `=>` middle→index, inward adjacent
- `!=` outer-pinky→middle, long inward
- `+=` ring-bot→middle-home, diagonal inward
- `*=` index-bot→middle-home, cross-finger outward — best achievable; a truly
  inward `*=` would need `=` on the index, sacrificing `=>`
- `>=` the one unavoidable outward roll, accepted since `=>` is far more common
  in TS

`!` takes the outer-pinky home as a single-character cost, keeping `<`, `-`, `>`
on stronger fingers for the rolls. `&` sits on the index inner stretch (`&&` is a
key repeat). `?` is on the left-middle bottom so `?:` reaches cross-hand to the
right `:` instead of an SFB — `)?` (Rust try-after-call) also alternates cleanly.
`*` is on the index bottom, off the middle column, so `*=` stays cross-finger;
`\` takes the left inner-index top.

### Right hand — brackets and punctuation

`( ) { } [ ]` are paired on cols 8–9 (open on index, close on middle) and stacked
across the three rows, with `{ }` flipped (`}` on index top, `{` on middle top).
`{ }` is the one pair worth flipping:

- Flipping `( )` would break the `();` outward sweep on the right home row. Bad
  trade.
- Flipping `[ ]` leaves the very common `})` SFB unfixed.
- Flipping `{ }` kills `})`, `({`, `]}`, `[{` in one move. Residual SFBs are `])`
  and `[(`, both single-row on less-common bigrams (combos are the eventual
  fix — see Possible tweaks).

`:` is on the right inner-index home for fast `::` (Rust) and `:=` (Go,
cross-hand to the left `=`); `"` and `;` keep prime home positions for strings
and statement terminators. `${` is a pinky-top → middle-top inward roll (template
strings).

Punctuation `; ' . /` keep their L0 columns for muscle memory. `[ ]` take cols
8–9, which pushes `,` off the layer — type it on L0. `` ` `` and `%` sit on the
right inner-index column (top and bottom), moved off the outer-pinky corners (the
worst reaches on the board); only `!` and `'` remain on the outer pinky.

### Rejected alternatives

- **Flip `( )` or `[ ]` instead of `{ }`** — each leaves a worse SFB (`();` sweep
  broken, or `})` unfixed).
- **Shift `, . /` one column outward to pair the brackets** — landed `/` on the
  outer-pinky bottom. Reverted: `. /` keep their L0 columns and `,` drops off L1.
- **`` ` `` / `%` on the outer-pinky corners** — the original spot; relocated to
  the inner-index column once the corner reaches proved too costly.
- **Drop `[ ]` from L1 entirely** (type via L0 corners) — kept on L1 for the
  bracket mnemonic instead, accepting the `])`/`[(` residuals.

## Layer 2 — Navigation

```
BOOT   1      2      3      4      5          6      7      8      9      0      VOL+
PLAY   HOME   PGUP   PGDN   END    ___        LEFT   DOWN   UP     RIGHT  DEL    VOL-
F12    F1     F2     F3     F4     F5         F6     F7     F8     F9     F10    F11
                                   LSFT       RSFT
```

- Numbers on top (standard 1-5 / 6-0 split).
- Arrows on right home in vim HJKL positions.
- Home/End/PgUp/PgDn on left home row.
- F1-F12 complete on bottom row.
- QK_BOOT top-left corner — deliberate reach to avoid accidents.

## Quirks

Some of my boards have more keys, their modifications might appear here someday.

For typing slovenian, I switch layout to slovene and do mental gymnastics to
"translate" the desired keys. Also, I put `šđčćž` on a layer in a position
similar to where they would be on a regular keyboard.

## Possible tweaks (later)

Out of scope for the current symbol-layer optimization, but worth considering
down the line:

- **Combos for `[ ]`** — Urob/T-34 style. Two-key chord on the symbol layer (or
  even on base) for `[` and `]`. Frees the L0 corners and avoids the cross-layer
  cost when typing `])` and `]}`. Requires combo timing tuning.
- **L0 `[ ]` corner placement** — currently on pinky outer stretches, which are
  the worst reaches on the board. If combos are added, the corners can host
  better keys or stay as redundant fallback.
- **`}` `])` residual SFBs** — fully eliminating these would require either
  combos or a non-mnemonic bracket layout. Acceptable for now.
- **F11 / F12 wrap on nav layer** — F12 in the outer-left corner and F11 in the
  outer-right breaks the F1–F11 sequence visually. Minor cleanup if it ever
  bothers me.
- **HRM timing** — worth tuning via urob's writeup if same-hand rolls on home
  row start misfiring as mods.
- **Slovenian characters** — formalize the layer placement of `šđčćž` instead
  of leaving it as a separate OS-level layout switch.
- **Colemak-DH base** — the residual ergonomic ceiling. Major retraining
  investment, only consider after the symbol layer is fully dialed in.
