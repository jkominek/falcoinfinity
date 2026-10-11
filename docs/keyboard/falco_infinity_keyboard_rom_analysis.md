# Falco Infinity / Minotaur O731 — keyboard firmware analysis

## Scope and conclusion

The supplied `921104_000.rom` and `921104_001.rom` are the GC Services/O731 ROM pair. The CPU has a fixed 32 KiB ROM at 0000–7FFF, a 16 KiB bank window at 8000–BFFF, and RAM at C000–DFFF. The keyboard decoder uses Falco-specific scan codes but XT-like **make=code, break=code|80h** framing; it does **not** use IBM PC/XT scan-code numbering. The Falco table consists of **123 records of 3 bytes each**, indexed by an unsigned scan code 00h–7Ah. The code copies this ROM table to RAM before processing events.

The CSV in this bundle contains every table entry, including entries whose physical legends are not yet recovered. The `key_name` field is empty where only an internal event code can currently be assigned. The file is an exhaustive *ROM code-to-internal-event mapping*, not proof of every individual physical keycap legend on this particular keyboard revision. It also does not represent all terminal-personality overrides, described below.

## ROM banking and offsets

* `ROM0` physical 8000–FFFF => Z80 fixed CPU 0000–7FFF.
* `ROM0` physical 4000–7FFF => bank 1, CPU 8000–BFFF.
* `ROM1` physical 0000–3FFF => bank 2, CPU 8000–BFFF.
* Main Falco layout header: **bank 1 CPU 9351h / ROM0 physical 5351h**.
* Main Falco layout records: **bank 1 CPU 9358h / ROM0 physical 5358h**, 7Bh entries, 3 bytes/entry; final is scan 7Ah, physical ROM offset 54C6h.
* PC/XT layout header: **bank 1 CPU 9548h / ROM0 physical 5548h**.
* PC/XT layout records: **bank 1 CPU 954Fh / ROM0 physical 554Fh**, 68h entries (00h–67h), 3 bytes/entry.
* Alternate 25-record patch for Falco function-row codes 01h–19h: **bank 1 CPU 94C9h / ROM0 physical 54C9h**.

The ROM0 physical 5351h header bytes are `43 44 34 93 34 93 7B`. The first two bytes (`43`, `44`) correspond to left Ctrl and Caps Lock on this keyboard; the two 16-bit words `9334` are additional keyboard-layout pointers. The final byte `7B` is the copy count. The PC header bytes are `1D 3A 14 95 2D 95 68`: XT Ctrl=`1D`, Caps=`3A`, alternative pointers `9514` and `952D`, count=`68`.

## The handler's data flow

The central handling routines can be followed in the companion annotated disassembly:

1. The keyboard input path reads **I/O port 50h** (`IN A,(50h)` at bank 2 CPU 8080h) and acknowledges via `OUT (5Bh),40h`. This routes the keyboard data via the board's video ASIC register block, not necessarily through the Z80 SIO. Initialization also uses ports 58h/59h.
2. Bank 2, CPU `8099h` processes a received byte. It saves the raw byte at `C012h`, masks `AND 7Fh` to obtain the scan index, checks the upper range limit, and calls the lookup routine.
3. Fixed ROM `4102h` computes `HL = C74Ch + 3 * scan`. This is an exact instruction-level match to the ROM triplet table.
4. The selected entry contains three internal tokens: normal, shifted, and control/alternate. Selection takes place at bank 2 CPU `80B7h`–`80DEh` using modifier state in `C00Fh` and additional configuration. Shift selects the second token; a control/alternate condition selects the third; Caps Lock and emulation state also influence selection.
5. For printable keys, the third token is commonly `FFh`. In that case, bank 2 CPU `8166h`–`8176h` falls back to the appropriate normal/shifted token and computes `token & 1Fh`, implementing ASCII control combinations (e.g., Ctrl+A -> 01h).
6. When bit 7 of the *raw input* is set (`BIT 7,A` at CPU `80E2h`), the path handles a **break** event, including modifier release/state tracking. This matches the scope observation that X uses 5Ch for press, DCh for release.
7. The resulting internal event is submitted via fixed ROM `1CA5h` to a queue, then consumed by higher-level terminal/personality-specific logic.

This is a **key identity -> internal event -> terminal personality/output** pipeline, not an ASCII keyboard output protocol.

## Initialization and mutable mappings

At bank 1 `80C2h`, setup checks bit 3 of the keyboard type, choosing the Falco `9351h` table or the PC `9548h` table. The code copies the six-byte header to `C038h`; loads the one-byte entry count to `C03Eh` (count+1); copies 3*count ROM bytes into RAM at `C74Ch`; and conditionally overlays records using compact patches. A 25-entry table at `94C9h` is copied over records **01h–19h** when configuration (`C04Ch` bit 7, Falco-ANSI branch) enables it. Further records are replaced from terminal-personality-specific mapping data (the ROM structure referenced from `A1B5h` and pointers in its entries).

**Therefore the base table is complete but is not universally the active table**. Function-key behavior and special-key outputs can vary with keyboard mode, selected terminal personality, and setup configuration. We have not emulated all personalities and NVRAM options in this analysis.

## Table layout and measured landmarks

There is an exact 21-code stride across the observed main rows:

| Positional region | Scan codes | Anchors |
|---|---|---|
| Number-region | 1Ah–2Eh | `=1Ah, 1=1Bh, 9=23h, Escape=2Eh |
| QWERTY-region | 2Fh–43h | Tab=2Fh, Q=30h, left Ctrl=43h |
| Home-region | 44h–58h | Caps=44h, A=45h, K=4Ch, keypad comma=57h |
| Bottom-region | 59h–6Dh | Left Shift=59h, X=5Ch |

These groups reflect firmware code order. They need not be literal switch-matrix rows: Escape and left Ctrl occupy unexpected code-row endpoints. Additional codes **00h–19h** and **6Eh–7Ah** cover special/function keys and additional physical positions. Do not infer the actual PCB matrix wiring from the table alone.

The following internal special-event identities are independently supported by the PC/XT alternative table, which assigns identical internal triplets to familiar XT keys:

| Falco scan | Identified key | Base triple |
|---|---|---|
| 01h / 02h | F1 / F2 | BA BA F3 / BB BB 92 |
| 04h–06h, 08h–11h, 13h | F3–F15 (some skipped positions), F16 | Function sequence BC..C9, with distinct control tokens |
| 2Eh | Escape | 99 9A 86 |
| 2Fh | Tab | E9 EA 86 |
| 3Ch | Return / Enter | E3 E3 0D |
| 43h | Left Ctrl | 80 80 80 |
| 44h | Caps Lock | 87 87 9C |
| 59h | Left Shift | 82 82 82 |
| 65h | Right Shift | 83 83 83 |
| 6Eh | Alt | 84 84 84 |
| 6Fh | Space | 20 20 FF |

A few labels remain **inferred**, not individually captured on the scope (e.g., right Shift, Alt, function-key legends); the CSV records their provenance. Keypad comma is directly measured at scan 57h, but its default triple **A0 A0 86** is an internal special token, not literal ASCII comma. Its precise terminal action depends on subsequent interpretation.

## Limits

1. The internal tokens `80h`–`FEh` (including many function, navigation, editing, and keypad actions) cannot all be named unambiguously merely by reading the base table. The three-byte records are fully extracted; higher-level token meanings differ with personality and may require additional decompilation or a terminal keyboard photo/manual.
2. The main Falco keyboard header and the PC/XT header are both fully identified, but dynamic modifications mean there is no single unconditional event-to-output table.
3. This is static disassembly and data-flow analysis of the **keyboard subsystem**, not a complete decompilation of every function in both ROMs.
4. The measured clock framing and electrical timing are observations from the user; the ROM analysis independently confirms that make and break events differ by bit 7 of the byte reaching the decoder.

## SHA-256 provenance

```
ROM0: c9c69d23b20f4f85881ba2c9dab53024ecf6297154fd86c14e4ec46c4c1fa909
ROM1: 347094df711cc42649787c06b87018fce9270ac5672e3cbbbd6920911a38ab8e
```
