package Data::Maker::Field::Person::SSN;
use base 'Data::Maker::Field::Format';

sub format { '\d\d\d-\d\d-\d\d\d\d' };

1;

