unit module Inline;

# This will eventually probably expanded, hopefully nearly to the extent of regular tests
class Test {
    has $.name;
    has &.sub;
}

my Array %tests;

multi sub trait_mod:<is>(Sub $sub, :$test!) is export {
    die "Inline test subs may not have parameters, but found signature {$sub.signature.gist}."
        if $sub.arity > 0;

    my $package-name = $sub.package.^name;

    %tests{$package-name}.push:
            Test.new(
                    name => $sub.name,
                    sub  => $sub
            );
}

sub inline-testing is export(:testing) {
    use Test;

    subtest {
        for %tests.kv -> $package, @tests {
            subtest {
                for @tests.values -> $test {
                    subtest { $test.sub.() }, "sub {$test.name}";
                }
            }, "Package $package";
        }
    }, "Inline testing";
}