use Digest::MD5 qw(md5 md5_hex);
sub Webqq::Client::_login1{ 
    print "attempt to login\n";
    my $self = shift;
    my $ua = $self->{ua};
    my $api_url = 'https://ssl.ptlogin2.qq.com/login';
    my @headers = (Referer => 'https://ui.ptlogin2.qq.com/cgi-bin/login?daid=164&target=self&style=5&mibao_css=m_webqq&appid=1003903&enable_qlogin=0&no_verifyimg=1&s_url=http%3A%2F%2Fweb2.qq.com%2Floginproxy.html&f_url=loginerroralert&strong_login=1&login_state=10&t=20140612002');

    $self->{qq_param}{pwd} = uc md5_hex( uc(md5_hex( $self->{qq_param}{pwd} . $self->{qq_param}{md5_salt})) . uc( $self->{qq_param}{verifycode}  ) );

    my @query_string = (
        u               =>  $self->{qq_param}{qq},
        p               =>  $self->{qq_param}{pwd},
        verifycode      =>  $self->{qq_param}{verifycode},
        webqq_type      =>  10,
        remember_uin    =>  1,
        login2qq        =>  1,
        aid             =>  $self->{qq_param}{g_appid},
        u1              =>  'http%3A%2F%2Fweb2.qq.com%2Floginproxy.html%3Flogin2qq%3D1%26webqq_type%3D10',
        h               =>  1,
        ptredirect      =>  0,
        ptlang          =>  2052,
        daid            =>  $self->{qq_param}{g_daid},
        from_ui         =>  1,
        pttype          =>  1,  
        dumy            =>  undef,
        fp              =>  'loginerroralert',
        action          =>  '3-14-15279',
        mibao_css       =>  $self->{qq_param}{g_mibao_css},
        t               =>  1,
        g               =>  1,
        js_type         =>  0,
        js_ver          =>  $self->{qq_param}{g_pt_version},
        pt_uistyle      =>  $self->{qq_param}{g_style},
        pt_vcode_v1     =>  0,
        pt_verifysession_v1 =>  $self->{qq_param}{verifysession},
        
    );
   
    my @query_string_pairs;
    push @query_string_pairs , shift(@query_string) . "=" . shift(@query_string) while(@query_string) ;
    my $response = $ua->get($api_url.'?'.join("&",@query_string_pairs),@headers );
    if($response->is_success){
        print $response->content() if $self->{debug};
        my $content = $response->content();
        my %d = ();
        @d{qw( retcode unknown_1 api_check_sig unknown_2 status nickname )} = $content=~/'(.*?)'/g;
        $self->{qq_param}{api_check_sig} = $d{api_check_sig};
        $self->{qq_param}{ptwebqq} = $self->search_cookie('ptwebqq');
        return 1;
    }
    else{return 0}
}
1;
