use URI::Escape qw(uri_escape);
sub Webqq::Client::_prepare_for_login{
    my $self = shift;
    my $ua = $self->{ua};
    my $api_url = 'https://ui.ptlogin2.qq.com/cgi-bin/login?daid=164&target=self&style=5&mibao_css=m_webqq&appid=1003903&enable_qlogin=0&no_verifyimg=1&s_url=http%3A%2F%2Fweb2.qq.com%2Floginproxy.html&f_url=loginerroralert&strong_login=1&login_state=10&t=20140612002';  
    my @headers = (Referer=>'http://web2.qq.com/webqq.html');
    my @global_param = qw(
        g_pt_version
        g_login_sig
        g_style
        g_mibao_css
        g_daid
        g_appid
    );

    my $regex_pattern = 'var\s*(' . join("|",@global_param) . ')\s*=\s*encodeURIComponent\("(.*?)"\)';
    my $response = $ua->get($api_url,@headers);
    if($response->is_success){
        my $content = $response->content();
        my %kv = map {uri_escape($_)} $content=~/$regex_pattern/g ;        
        for(keys %kv){
            $self->{qq_param}{$_} = $kv{$_};
        }
        return 1;
    }
    else{
        return 0;
    }
}
1;
