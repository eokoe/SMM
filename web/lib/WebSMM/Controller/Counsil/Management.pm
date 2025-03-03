package WebSMM::Controller::Counsil::Management;
use Moose;
use namespace::autoclean;
use POSIX;

BEGIN { extends 'Catalyst::Controller' }

sub base : Chained('/counsil/base') : PathPart('management') : CaptureArgs(0) {
    my ( $self, $c, $id ) = @_;

    my $api = $c->model('API');

    $api->stash_result(
        $c, 'cities',
        params => {
            order => 'me.name',
        },
    );
    $c->stash->{select_cities} = [ map { [ $_->{id}, $_->{name} ] } @{ $c->stash->{cities} } ];

    $api->stash_result( $c, 'states' );
    $c->stash->{select_states} = [ map { [ $_->{id}, $_->{name} ] } @{ $c->stash->{states} } ];

    $api->stash_result( $c, 'organizations' );
    $c->stash->{select_organizations} = [ map { [ $_->{id}, $_->{name} ] } @{ $c->stash->{organizations} } ];
}

sub object : Chained('base') : PathPart('') : CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    my $api = $c->model('API');

    $api->stash_result( $c, [ 'managements', $id ], stash => 'management_obj' );

}

sub index : Chained('base') : PathPart('') : Args(0) {
    my ( $self, $c ) = @_;

    my $api = $c->model('API');

    $api->stash_result( $c, 'managements' );
}

sub add : Chained('base') : PathPart('new') : Args(0) {
}

sub edit : Chained('object') : PathPart('') : Args(0) {
}

sub change_password : Chained('base') : PathPart('change_password') : Args(0) {
    my ( $self, $c ) = @_;

    $c->stash->{template} = 'admin/management/change_password.tt';
}

__PACKAGE__->meta->make_immutable;

1;
