use Test;
use Test::Inline :testing;

package Foo {
    use Test::Inline;
    class Bar {
        sub a is test { use Test }
        sub b is test { use Test; is 5,5, "inside b"; }
        sub c is test { use Test }
        sub d         { False }
    }
}

inline-testing;

done-testing;