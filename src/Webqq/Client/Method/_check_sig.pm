sub Webqq::Client::_check_sig {
    print "check security code\n";
    my $self = shift;
    my $api_url = $self->{qq_param}{api_check_sig};  
    my $ua = $self->{ua};
    my $response = $ua->get($api_url);
    if($response->is_success){
        return 1;
    }
    else{return 0}
}
1;
