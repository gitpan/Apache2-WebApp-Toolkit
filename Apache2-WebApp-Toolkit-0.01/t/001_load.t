# -*- perl -*-

use strict;
use warnings FATAL => 'all';

# t/001_load.t - check module loading

use Apache::Test qw( :withtestmore );
use Test::More;

BEGIN {
    use_ok('Apache2::WebApp');
    use_ok('Apache2::WebApp::AppConfig');
    use_ok('Apache2::WebApp::Helper');
    use_ok('Apache2::WebApp::Helper::Class');
    use_ok('Apache2::WebApp::Helper::Kickstart');
    use_ok('Apache2::WebApp::Helper::Project');
    use_ok('Apache2::WebApp::Plugin');
    use_ok('Apache2::WebApp::Stash');
    use_ok('Apache2::WebApp::Template');
}

ok 1;

my $obj1 = new Apache2::WebApp;
my $obj2 = new Apache2::WebApp::AppConfig;
my $obj3 = new Apache2::WebApp::Plugin;
my $obj4 = new Apache2::WebApp::Stash;

isa_ok ( $obj1, 'Apache2::WebApp' );
isa_ok ( $obj2, 'Apache2::WebApp::AppConfig' );
isa_ok ( $obj3, 'Apache2::WebApp::Plugin' );
isa_ok ( $obj4, 'Apache2::WebApp::Stash' );

done_testing();
