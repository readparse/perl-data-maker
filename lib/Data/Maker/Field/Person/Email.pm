package Data::Maker::Field::Person::Email;
use Moose;
with 'Data::Maker::Field';

has domain_field => (is => 'rw');
has name_fields => (is => 'rw', isa => 'ArrayRef', auto_deref => 1);
has name_format => (is => 'rw');
has tld_choices => (is => 'rw', isa => 'ArrayRef', auto_deref => 1, default => sub {["com"]});

sub generate_value {
	my ($this, $maker) = @_;
	my $domain_field =  $this->domain_field;
	my @name_fields =  $this->name_fields;
	my $domain = $maker->in_progress($domain_field);
	my @name_values = map { $maker->in_progress($_) } @name_fields;
	my $username;
	if ($this->name_format eq 'jsmith') {
		$username = substr($name_values[0], 0, 1);
		$username .= $name_values[1];
	} elsif ($this->name_format eq 'john.smith') {
		$username = join(".", @name_values);
	}
	$username =~ s/[^\w\.\-]+//g;
	$domain =~ s/[^\w]+//g;
	my @tld_choices = $this->tld_choices;
	my $tld = $tld_choices[rand @tld_choices];
	return lc("$username\@$domain.com");
}
1;
