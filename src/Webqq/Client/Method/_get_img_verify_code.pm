use File::Temp qw/tempfile/;
sub Webqq::Client::_get_img_verify_code{
    my $self = shift;
    return 1 if $self->{qq_param}{is_need_img_verifycode} == 0;
    my $ua = $self->{ua};
    my $api_url = 'https://ssl.captcha.qq.com/getimage';
    my @headers = (Referer => 'https://ui.ptlogin2.qq.com/cgi-bin/login?daid=164&target=self&style=5&mibao_css=m_webqq&appid=1003903&enable_qlogin=0&no_verifyimg=1&s_url=http%3A%2F%2Fweb2.qq.com%2Floginproxy.html&f_url=loginerroralert&strong_login=1&login_state=10&t=20140612002');
    my @query_string = (
        aid        => $self->{qq_param}{g_appid},
        uin        => $self->{qq_param}{qq}, 
        cap_cd     => $self->{qq_param}{cap_cd},
        r          => rand(),
    );    

    my @query_string_pairs;
    push @query_string_pairs , shift(@query_string) . "=" . shift(@query_string) while(@query_string) ;
    
    my $response = $ua->get($api_url.'?'.join("&",@query_string_pairs),@headers);
    if($response->is_success){
        my ($fh, $filename) = tempfile("webqq_img_verfiy_XXXX",SUFFIX =>".jpg",TMPDIR => 1);
        binmode $fh;
        print $fh $response->content();
        close $fh; 
        print "input verifycode[$filename]: ";
        chomp($self->{qq_param}{verifycode} = <STDIN>);
        $self->{qq_param}{verifysession} = $self->search_cookie("verifysession") if $self->{qq_param}{verifysession} eq '';
        return 1;
    }
    else{return 0}    
}
1;
