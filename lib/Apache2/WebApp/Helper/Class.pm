#----------------------------------------------------------------------------+
#
#  Apache2::WebApp::Helper::Class - Command-line helper script
#
#  DESCRIPTION
#  Add a new class or template to an existing project.
#
#  AUTHOR
#  Marc S. Brooks <mbrooks@cpan.org>
#
#  This module is free software; you can redistribute it and/or
#  modify it under the same terms as Perl itself.
#
#----------------------------------------------------------------------------+

package Apache2::WebApp::Helper::Class;

use strict;
use warnings;
use base 'Apache2::WebApp::Helper';
use Cwd;
use File::Path;
use Getopt::Long;

our $VERSION = 0.02;

#~~~~~~~~~~~~~~~~~~~~~~~~~~[  OBJECT METHODS  ]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#----------------------------------------------------------------------------+
# process()
#
# Based on command-line arguments, build the class file.

sub process {
    my $self = shift;

    my %opts;

    GetOptions (
        \%opts,
        'apache_doc_root=s',
        'name=s',
        'project_title=s',
        'project_author=s',
        'project_email=s',
        'project_version=s',
        'config=s',
        'mkdir',
        'template',
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
        !$opts{name}            ||
        !$opts{project_author}  ||
        !$opts{project_email}   ||
        !$opts{project_version} ) {

        $self->help;
    }

    my $verbose = $opts{verbose};

    print "Creating the class...\n" if ($verbose);

    my $class = ucfirst( $opts{name} );

    $self->error("\033[31m--name must be alphanumeric with no spaces\033[0m")
      unless ($class =~ /^\w+?$/);

    my $app_path = getcwd;
    my $doc_root = $opts{apache_doc_root};

    $self->error("\033[31mFailed to create class outside the project directory\033[0m")
      unless ($app_path =~ /^$doc_root\/app\//);

    my $new_file = "$app_path/$class";

    $self->error("\033[31m--name of the same name already exists\033[0m")
      if (-f "$new_file\.pm");

    if ( $opts{mkdir} ) {
        my %mk_opts = ($verbose) ? ( verbose => 1 ) : ();

        mkpath( $new_file, %mk_opts );

        chmod 0755, $new_file;
    }

    my $package = $new_file;
    $package =~ s/^.*\/app\/(.*)/$1/gs;
    $package =~ s/\//::/g;
    $package =~ s/\b(\w)/uc($1)/eg;

    my $template = lc($package);
    $template =~ s/::/_/g;

    $self->set_vars({
        %opts,
        package_name  => $package,
        template_name => ( $opts{template} ) ? $template : undef,
      });

    $self->write_file( 'class_pm.tt', "$app_path/$class\.pm"              );
    $self->write_file( 'template.tt', "$doc_root/templates/$template\.tt" )
      if ( $opts{template} );

    print "Class created successfully\n";
    exit;
}

#----------------------------------------------------------------------------+
# help()
#
# Command-line argument help menu.

sub help {
    my $self = shift;

    print <<ERR_OUT;
Usage: webapp-class [OPTION...]

WebApp::Helper::Class - Add a new class or template to an existing project

 Options:

      --config (default)    Instead of passing arguments, import these values from a file

      --apache_doc_root     Absolute path to your project

      --name                Name of your class (example: MyClass)

      --project_author      Full name of the class owner
      --project_email       E-mail address of the class owner
      --project_version     Version number of your class

      --mkdir               Class contains subclasses, create a directory for them
      --template            Associate a tenplate with this class

      --help                List available command line options (this page)
      --verbose             Print messages to STDOUT

Report bugs to <mbrooks\@cpan.org>.
ERR_OUT

    exit;
}

1;

__END__

=head1 NAME

Apache2::WebApp::Helper::Class - Command-line helper script

=head1 SYNOPSIS

  use Apache2::WebApp::Helper::Class;

  my $obj = Apache2::WebApp::Helper::Class->new;

  $obj->process;

=head1 DESCRIPTION

Add a new class or template to an existing project.

=head2 COMMAND-LINE

  Usage: webapp-class [OPTION...]

  WebApp::Helper::Class - Add a new class or template to an existing project

    Options:

        --config (default)    Instead of passing arguments, import these values from a file

        --apache_doc_root     Absolute path to your project

        --name                Name of your class (example: MyClass)

        --project_author      Full name of the class owner
        --project_email       E-mail address of the class owner
        --project_version     Version number of your class

        --mkdir               Class contains subclasses, create a directory for them
        --template            Associate a tenplate with this class

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
