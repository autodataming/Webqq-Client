package Webqq::Message::UserInfoMessage;
sub new{
    my $class = shift;
    my $self = {@_};
    return bless $self,$class;
}
1;
