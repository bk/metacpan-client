use strict;
use warnings;
package MetaCPAN::Client::Pod;
# ABSTRACT: A Pod object

use Moo;

has name => ( is => 'ro', required => 1 );

my @known_formats = qw<
    html plain x_pod x_markdown
>;

foreach my $format (@known_formats) {
    has $format => (
        is      => 'ro',
        lazy    => 1,
        default => sub {
            my $self = shift;
            return $self->_request( $format );
        },
    );
}

sub _request {
    my $self   = shift;
    my $ctype  = shift || "plain";

    $ctype =~ s/_/-/;

    my $name = $self->name;

    require MetaCPAN::Client::Request;

    return
        MetaCPAN::Client::Request->new->fetch(
            "pod/${name}?content-type=text/${ctype}"
        );
}


1;

__END__

=head1 DESCRIPTION

=head1 SYNOPSIS

  use strict;
  use warnings;
  use MetaCPAN::Client;
  
  my $pod = MetaCPAN::Client->new->pod('Moo');
  
  print $pod->html;


=head1 ATTRIBUTES

=head2 name

The name of the module (probably always the value passed to the pod() method)

=head2 x_pod

The raw pod extracted from the file.

=head2 html

Formatted as an HTML chunk (No <html>...<body>)

=head2 x_markdown

Converted to Markdown.

=head2 plain

Formatted as plain text.

Get the plaintext version of the documentation

  $pod = MetaCPAN::Client->new->pod( "MetaCPAN::Client" );
  print $pod->plain;

