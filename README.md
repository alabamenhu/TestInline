# Test::Inline

A Raku module allowing the inclusion of tests in module files.
This module was inspired by an [r/rakulang post](https://www.reddit.com/r/rakulang/comments/ih8tc9) by **codesections**, who expressed a desire to have test files be more closely connected with their associated modules.
While this technique doesn't remove the code from distribution versions, it *does* make testing from *within* modules/classes/etc. perhaps easier, as access to private attributes, etc, is possible.

To use, simply add the trait `is test` to any `Sub`:

```raku 
use Test::Inline;

sub foo is test { 
  use Test;
  …
} 
```

This marks `foo` as a special sub that contains tests.
It can contain and do whatever it wants, but it's *strongly* recommended to `use Test` and take advantage of its subs like `ok`, `is`, etc, for best results

In a test file, just add the option `:testing` to import in the special sub `inline-testing`.
When this is called, it will cycle through all subs tagged as tests, grouping them by packages:

```raku 
use Test;
use Test::Inline :testing;

# other tests

use Foo;   # modules with subs that 
use Bar;   # have the 'is test' trait

inline-testing;

done-testing();
```

*If you tend to use `plan`, note that `inline-testing` counts as a single test.*

# License

Licensed under the Artist License 2.0.  Written by Matthew Stephen Stuckwisch