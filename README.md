# Test::Inline

An lightweight Raku module allowing tests anywhere in modules (thus potentially enabling access to implementation details).

This module was inspired by an [r/rakulang post](https://www.reddit.com/r/rakulang/comments/ih8tc9) by **codesections**, who expressed a desire to have test files be more closely connected with their associated modules.
While this technique doesn't remove the code from distribution versions, it *does* allow for testing *inside of* modules/classes/etc.  

To use, simply add the trait `is test` to a `Sub` anywhere in your code.
There is really only a single restriction
  - *The `Sub` must take no arguments*  
  (Use dynamic variables to pass data if you need to)
  
Here is a somewhat contrived example that should show nicely how it can be integrated.

```raku 
unit module Rectangle;

use Test::Inline;

has Point $.a; # bottom left
has Point $.b; # top right

sub calculate-area($x, $y) {     $x * $y }
sub distance(      $a, $b) { abs $a - $b }

method area { 
  calculate-area
    distance($!a.x, $!b.x),
    distance($!a.y, $!b.y)
}
  
method overlap(Rectangle $other) { ... }
  

sub t-distance is test { 
  use Test;
  is distance( 2,4), 2;
  is distance(-2,4), 6;
  ...
} 

sub t-area is test { 
  use Test;
  is calculate-area(1,3),  3;
  is calculate-area(8,3), 24;
  ...
} 

```

This marks `t-area` and `t-distance` as special subs that contains tests.
Because they are inside of `Rectangle`, they can access its lexically scoped subs or variables, which a normal test file cannot.
Each test sub can contain or do whatever it wants but it's *strongly* recommended to `use Test` and take advantage of its routines, like in the example.
Each test sub is treated as a subtest (ha!) of the package it's included in.  

To actually run the tests, just add the option `:testing` to import in the special sub `inline-testing` in a test file.
When this is called, it will cycle through all subs tagged as tests, grouping them by packages:

```raku 
use Test;
use Test::Inline :testing;

# The first step is to 'use' each module that contains
# testable subs.  Nothing else needs to be done here. 
use Rectangle;   # load any modules with   
use Circle;      # subs that have the 
use Trapezoid;   # 'is test' trait 

# Then, initiate the inline testing
# (counts as a single test with subtests)
inline-testing;

# Conclude testing in the .t file
done-testing();
```

## Version history

  * **v0.1**
    * Initial release
    * All features should work 
    * If no issues are found, I'll bump version to 1.0 at the end of 2020.    
## License and Copyright

Licensed under the Artist License 2.0.  
© 2020 Matthew Stephen Stuckwisch