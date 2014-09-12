use JSON qw(to_json);
sub Webqq::Client::send_group_message{
    my($self,$to_uin,$data,$callback) = @_;
    my $ua = $self->{asyn_ua};
    $callback = sub{
        my $response = shift;   
        print $response->content();
    };
    my $api_url = 'http://d.web2.qq.com/channel/send_qun_msg2';
    my @headers = (Referer=>'http://d.web2.qq.com/proxy.html?v=20110331002&callback=1&id=3');
    my %s = (
        group_uin      => $to_uin,
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
