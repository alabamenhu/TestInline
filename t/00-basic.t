use Test;
use Test::Inline :testing;

package Foo {
    use Test::Inline;
    class Bar {
        sub a is test { use Test; $*i++ }
        sub b is test { use Test; $*i++ }
        sub c is test { use Test; $*i++ }
        sub d         { use Test; $*i++ } # should not run
    }

    sub e is test { use Test; $*i += 10 }
    sub f         { use Test; $*i += 10 } # should not run
}

my $*i;

inline-testing;

is $*i, 13, "Test sub verification counter";

say done-testing;