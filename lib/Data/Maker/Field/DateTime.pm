package Data::Maker::Field::DateTime;
use Moose;
use DateTime::Event::Random;
with 'Data::Maker::Field';

our $VERSION = '0.08';

has start => ( is => 'rw');
has end => ( is => 'rw');
has format => ( is => 'rw');
has relative_to => ( is => 'rw');
has subtract => ( is => 'rw', isa => 'HashRef'); has add => ( is => 'rw', isa => 'HashRef');

sub generate_value {
  my ($this, $maker) = @_;
  my $dt;
  if ($this->start && $this->end) {
    my $args = {
      start => $this->parse_date_arg('start'),
      end => $this->parse_date_arg('end'),
    };
    $dt = DateTime::Event::Random->datetime(
      %{$args}
    );
  } elsif (my $name = $this->relative_to) {
    if (my $orig = $maker->in_progress($name)) {
      if (ref($orig) eq 'DateTime') {
        $dt = $orig->clone;
        my $params;
        if ($params = $this->subtract) {
          my $new_params = check_params($params);
          $dt->subtract_duration( DateTime::Duration->new( %{$new_params} ));
        } elsif ($params = $this->add) {
          my $new_params = check_params($params);
          $dt->add_duration( DateTime::Duration->new( %{$new_params} ));
        }
      }
    }
  }
  if ($this->format) {
    return &{$this->format}($dt);
  }
  return $dt;
}

sub check_params {
  my $params = shift;
  my @keys = keys(%{$params});
  my $key = shift @keys;	
  my @values = values(%{$params});
  my $value = shift @values;
  if (my $ref = ref($value)) {
    if ($ref eq 'ARRAY') {
      return { $key => Data::Maker->random( $value ) };
    }
  }
  return $params;
}

# `start` and `end` can be either a year or an actual DateTime object.  This method determines which it is and 
sub parse_date_arg {
  my ($this, $keyword) = @_;
  if (my $in = $this->$keyword) {
    if (ref($in) && $in->isa('DateTime')) {
      return $in;
    } elsif ($in =~ /^\d{4}$/) {
      return DateTime->new( year => $in );
    } else {
      die "Invalid `$keyword` argument to " . __PACKAGE__;
    }
  }
}
1;
