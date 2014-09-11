use JSON qw(to_json);
sub Webqq::Client::send_message{
    my($self,$to_uin,$data,$callback) = @_;
    my $ua = $self->{asyn_ua};
    $callback = sub{
        my $response = shift;   
        print $response->content();
    };
    my $api_url = 'http://d.web2.qq.com/channel/send_buddy_msg2';
    my @headers = (Referer=>'http://d.web2.qq.com/proxy.html?v=20110331002&callback=1&id=3');
    my %s = (
        to      => $to_uin,
        face    => 570,
        content => qq{["$data","",[]]},
        msg_id  =>  ++$self->{qq_param}{send_msg_id},
        clientid => $self->{qq_param}{clientid},
        psessionid  => $self->{qq_param}{psessionid},
    );
        
    $ua->post(
        $api_url,
        [   
            r           =>  to_json(\%s),
            clientid    =>  $self->{qq_param}{clientid},
            psessionid  =>  $self->{qq_param}{psessionid}
        ],
        @headers,
        $callback,
    );
}
1;
