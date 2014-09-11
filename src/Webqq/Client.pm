package Webqq::Client;
our $VERSION = v1.0;
use LWP::UserAgent;
use AnyEvent::UserAgent;
use Webqq::Client::Method::_prepare_for_login;
use Webqq::Client::Method::_check_verify_code;
use Webqq::Client::Method::_get_img_verify_code;
use Webqq::Client::Method::_login1;
use Webqq::Client::Method::_check_sig;
use Webqq::Client::Method::_login2;
use Webqq::Client::Method::_recv_message;
use Webqq::Client::Method::send_message;
use Webqq::Client::Method::_get_group_info;
use Webqq::Client::Method::_get_user_info;
sub new {
    my $class = shift;
    my %p = @_;
    my $cookie_jar  = HTTP::Cookies->new(hide_cookie2=>1);
    my $agent       = 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/37.0.2062.103';
    my $request_timeout = 300; 
    $self = {
        ua      => LWP::UserAgent->new(
                cookie_jar  =>  $cookie_jar,
                agent       =>  $agent,
                timeout     =>  $request_timeout
        ),
        asyn_ua => AnyEvent::UserAgent->new(
                cookie_jar  =>  $cookie_jar,
                agent       =>  $agent,
                request_timeout =>  0,
                inactivity_timeout  =>  0,
        ),
        cookie_jar  => $cookie_jar, 
        qq_param        =>  {
            qq                      =>  undef,
            pwd                     =>  undef,    
            is_need_img_verifycode  =>  0,
            send_group_msg_id       =>  1,
            clientid                =>  1+int(rand(99999999)),
            psessionid              =>  'null',
            vfwebqq                 =>  undef,
            ptwebqq                 =>  undef,
            status                  =>  'online',
            passwd_sig              =>  '',
            verifycode              =>  undef,
            verifysession           =>  undef,
            md5_salt                =>  undef,
            cap_cd                  =>  undef,
            ptvfsession             =>  undef,
            api_check_sig           =>  undef,
            g_pt_version            =>  undef,
            g_login_sig             =>  undef,
            g_style                 =>  5,
            g_mibao_css             =>  'm_webqq',
            g_daid                  =>  164,
            g_appid                 =>  1003903,
            g_pt_version            =>  10092,
        },
        qq_database     =>  {
            user    =>  {},
            friends =>  {},
            group   =>  {},
            discuss =>  {},
        },
        on_receive_message  =>  undef,
        on_send_message     =>  undef,
        debug => $p{debug},
        
    };
    if($self->{debug}){
        $self->{ua}->add_handler(request_send => sub {
            my($request, $ua, $h) = @_;
            print $request->as_string;
            return;
        });

        $self->{ua}->add_handler(
            response_header => sub { my($response, $ua, $h) = @_;
            print $response->as_string;
            return;
        });
    }

    return bless $self;
}

sub login{
    my $self = shift;
    my %p = @_;
    @{$self->{qq_param}}{qw(qq pwd)} = @p{qw(qq pwd)};
    print "initialize client param for QQ: $self->{qq_param}{qq} PWD: $self->{qq_param}{pwd}\n";
    #my $is_big_endian = unpack( 'xc', pack( 's', 1 ) ); 
    $self->{qq_param}{pwd} = pack "H*",lc $self->{qq_param}{pwd};
    return  
           $self->_prepare_for_login()    
        && $self->_check_verify_code()     
        && $self->_get_img_verify_code()   
        && $self->_login1()                
        && $self->_check_sig()             
        && $self->_login2();
}
sub _prepare_for_login;
sub _check_verify_code;
sub _get_img_verify_code;
sub _check_sig;
sub _login1;
sub _login2;
sub _get_user_info;
sub _get_group_info;
sub _get_group_list_info;
sub _get_friends_info;
sub _get_friends_list_info;
sub _get_discuss_list_info;
sub change_status;
sub send_message;
sub show_message;
sub logout;
sub run {
    my $self = shift;
    if($self->{qq_param}{login_state} ne 'success'){
        print "login failure\n";
        return ;
    }
    print "dispatch recv message callback\n";
    $self->_recv_message();
    print "enter main event loop\n";
    AE::cv->recv;
};
sub search_cookie{
    my($self,$cookie) = @_;
    my $result = undef;
    $self->{cookie_jar}->scan(sub{
        my($version,$key,$val,$path,$domain,$port,$path_spec,$secure,$expires,$discard,$rest) =@_;
        if($key eq $cookie){
            $result = $val ;
            return;
        }
    });
    return $result;
}

1;
