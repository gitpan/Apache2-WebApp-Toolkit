package Basic::Test;

use strict;
use warnings FATAL => 'all';

sub _default {
    my ( $self, $c ) = @_;

    $self->_success($c);
}

sub public {
    my ( $self, $c ) = @_;

    $self->_success($c);
}

sub stash {
    my ( $self, $c ) = @_;

    $c->stash( 'global', { foo => 'bar' } );

    $self->_stash($c);
}

sub _stash {
    my ( $self, $c ) = @_;

    my $result = $c->stash('global');

    $self->_success($c) if ($result->{foo} eq 'bar');
}

sub _success {
    my ( $self, $c ) = @_;

    $c->request->content_type('text/html');

    print "success";
    exit;
}

1;
