use Webqq::Message;
use POSIX qw(strftime);
sub Webqq::Client::_recv_message{
    my $self = shift;
    my $recv_message_callback = $self->{on_receive_message};
    my $ua = $self->{asyn_ua};
    my $callback = $self->{on_receive_message};
    my $api_url = 'http://d.web2.qq.com/channel/poll2';
    $callback = sub {
        my $response = shift;
        print $response->content() if $self->{debug};
        my $msg = Webqq::Message->parse($response->content());
        if(ref $recv_message_callback eq 'CODE'){
            $recv_message_callback->($msg);
        }
        else{ 
            my $prefix = strftime('[%Y/%m/%d %H:%M:%S]',localtime($msg->{'time'})) 
                        . ' ' 
                        . $msg->{type}  
                        . ' ' ;

            my $is_first_time = 1;
            my $p = {
                1   => $prefix,
                0   => ' ' x length($prefix),
            };
            for(split /\n/,$msg->{content}){
                print $p->{$is_first_time}," ",$_,"\n";
                $is_first_time = 0;
            }
        }
        $self->_recv_message();
    };

    my %r = (
        clientid    =>  $self->{qq_param}{clientid},
        psessionid  =>  $self->{qq_param}{psessionid},
        key         =>  0,
        ids         =>  [],
    );

    my @headers = (Referer=>"http://d.web2.qq.com/proxy.html?v=20110331002&callback=1&id=3",);
    $ua->post(
        $api_url,
        [
            r           =>  to_json(\%r),
            clientid    =>  $self->{qq_param}{clientid},
            psessionid  =>  $self->{qq_param}{psessionid}
        ],
        @headers,
        $callback
    );
     
}
1;
