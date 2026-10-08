# ForthVT100

ForthVT100 is a presentation vocabulary for beautiful scrolling terminal
output. It provides ANSI/VT100 styling, transient status, semantic messages,
headings, panels, fields, progress displays, trees, bars, and streaming tables
while preserving clean text when stdout is redirected.

It is deliberately not a full-screen user-interface framework. Menus, windows,
dashboards, and screen ownership belong in applications such as an image
viewer, not in command-oriented Forth modules.

## Presentation modes

The package detects the VFX standard handles when loaded:

- terminal stdout enables colour, style, cursor control, and transient output;
- redirected stdout emits plain linear text without escape sequences;
- terminal stdin permits interactive cancellation;
- redirected stdin is never polled or flushed by presentation words.

Application code does not branch on the mode. These words are available for
tests and unusual embedding:

```forth
AUTO-PRESENTATION
TERMINAL-PRESENTATION
PLAIN-PRESENTATION
```

`AUTO-PRESENTATION` restores the mode detected from the process handles.
`CLS` remains available for interactive presentation and is a complete no-op
when stdout is redirected.

## Ordinary and filtered output

Ordinary Forth output remains appropriate:

```forth
." Unfiltered text" cr
```

The filtered output family supplies complete logical lines:

```forth
s" Camera connected" .>
s" SDK returned an error" .E>
s" Raw mount reply" .D>
```

`.E>` and `.D>` retain textual `[ERROR]` and `[DEBUG]` markers when colour is
unavailable. Reporting levels are:

```forth
DIAGNOSTICS
STANDARD-OUTPUT
JUST-ERRORS
SILENT-RUNNING
```

## Transient status

`...>` creates or replaces one transient terminal line:

```forth
s" Exposing" ...>
s" Downloading" ...>
-...
```

`-...` erases an active status. Durable presentation words call it
automatically before printing. Both words are silent under redirection.

Numeric transient displays are also available:

```forth
42 100 .progress
s" Plate solving" 3 .spinner
```

`.countdown` shows a cancellable terminal countdown. When input or output is
redirected it waits silently and never inspects command input.

## Presentation components

```forth
s" Observatory session" .title
s" Connected equipment" .section
s" Important observing note" .emphasis
s" Long prose constrained to the presentation width." .wrap
s" Nested explanation" 2 .indent
s" Camera ready" .OK>
s" Refocus recommended" .W>
s" Capture preview" .bullet
s" Wheel at LUM" 1 .branch
s" Continue observing" .Q>
```

Panels group related fields:

```forth
s" Camera" panel{
s" Model"       s" ASI2600MM Pro" .field
s" Temperature" s" -10.2 C"       .field
}panel
```

Stable bars are useful for histograms and measured proportions:

```forth
54 100 36 .bar
```

`presentation.width` controls rules and panels. `field.width` controls the
label column used by `.field`.

## Streaming tables

Tables accept ordinary Forth output inside each cell. They use padding rather
than cursor positioning, so the same definition produces box drawing on a
terminal and a clean ASCII table when redirected.

```forth
0 14 1 table
row |h s" Filter" LJ. |h s" Exposure" LJ.
row |r |r
row |t s" LUM" LJ.    |t s" 60 s" RJ.
row |t s" RED" LJ.    |t s" 120 s" RJ.
row |f |f
}table
```

The arguments to `table` are left margin, cell width, and cell text margin.
Cell tags are:

| Tag | Purpose |
| --- | --- |
| `|h` | Heading or top-border cell |
| `|t` | Text cell |
| `|l` | Intermediate rule cell |
| `|r` | Heading ruler cell |
| `|f` | Footer cell |
| `|b` | Borderless cell |

`LJ.`, `CJ.`, and `RJ.` display strings left-, centre-, and right-justified.
Ordinary words such as `.`, `type`, and `."` may also be used directly.

## Low-level VT100 vocabulary

`ForthVT100.f` retains direct controls including:

```forth
vt.bold       vt.faint      vt.underline
vt.red        vt.green      vt.cyan
vt.reset      vt.column     vt.move
vt.erase_line vt.cursor_off vt.cursor_on
```

These controls automatically become no-ops when stdout is redirected. Control
sequences preserve Forth's logical `out` column, allowing layout code to use
ordinary sequential output safely.

## Showcase

Run the astronomy-oriented presentation gallery from this repository:

```powershell
& 'E:\Coding\VFXForth\Bin\VFXterm.exe' `
  '.\examples\AstroImagingShowcase.f'
```

It demonstrates equipment panels, observing hierarchy, transient solving
status, progress, a filter plan, semantic messages, and a preview histogram.
It returns to the Forth prompt so the presentation remains visible. For a
bounded run which exits after the showcase, use:

```powershell
& 'E:\Coding\VFXForth\Bin\VFXterm.exe' `
  '.\examples\RunAstroImagingShowcase.f'
```

Redirecting either command produces the plain representation.

## Tests

Run the standalone test suite:

```powershell
.\tests\Test-Presentation.ps1
```

The tests verify:

- redirected output contains no ANSI escape characters;
- transient status does not leak into redirected output;
- errors and diagnostics retain textual severity;
- panels and tables retain their structure;
- forced terminal rendering emits ANSI control;
- redirected countdown does not consume command input.

The repository `startup.f` loads the shared Forth library registry so examples
and tests can run independently of AstroImagingInForth.
