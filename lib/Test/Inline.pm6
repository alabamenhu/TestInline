unit module Inline;

my Sub @tests;

#| Marks a sub as being for internal test purposes
multi sub trait_mod:<is>(Sub $sub, :$test!) is export {
    die "Inline test subs may not have parameters, but found signature {$sub.signature.gist}."
        if $sub.arity > 0;

    my $package-name = $sub.package.^name;

    @tests.push: $sub;
}

#| Calls all subs marked as 'is test' in loaded modules
sub inline-testing is export(:testing) {
    use Test;

    subtest {
        for @tests.categorize(*.package.^name).sort(*.key)
         -> (:key($package), :value(@subs)) {

            subtest {
                for @subs.sort(*.name) -> &test {
                    subtest { test }, "sub {&test.name}";
                }
            }, "Package $package";
        }
    }, "Inline testing";
}