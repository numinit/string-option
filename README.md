# string-option

A cursed way to pass arbitrary string options to flakes. Inspired by
[Command Line Flake Arguments](https://www.mat.services/posts/command-line-flake-arguments/).

The options are extracted in ascending lexicographic order using
[builtins.attrNames](https://nixos.org/manual/nix/stable/language/builtins.html#builtins-attrNames).
You are responsible for naming them so they behave.

## Example flake.nix

```nix
{
  inputs = {
    # For the library used to decode this terrible mess
    string-option.url = "github:numinit/string-option";

    # Pad to the maximum allowable length of your string.
    option_00.url = "github:numinit/string-option";
    option_01.url = "github:numinit/string-option";
    option_02.url = "github:numinit/string-option";
    option_03.url = "github:numinit/string-option";
    option_04.url = "github:numinit/string-option";
    option_05.url = "github:numinit/string-option";
    option_06.url = "github:numinit/string-option";
    option_07.url = "github:numinit/string-option";
    option_08.url = "github:numinit/string-option";
    option_09.url = "github:numinit/string-option";
    option_10.url = "github:numinit/string-option";
    option_11.url = "github:numinit/string-option";
    option_12.url = "github:numinit/string-option";
    option_13.url = "github:numinit/string-option";
    option_14.url = "github:numinit/string-option";
    option_15.url = "github:numinit/string-option";
  };

  outputs = { self, string-option, ... }@args: {
    # First argument is the prefix, second is all your arguments.
    value = string-option.extract "option_" args;
  };
}
```

## Running it

This repository includes at least one branch for every character in the
printable ASCII character set exporting a single-character string as the flake
output "value". The master branch returns an empty string.

Characters matching `/[A-Za-z0-9_]/` are considered safe to include
in a flake URL and have their own branches. Decimal and hex versions
(lowercase; prefixed with `0x`) are included too.

So, to pass "Hello world!" to a flake that depends on this one,
you'd do something like the following:

```bash
nix eval \
    --override-input option_00 github:numinit/string-option/H \
    --override-input option_01 github:numinit/string-option/e \
    --override-input option_02 github:numinit/string-option/l \
    --override-input option_03 github:numinit/string-option/l \
    --override-input option_04 github:numinit/string-option/o \
    --override-input option_05 github:numinit/string-option/32 \
    --override-input option_06 github:numinit/string-option/w \
    --override-input option_07 github:numinit/string-option/o \
    --override-input option_08 github:numinit/string-option/r \
    --override-input option_09 github:numinit/string-option/l \
    --override-input option_10 github:numinit/string-option/d \
    --override-input option_11 github:numinit/string-option/33 \
    --raw \
    .#value
```

This has the added benefit of being roughly 58x
[less efficient](https://www.youtube.com/watch?v=kHW58D-_O64) to write out
than just "Hello world!"

Another example with home-manager in [numinit/dotfiles](https://github.com/numinit/dotfiles)
that passes the current username into the flake for the purpose of
setting up home-manager:

```nix
  dotfiles = pkgs.writeShellScriptBin "dotfiles.sh" ''
    config="$1"
    if [ -z "$config" ]; then
        config=".#workstation"
    fi

    set -euo pipefail
    username="$(whoami)"
    username="''${username:0:16}"

    extra_args=()
    for ((i=0;i<''${#username};i++)); do
        char="''${username:i:1}"
        extra_args+=(
            --override-input
            "username_$(printf '%02d' "$i")"
            "github:numinit/string-option/$(printf '%d' "'$char")"
        )
    done

    cd "${self}" && exec ${
      home-manager.packages.${system}.default
    }/bin/home-manager switch \
        --flake "''${config}" \
        ''${extra_args[@]+"''${extra_args[@]}"}
  '';
```

## List of all the branches

In case you actually wanted to use this for some reason.

| Character | Plain                            | Decimal                            | Hex                                 |
| :-------- | :------------------------------- | :--------------------------------- | :---------------------------------- | ----------------------------------- |
| `"\t"`    |                                  | `github:numinit/string-option/9`   | `github:numinit/string-option/0x09` |
| `"\n"`    |                                  | `github:numinit/string-option/10`  | `github:numinit/string-option/0x0a` |
| `"\r"`    |                                  | `github:numinit/string-option/13`  | `github:numinit/string-option/0x0d` |
| `" "`     |                                  | `github:numinit/string-option/32`  | `github:numinit/string-option/0x20` |
| `"!"`     |                                  | `github:numinit/string-option/33`  | `github:numinit/string-option/0x21` |
| `"\""`    |                                  | `github:numinit/string-option/34`  | `github:numinit/string-option/0x22` |
| `"#"`     |                                  | `github:numinit/string-option/35`  | `github:numinit/string-option/0x23` |
| `"$"`     |                                  | `github:numinit/string-option/36`  | `github:numinit/string-option/0x24` |
| `"%"`     |                                  | `github:numinit/string-option/37`  | `github:numinit/string-option/0x25` |
| `"&"`     |                                  | `github:numinit/string-option/38`  | `github:numinit/string-option/0x26` |
| `"'"`     |                                  | `github:numinit/string-option/39`  | `github:numinit/string-option/0x27` |
| `"("`     |                                  | `github:numinit/string-option/40`  | `github:numinit/string-option/0x28` |
| `")"`     |                                  | `github:numinit/string-option/41`  | `github:numinit/string-option/0x29` |
| `"*"`     |                                  | `github:numinit/string-option/42`  | `github:numinit/string-option/0x2a` |
| `"+"`     |                                  | `github:numinit/string-option/43`  | `github:numinit/string-option/0x2b` |
| `","`     |                                  | `github:numinit/string-option/44`  | `github:numinit/string-option/0x2c` |
| `"-"`     |                                  | `github:numinit/string-option/45`  | `github:numinit/string-option/0x2d` |
| `"."`     |                                  | `github:numinit/string-option/46`  | `github:numinit/string-option/0x2e` |
| `"/"`     |                                  | `github:numinit/string-option/47`  | `github:numinit/string-option/0x2f` |
| `"0"`     | `github:numinit/string-option/0` | `github:numinit/string-option/48`  | `github:numinit/string-option/0x30` |
| `"1"`     | `github:numinit/string-option/1` | `github:numinit/string-option/49`  | `github:numinit/string-option/0x31` |
| `"2"`     | `github:numinit/string-option/2` | `github:numinit/string-option/50`  | `github:numinit/string-option/0x32` |
| `"3"`     | `github:numinit/string-option/3` | `github:numinit/string-option/51`  | `github:numinit/string-option/0x33` |
| `"4"`     | `github:numinit/string-option/4` | `github:numinit/string-option/52`  | `github:numinit/string-option/0x34` |
| `"5"`     | `github:numinit/string-option/5` | `github:numinit/string-option/53`  | `github:numinit/string-option/0x35` |
| `"6"`     | `github:numinit/string-option/6` | `github:numinit/string-option/54`  | `github:numinit/string-option/0x36` |
| `"7"`     | `github:numinit/string-option/7` | `github:numinit/string-option/55`  | `github:numinit/string-option/0x37` |
| `"8"`     | `github:numinit/string-option/8` | `github:numinit/string-option/56`  | `github:numinit/string-option/0x38` |
| `"9"`     | `github:numinit/string-option/9` | `github:numinit/string-option/57`  | `github:numinit/string-option/0x39` |
| `":"`     |                                  | `github:numinit/string-option/58`  | `github:numinit/string-option/0x3a` |
| `";"`     |                                  | `github:numinit/string-option/59`  | `github:numinit/string-option/0x3b` |
| `"<"`     |                                  | `github:numinit/string-option/60`  | `github:numinit/string-option/0x3c` |
| `"="`     |                                  | `github:numinit/string-option/61`  | `github:numinit/string-option/0x3d` |
| `">"`     |                                  | `github:numinit/string-option/62`  | `github:numinit/string-option/0x3e` |
| `"?"`     |                                  | `github:numinit/string-option/63`  | `github:numinit/string-option/0x3f` |
| `"@"`     |                                  | `github:numinit/string-option/64`  | `github:numinit/string-option/0x40` |
| `"A"`     | `github:numinit/string-option/A` | `github:numinit/string-option/65`  | `github:numinit/string-option/0x41` |
| `"B"`     | `github:numinit/string-option/B` | `github:numinit/string-option/66`  | `github:numinit/string-option/0x42` |
| `"C"`     | `github:numinit/string-option/C` | `github:numinit/string-option/67`  | `github:numinit/string-option/0x43` |
| `"D"`     | `github:numinit/string-option/D` | `github:numinit/string-option/68`  | `github:numinit/string-option/0x44` |
| `"E"`     | `github:numinit/string-option/E` | `github:numinit/string-option/69`  | `github:numinit/string-option/0x45` |
| `"F"`     | `github:numinit/string-option/F` | `github:numinit/string-option/70`  | `github:numinit/string-option/0x46` |
| `"G"`     | `github:numinit/string-option/G` | `github:numinit/string-option/71`  | `github:numinit/string-option/0x47` |
| `"H"`     | `github:numinit/string-option/H` | `github:numinit/string-option/72`  | `github:numinit/string-option/0x48` |
| `"I"`     | `github:numinit/string-option/I` | `github:numinit/string-option/73`  | `github:numinit/string-option/0x49` |
| `"J"`     | `github:numinit/string-option/J` | `github:numinit/string-option/74`  | `github:numinit/string-option/0x4a` |
| `"K"`     | `github:numinit/string-option/K` | `github:numinit/string-option/75`  | `github:numinit/string-option/0x4b` |
| `"L"`     | `github:numinit/string-option/L` | `github:numinit/string-option/76`  | `github:numinit/string-option/0x4c` |
| `"M"`     | `github:numinit/string-option/M` | `github:numinit/string-option/77`  | `github:numinit/string-option/0x4d` |
| `"N"`     | `github:numinit/string-option/N` | `github:numinit/string-option/78`  | `github:numinit/string-option/0x4e` |
| `"O"`     | `github:numinit/string-option/O` | `github:numinit/string-option/79`  | `github:numinit/string-option/0x4f` |
| `"P"`     | `github:numinit/string-option/P` | `github:numinit/string-option/80`  | `github:numinit/string-option/0x50` |
| `"Q"`     | `github:numinit/string-option/Q` | `github:numinit/string-option/81`  | `github:numinit/string-option/0x51` |
| `"R"`     | `github:numinit/string-option/R` | `github:numinit/string-option/82`  | `github:numinit/string-option/0x52` |
| `"S"`     | `github:numinit/string-option/S` | `github:numinit/string-option/83`  | `github:numinit/string-option/0x53` |
| `"T"`     | `github:numinit/string-option/T` | `github:numinit/string-option/84`  | `github:numinit/string-option/0x54` |
| `"U"`     | `github:numinit/string-option/U` | `github:numinit/string-option/85`  | `github:numinit/string-option/0x55` |
| `"V"`     | `github:numinit/string-option/V` | `github:numinit/string-option/86`  | `github:numinit/string-option/0x56` |
| `"W"`     | `github:numinit/string-option/W` | `github:numinit/string-option/87`  | `github:numinit/string-option/0x57` |
| `"X"`     | `github:numinit/string-option/X` | `github:numinit/string-option/88`  | `github:numinit/string-option/0x58` |
| `"Y"`     | `github:numinit/string-option/Y` | `github:numinit/string-option/89`  | `github:numinit/string-option/0x59` |
| `"Z"`     | `github:numinit/string-option/Z` | `github:numinit/string-option/90`  | `github:numinit/string-option/0x5a` |
| `"["`     |                                  | `github:numinit/string-option/91`  | `github:numinit/string-option/0x5b` |
| `"\\"`    |                                  | `github:numinit/string-option/92`  | `github:numinit/string-option/0x5c` |
| `"]"`     |                                  | `github:numinit/string-option/93`  | `github:numinit/string-option/0x5d` |
| `"^"`     |                                  | `github:numinit/string-option/94`  | `github:numinit/string-option/0x5e` |
| `"_"`     | `github:numinit/string-option/_` | `github:numinit/string-option/95`  | `github:numinit/string-option/0x5f` |
| `"""`     |                                  | `github:numinit/string-option/96`  | `github:numinit/string-option/0x60` |
| `"a"`     | `github:numinit/string-option/a` | `github:numinit/string-option/97`  | `github:numinit/string-option/0x61` |
| `"b"`     | `github:numinit/string-option/b` | `github:numinit/string-option/98`  | `github:numinit/string-option/0x62` |
| `"c"`     | `github:numinit/string-option/c` | `github:numinit/string-option/99`  | `github:numinit/string-option/0x63` |
| `"d"`     | `github:numinit/string-option/d` | `github:numinit/string-option/100` | `github:numinit/string-option/0x64` |
| `"e"`     | `github:numinit/string-option/e` | `github:numinit/string-option/101` | `github:numinit/string-option/0x65` |
| `"f"`     | `github:numinit/string-option/f` | `github:numinit/string-option/102` | `github:numinit/string-option/0x66` |
| `"g"`     | `github:numinit/string-option/g` | `github:numinit/string-option/103` | `github:numinit/string-option/0x67` |
| `"h"`     | `github:numinit/string-option/h` | `github:numinit/string-option/104` | `github:numinit/string-option/0x68` |
| `"i"`     | `github:numinit/string-option/i` | `github:numinit/string-option/105` | `github:numinit/string-option/0x69` |
| `"j"`     | `github:numinit/string-option/j` | `github:numinit/string-option/106` | `github:numinit/string-option/0x6a` |
| `"k"`     | `github:numinit/string-option/k` | `github:numinit/string-option/107` | `github:numinit/string-option/0x6b` |
| `"l"`     | `github:numinit/string-option/l` | `github:numinit/string-option/108` | `github:numinit/string-option/0x6c` |
| `"m"`     | `github:numinit/string-option/m` | `github:numinit/string-option/109` | `github:numinit/string-option/0x6d` |
| `"n"`     | `github:numinit/string-option/n` | `github:numinit/string-option/110` | `github:numinit/string-option/0x6e` |
| `"o"`     | `github:numinit/string-option/o` | `github:numinit/string-option/111` | `github:numinit/string-option/0x6f` |
| `"p"`     | `github:numinit/string-option/p` | `github:numinit/string-option/112` | `github:numinit/string-option/0x70` |
| `"q"`     | `github:numinit/string-option/q` | `github:numinit/string-option/113` | `github:numinit/string-option/0x71` |
| `"r"`     | `github:numinit/string-option/r` | `github:numinit/string-option/114` | `github:numinit/string-option/0x72` |
| `"s"`     | `github:numinit/string-option/s` | `github:numinit/string-option/115` | `github:numinit/string-option/0x73` |
| `"t"`     | `github:numinit/string-option/t` | `github:numinit/string-option/116` | `github:numinit/string-option/0x74` |
| `"u"`     | `github:numinit/string-option/u` | `github:numinit/string-option/117` | `github:numinit/string-option/0x75` |
| `"v"`     | `github:numinit/string-option/v` | `github:numinit/string-option/118` | `github:numinit/string-option/0x76` |
| `"w"`     | `github:numinit/string-option/w` | `github:numinit/string-option/119` | `github:numinit/string-option/0x77` |
| `"x"`     | `github:numinit/string-option/x` | `github:numinit/string-option/120` | `github:numinit/string-option/0x78` |
| `"y"`     | `github:numinit/string-option/y` | `github:numinit/string-option/121` | `github:numinit/string-option/0x79` |
| `"z"`     | `github:numinit/string-option/z` | `github:numinit/string-option/122` | `github:numinit/string-option/0x7a` |
| `"{"`     |                                  | `github:numinit/string-option/123` | `github:numinit/string-option/0x7b` |
| `"        | "`                               |                                    | `github:numinit/string-option/124`  | `github:numinit/string-option/0x7c` |
| `"}"`     |                                  | `github:numinit/string-option/125` | `github:numinit/string-option/0x7d` |
| `"~"`     |                                  | `github:numinit/string-option/126` | `github:numinit/string-option/0x7e` |

''
