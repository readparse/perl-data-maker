package Data::Maker::Field::Person::SSN;
use Moose;
with 'Data::Maker::Field';
use Data::Maker::Field::Format;
use Data::Dumper;

has safe => (is => 'rw', isa => 'Bool', default => sub { 0 } );
has maker => (is => 'rw', isa => 'Data::Maker');
has format_field => (is => 'rw', isa => 'Data::Maker::Field::Format', lazy => 1, builder => '_build_format_field' );
has state_prefixes => (is => 'rw', isa => 'HashRef', lazy => 1, builder => '_build_state_prefixes' );
has format => (is => 'rw');
has from_state => (is => 'rw');

sub generate_value {
	my ($this, $maker) = @_;
	$this->maker($maker);
	my $format = $this->_build_format;
	$this->format_field->format($format);
	$this->format_field->generate_value($maker);
}

sub _build_format_field {
	my $this = shift;
	Data::Maker::Field::Format->new( format => $this->_build_format);
}

sub _build_format { 
	my $this = shift;
	if (my $state = $this->from_state) {
		if (my $value = $this->maker->in_progress($state)) {
			if (my $prefix = $this->prefix_from_state($value)) {
				if ($this->safe) {
					return $prefix . '-00-\d\d\d\d';
				} else {
					return $prefix . '-\d\d-\d\d\d\d';
				}
			}
		} 
		if (my $prefix = $this->prefix_from_state($state)) {
			if ($this->safe) {
				return $prefix . '-00-\d\d\d\d';
			} else {
				return $prefix . '-\d\d-\d\d\d\d';
			}
		}
	}
	my @safe = ('\d\d\d-00-\d\d\d\d', '9\d\d-\d\d-\d\d\d\d');
	my $safe_pick = $safe[rand @safe];
	return $this->safe ? $safe_pick : '\d\d\d-\d\d-\d\d\d\d';
}

sub prefix_from_state {
	my ($this, $state) = @_;
	if (my $prefixes = $this->state_prefixes->{$state}) {
		my $selected_prefix = $prefixes->[rand @{$prefixes}];
		return sprintf("%03d", $selected_prefix);
	}
}

sub _build_state_prefixes {
	return {
		NH => [1..3],
		ME => [4..7],
		VT => [8..9],
		MA => [10..34],
		RI => [35..39],
		CT => [40..49],
		NY => [50..134],
		NJ => [135..158],
		PA => [159..211],
		MD => [212..220],
		DE => [221..222],
		VA => [223..231],
		WV => [232..236],
		NC => [237..246],
		SC => [247..251],
		GA => [252..260],
		FL => [261..267],
		OH => [268..302],
		IN => [303..317],
		IL => [318..361],
		MI => [362..386],
		WI => [387..399],
		KY => [400..407],
		TN => [408..415],
		AL => [416..424],
		MS => [425..428],
		AR => [429..432],
		LA => [433..439],
		OK => [440..448],
		TX => [449..467],
		MN => [468..477],
		IA => [478..485],
		MO => [486..500],
		ND => [501..502],
		SD => [503..504],
		NE => [505..508],
		KS => [509..515],
		MT => [516..517],
		ID => [518..519],
		WY => [520..520],
		CO => [521..524],
		AZ => [526..527],
		UT => [528..529],
		NV => [530..530],
		WA => [531..539],
		OR => [540..544],
		CA => [545..573],
		AK => [574..574],
		HI => [575..576],
		DC => [577..579],
		NM => [585..585],
	};
}

1;

