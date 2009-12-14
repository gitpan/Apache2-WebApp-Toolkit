#----------------------------------------------------------------------------+
#
#  Apache2::WebApp::Helper::Extra - Command-line helper script
#
#  DESCRIPTION
#  
#
#  AUTHOR
#  Marc S. Brooks <mbrooks@cpan.org>
#
#  This module is free software; you can redistribute it and/or
#  modify it under the same terms as Perl itself.
#
#----------------------------------------------------------------------------+

package Apache2::WebApp::Helper::Extra;

use strict;
use warnings;
use base 'Apache2::WebApp::Helper';
use Cwd;
use File::Path;
use Getopt::Long qw( :config pass_through );

our $VERSION = 0.01;

#~~~~~~~~~~~~~~~~~~~~~~~~~~[  OBJECT METHODS  ]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#----------------------------------------------------------------------------+
# process()
#
# Based on command-line arguments, install the package.

sub process {
    my $self = shift;

    my %opts;

    GetOptions (
        \%opts,
        'apache_doc_root=s',
        'install=s',
        'project_title=s',
        'config=s',
        'help',
        'verbose',
      );

    if ( $opts{config} ) {
        my $config = $self->config->parse( $opts{config} );

        @opts{keys %$config} = values %$config;
    }

    if ( $opts{help}            ||
        !$opts{apache_doc_root} ||
        !$opts{project_title}   ||
        !$opts{install}         ) {

        $self->help;
    }

    my $verbose = $opts{verbose};

    print "Package installed successfully\n";
    exit;
}

#----------------------------------------------------------------------------+
# help()
#
# Command-line argument help menu.

sub help {
    my $self = shift;

    print <<ERR_OUT;
Usage: webapp-extra [OPTION...]

WebApp::Helper::Extra - 

 Options:

      --config (default)    Instead of passing arguments, import these values from a file

      --apache_doc_root     Absolute path to your project

      --project_title       Name of your project (example: Project)

      --install             Name of package

      --help                List available command line options (this page)
      --verbose             Print messages to STDOUT

Report bugs to <mbrooks\@cpan.org>.
ERR_OUT

    exit;
}

1;

__END__

=head1 NAME

Apache2::WebApp::Helper::Extra - Command-line helper script

=head1 SYNOPSIS

  use Apache2::WebApp::Helper::Extra;

  my $obj = Apache2::WebApp::Helper::Extra->new;

  $obj->process;

=head1 DESCRIPTION

This is a placeholder for a package that is currently under development.

=head2 COMMAND-LINE

  Usage: webapp-extra [OPTION...]

  WebApp::Helper::Extra - 

    Options:

        --config (default)    Instead of passing arguments, import these values from a file

        --apache_doc_root     Absolute path to your project

        --project_title       Name of your project (example: Project)

        --install             Name of package

        --help                List available command line options (this page)
        --verbose             Print messages to STDOUT

=head1 SEE ALSO

L<Apache2::WebApp>, L<Apache2::WebApp::Helper>, L<Cwd>, L<File::Path>, L<Getopt::Long>

=head1 AUTHOR

Marc S. Brooks, E<lt>mbrooks@cpan.orgE<gt> L<http://mbrooks.info>

=head1 COPYRIGHT

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
