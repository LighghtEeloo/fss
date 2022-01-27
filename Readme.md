# fss

is a short lua implementation for lightweight fs search.

## is not

fss is not:
- `find`, `fd`: don't provide powerful options or search speed
- `grep`, `rg`: use extremely plain parsing rules, limited for only daily usage

## man

Note `{}` means repeat 0 or any times, ` | ` means either.

```
usage:  lua /home/lighght/Xpace/fss/fss.lua <PATTERNS> <PATH>{ <PATH>}
where:  <PATH>     ::= / | /<name>{/<name>} | <name>{/<name>}
        <PATTERNS> ::= <PATTERN>{,<PATTERN>}
        <PATTERN>  ::= <cstr>{.<cstr>
        <cstr>     ::= <consecutive str>
        <name>     ::= <file name>
      
means:  given a group of patterns, 
     :  use each pattern to search in all paths recursively;
     :  and output the combined results in stdout.
      
 also:  if one path already satisfies, its children will not be included
      
 e.g.:  X.482.H    :   1 pattern, which finds Xpace/EECS-482/Homeworks
 e.g.:  Xp.e.482.H :   1 pattern, does the same
 e.g.:  Xe.482.H   :   1 pattern, but fails the prev search
 e.g.:  X.482.H,Y  :   2 patterns, find [<prev search>, Yggdrasill]
                       but no more children under Yggdrasill
```

## rc

- `depth_limit`: given `depth` returns whether the depth excceeds limit; stops search if true
- `noticeable` : given `(dirpath, item_name)`, returns whether the item will appear in search memo and ready for a match
- `expandable` : given `(dirpath, item_name)`, returns whether the item needs to be recursively searched; the item **must be noticeable**

## deps

*Normally one won't need these. Luarocks should have taken care of these.*

Penlight is the battery for lua, like `std` for C++ and Rust or `core` for OCaml.

```bash
luarocks install penlight
```

