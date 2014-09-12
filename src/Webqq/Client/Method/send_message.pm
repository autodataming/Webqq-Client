use JSON qw(from_json);
sub Webqq::Client::send_message{
    my($self,$to_uin,$data,$cb) = @_;
    my $send_message_callback;
    ref $cb eq 'CODE'?$send_message_callback = $cb:$send_message_callback = $self->{on_send_message};
    my $ua = $self->{asyn_ua};
    $callback = sub{
        my $response = shift;   
        print $response->content() if $self->{debug};
        my $json = from_json($response->content());
        if(ref $send_message_callback eq 'CODE'){
            $send_message_callback->($json->{retcode});
        }
        else{
            if($json->{retcode}==0){
                print "send message ok\n";
            }
            else{
                print "send message failure\n"; 
            }
        }
        
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
    
    my $post_content = [
        r           =>  to_json(\%s),
        clientid    =>  $self->{qq_param}{clientid},
        psessionid  =>  $self->{qq_param}{psessionid}
    ];
    if($self->{debug}){
        require URI;
        my $uri = URI->new('http:');
        $uri->query_form($post_content);    
        print $uri->query(),"\n";
    }
    $ua->post(
        $api_url,
        $post_content,
        @headers,
        $callback,
    );
}
1;
