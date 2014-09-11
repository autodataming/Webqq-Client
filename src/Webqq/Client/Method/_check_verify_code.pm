sub Webqq::Client::_check_verify_code{
    print "check verify code\n";
    my $self = shift;
    my $ua = $self->{ua};
    my $api_url = 'https://ssl.ptlogin2.qq.com/check';
    my @headers = (Referer=>'https://ui.ptlogin2.qq.com/cgi-bin/login?daid=164&target=self&style=5&mibao_css=m_webqq&appid=1003903&enable_qlogin=0&no_verifyimg=1&s_url=http%3A%2F%2Fweb2.qq.com%2Floginproxy.html&f_url=loginerroralert&strong_login=1&login_state=10&t=20140612002');
    my @query_string = (
        uin         =>  $self->{qq_param}{qq},
        appid       =>  $self->{qq_param}{g_appid},
        js_ver      =>  $self->{qq_param}{g_pt_version},
        js_type     =>  0,
        login_sig   =>  $self->{qq_param}{g_login_sig},
        u1          =>  'http%3A%2F%2Fweb2.qq.com%2Floginproxy.html',
        r           =>  rand(),
    ); 
    
    my @query_string_pairs;
    push @query_string_pairs , shift(@query_string) . "=" . shift(@query_string) while(@query_string);

    my $response = $ua->get($api_url.'?'.join("&",@query_string_pairs),@headers);
    if($response->is_success){
        print $content,"\n" if $self->{debug};
        my $content = $response->content();
        my %d = ();
        @d{qw( retcode cap_cd md5_salt verifysession)} = $content=~/'(.*?)'/g ;
        $d{md5_salt} =~ s/\\\\x/\x/g; 
        $self->{qq_param}{md5_salt} = eval qq{"$d{md5_salt}"};
        $self->{qq_param}{cap_cd} = $d{cap_cd};
        $self->{qq_param}{verifysession} = $d{verifysession};
        if($d{retcode} ==0){
            print "lucky, no need for image verify\n";
            $self->{qq_param}{verifycode} = $d{cap_cd};
        }
        elsif($d{retcode} == 1){
            print "need for image verify\n";
            $self->{qq_param}{is_need_img_verifycode} = 1
        }
        
        return 1;
    }
    else{return 0}
}
1;
