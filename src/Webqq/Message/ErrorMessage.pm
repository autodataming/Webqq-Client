package Webqq::Message::ErrorMessage;
sub new{
    my $class = shift;
    my $self = {@_};
    return bless $self,$class;
}
1;
