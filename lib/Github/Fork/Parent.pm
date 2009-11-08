package Github::Fork::Parent;

use 5.006;
use strict;
use warnings;

=head1 NAME

Github::Fork::Parent - Perl module to determine which repository stands in a root of GitHub forking hierarhy.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Github::Fork::Parent;

    my $foo = Github::Fork::Parent->new();
    ...

=head1 FUNCTIONS

=head2 github_parent

Takes link to repository (git://, git@ or http://) and returns http link to root repository.

=cut

use YAML::Tiny 1.40;
use LWP::UserAgent;

use Exporter 'import';
our @EXPORT = qw(github_parent);

sub get_network_data {
  my ($author,$project)=@_;
  my $url = "http://github.com/api/v2/yaml/repos/show/$author/$project/network";

  my $ua=LWP::UserAgent->new();
  my $response = $ua->get($url);
  if ($response->is_success) {
    my $yaml = $response->content();
    return $yaml;
  } else {
    if ($response->code eq '404') {
      return undef;
    } else {
      die "Could not GET data (".$response->status_line.")";
    }
  }
}

sub parse_github_links {
  my $link=shift;
  if ($link=~m#^(?:\Qgit://github.com/\E|git\@github\.com:\E|\Qhttp://github.com/\E)([^/]+)/([^/]+).git$#) {
    return ($1,$2);
  } else {
    return (undef,undef);
  }
  
}

sub github_parent {
  my $link=shift;
  my ($author,$project)=parse_github_links($link);
  return $link unless $author;
  my $yaml_content=get_network_data($author,$project);
  my $yaml=YAML::Tiny->read_string($yaml_content);
  my @network=@{$yaml->[0]->{network}};
  foreach my $fork (@network) {
    if ($fork->{':fork'} eq 'false') {
      return $fork->{':url'};
    }
  }
  die;
}


=head1 AUTHOR

Alexandr Ciornii, C<< <alexchorny at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-github-fork-parent at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Github-Fork-Parent>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Github::Fork::Parent


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Github-Fork-Parent>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Github-Fork-Parent>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Github-Fork-Parent>

=item * Search CPAN

L<http://search.cpan.org/dist/Github-Fork-Parent/>

=back


=head1 SEE ALSO

Net::GitHub

=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 Alexandr Ciornii.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Github::Fork::Parent
