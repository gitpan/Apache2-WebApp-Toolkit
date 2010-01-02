#----------------------------------------------------------------------------+
#
#  Apache2::WebApp::Helper::Extra - Command-line helper script
#
#  DESCRIPTION
#  What is an Extra?  It is a pre-package web application that can be easily
#  added to an existing project.  Each package provides additional
#  functionality that can be easily modified and extended to your needs.
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
use File::Copy::Recursive qw( dircopy );
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
        'config=s',
        'install=s',
        'force',
        'help',
        'verbose',
      );

    if ( $opts{help}    ||
        !$opts{config}  ||
        !$opts{install} ) {

        print "\033[33mMissing or invalid options\033[0m\n\n";

        $self->help;
    }
    else {
        my $config = $self->config->parse( $opts{config} );

        @opts{keys %$config} = values %$config;
    }

    my $project  = $opts{project_title};
    my $doc_root = $opts{apache_doc_root};
    my $install  = $opts{install};
    my $force    = $opts{force};
    my $verbose  = $opts{verbose};

    print "Preparing for installation...\n" if ($verbose);

    $self->error("\033[31m--project_title must be alphanumeric with no spaces\033[0m")
      unless ($project =~ /^\w+?$/);

    $self->error("\033[31m--apache_doc_root selected does not exist\033[0m")
      unless (-d $doc_root);

    $self->error("\033[31m--install must be alphanumeric with no spaces\033[0m")
      unless ($install =~ /^\w+?$/);

    my $name = ucfirst($install);

    my $package = "Apache2::WebApp::Extra::$name";

    unless ( $package->can('isa') ) {
        eval "require $package";

        $self->error("\033[31m--install does not exist\033[0m") if $@;
    }

    print "Updating project '$project' with new sources\n" if ($verbose);

    my $outdir = lc($name);

    mkpath( "$doc_root/htdocs/extras/$outdir",    $verbose, 0755 );
    mkpath( "$doc_root/templates/extras/$outdir", $verbose, 0777 );

    dircopy( '/usr/share/webapp-toolkit/extra/htdocs/admin',    "$doc_root/htdocs/extras/admin"    ) or die $!;
    dircopy( '/usr/share/webapp-toolkit/extra/templates/admin', "$doc_root/templates/extras/admin" ) or die $!;

    $self->set_vars(\%opts);

    my @files = glob "/usr/share/webapp-toolkit/extra/class/$outdir/*.tt";

    foreach my $file (@files) {

        $file =~ s/^(?:.+)\/(\w+|_)\.tt$/$1/;

        next unless ($file);

        my $outfile = $file;

        if ($outfile =~ /\_/) {
            $outfile =~ s/(?:^|(?<=\_))(\w)/uc($1)/eg;
            $outfile =~ s/\_/\//g;
        }
        else {
            $outfile =~ s/\b(\w)/uc($1)/eg;
        }

        my $class = "$doc_root/app/$project/$outfile\.pm";

        $self->error("\033[31m--install already exists.  Must use --force to install\033[0m")
          if (-e $class && !$force);

        $self->write_file( "extra/class/admin/$file\.tt", $class );
    }

    print "\033[33mPackage '$name' installation complete\033[0m\n";
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

      --install             Name of the Extra to install (example: Admin)

      --force               Ignore warnings and install the package

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

What is an Extra?  It is a pre-package web application that can be easily
added to an existing project.  Each package provides additional
functionality that can be easily modified and extended to your needs.

=head2 COMMAND-LINE

  Usage: webapp-extra [OPTION...]

  WebApp::Helper::Extra - 

    Options:

        --config (default)    Instead of passing arguments, import these values from a file

        --install             Name of the Extra to install (example: Admin)

        --force               Ignore warnings and install the package

        --help                List available command line options (this page)
        --verbose             Print messages to STDOUT

=head1 SEE ALSO

L<Apache2::WebApp>, L<Apache2::WebApp::Helper>, L<File::Copy::Recursive>,
L<File::Path>, L<Getopt::Long>

=head1 AUTHOR

Marc S. Brooks, E<lt>mbrooks@cpan.orgE<gt> L<http://mbrooks.info>

=head1 COPYRIGHT

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut