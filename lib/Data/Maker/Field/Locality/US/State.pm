package Data::Maker::Field::Locality::US::State;
use Moose;
with 'Data::Maker::Field';

has states => (is => 'rw', lazy => 1, isa => 'ArrayRef', auto_deref => 1, builder => '_build_states');

sub generate_value {
	my $this = shift;
	$this->states->[rand @{$this->states}];
}

sub _build_states {
	return [qw(AK AL AR AZ CA CO CT DC DE FL GA HI IA ID IL IN KS KY LA MA MD ME MI MN MO MS MS MT NC ND NE NH NJ NM NM NV NY OH OK OR PA RI SC SD TN TX UT VA VT WA WI WV WV WY)];
}
1;
