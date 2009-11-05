#----------------------------------------------------------------------------+
#
#  Apache2::WebApp::Base - Base class implementing common functionality
#
#  DESCRIPTION
#  Base class module that implements a constructor and provides error
#  reporting functionality for various WebApp Toolkit modules and scripts.
#
#  AUTHOR
#  Marc S. Brooks <mbrooks@cpan.org>
#
#  This module is free software; you can redistribute it and/or
#  modify it under the same terms as Perl itself.
#
#----------------------------------------------------------------------------+

package Apache2::WebApp::Base;

use strict;
use warnings;
use Apache2::Log;
use Params::Validate qw( :all );
our $VERSION = 0.01;

#~~~~~~~~~~~~~~~~~~~~~~~~~~[  OBJECT METHODS  ]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#----------------------------------------------------------------------------+
# new(\%params)
#
# General object constructor.

sub new {
    my $class  = shift;
    my $params = (ref $_[0] eq 'HASH') ? shift : { @_ };
    my $self   = bless( {
        DEBUG => $params->{debug},
    }, $class );
    return ( $self->_init($params) ) ? $self : $class->error;
}

#----------------------------------------------------------------------------+
# version()
#
# Return the package version number.

sub version {
    my $self  = shift;
    my $class = ref $self || $self;
    no strict 'refs';
    return ${"${class}::VERSION"};
}

#----------------------------------------------------------------------------+
# error($mesg)
#
# Output errors/exceptions and exit.

sub error {
    my ( $self, $mesg )
      = validate_pos( @_,
          { type => OBJECT },
          { type => SCALAR }
          );

    if ( $self->{DEBUG} ) { confess $mesg } else { die $mesg }
}

#~~~~~~~~~~~~~~~~~~~~~~~~~~[  PRIVATE METHODS  ]~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#

#----------------------------------------------------------------------------+
# _init(\%params)
#
# Return a reference of $self to the caller.

sub _init {
    my ( $self, $params ) = @_;
    return $self;
}

1;

__END__

=head1 NAME

Apache2::WebApp::Base - Base class implementing common functionality

=head1 SYNOPSIS

  use base qw( Apache2::WebApp::Base );

=head1 DESCRIPTION

Base class module that implements a constructor and provides error reporting
functionality for various WebApp Toolkit modules and scripts.

=head1 OBJECT METHODS

=head2 new

General object constructor.

  my $obj = Apache2::WebApp::Base->new({
      param1 => 'foo',
      param2 => 'bar',
      ...
    });

  print $obj->{param1};     # bar is the value of 'param1'
  print $obj->{param2};     # foo is the value of 'param2'

=head2 version

Returns the package version number.

  my $version = $self->version();

=head2 error

Output errors/exceptions and exit.

  $self->error($mesg);

=head1 SEE ALSO

L<Apache2::WebApp>

=head1 AUTHOR

Marc S. Brooks, E<lt>mbrooks@cpan.orgE<gt> L<http://mbrooks.info>

=head1 COPYRIGHT

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
