package Webqq::Message::GroupMessage;
use Encode;
sub new{
    my $class = shift;
    my $self = {@_};
    $self->{content} = encode("utf8",$self->{content}) if Encode::_utf8_on($self->{content});
    $self->{content}=~s/ $//;   
    $self->{content}=~s/\r/\n/g;   
    return bless $self,$class;
}
1;
