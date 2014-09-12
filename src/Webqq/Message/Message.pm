package Webqq::Message::Message;
use Encode;
sub new {
    my $class = shift;
    my $self = {@_};
    $self->{content}=~s/ $//;   
    $self->{content}=~s/\n|\r/\\n/g;
    return bless $self,$class;
}
1;
