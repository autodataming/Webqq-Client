package Webqq::Message;
use JSON qw(from_json to_json);
use Webqq::Message::Message;
use Webqq::Message::GroupMessage;
use Webqq::Message::GroupInfoMessage;
use Webqq::Message::UserInfoMessage;
use Webqq::Message::ErrorMessage;
sub new {
    my $class = shift;
    my $self = {};
    return bless $self,$class;
}

sub parse{
    my $self = shift;
    my ($json_txt,$type) = @_;
    $type = 'auto' unless defined $type;
    my $json     = undef;
    my $msg_obj  = undef;
    eval{$json = from_json($json_txt)};
    warn "parse message error: $@ with json data: $json_txt\n" if $@;
    if($json){
        if($json->{retcode}==0){
            if($type eq 'auto'){
                eval{ $type = $json->{result}[0]{poll_type} };
                eval{ $type = 'group_info_message' if exists $json->{result}{gnamelist} } ;
                eval{ $type = 'user_info_message' if exists $json->{result}{gender} } ;
            } 
            if($type eq 'message'){$msg_obj = parse_message( $json->{result}[0] ) } 
            elsif($type eq 'group_message'){$msg_obj = parse_group_message($json->{result}[0])}
            elsif($type eq 'group_info_message'){$msg_obj = parse_group_info_message($json->{result})}
            elsif($type eq 'user_info_message'){$msg_obj = parse_user_info_message($json->{result})}
            else{}
        }
        else{$msg_obj = parse_error_message($json);} 
    } 
    return $msg_obj;
}
sub parse_message{
    my $m = shift;
    my $msg_obj = undef;
    $msg_obj = Webqq::Message::Message->new(
        type        =>  $m->{poll_type},
        msg_id      =>  $m->{value}{msg_id},
        from_uin    =>  $m->{value}{from_uin},
        to_uin      =>  $m->{value}{to_uin},
        msg_type    =>  $m->{value}{msg_type},
        reply_ip    =>  $m->{value}{reply_ip},
        'time'      =>  $m->{value}{'time'},
        content     =>  $m->{value}{content}[1]
    );
    return $msg_obj;    
}
sub parse_group_message{
    my $m = shift;
    my $msg_obj = undef;

    $msg_obj = Webqq::Message::GroupMessage->new(
        type        =>  $m->{poll_type},
        msg_id      =>  $m->{value}{msg_id},
        from_uin    =>  $m->{value}{from_uin},
        to_uin      =>  $m->{value}{to_uin},
        msg_type    =>  $m->{value}{msg_type},
        reply_ip    =>  $m->{value}{reply_ip},
        group_code  =>  $m->{value}{group_code},
        send_uin    =>  $m->{value}{send_uin},
        seq         =>  $m->{value}{seq},
        'time'      =>  $m->{value}{'time'},
        info_seq    =>  $m->{value}{info_seq},
        content     =>  $m->{value}{content}[1],
    );
    return $msg_obj;
}

sub parse_group_info_message{
    my $m = shift;
    my $msg_obj = undef;
     
    return $msg_obj;
}
sub parse_user_info_message{
    my $m = shift;
    my $msg_obj = undef;
    $msg_obj = Webqq::Message::UserInfoMessage->new(
        face        =>  $m->{face},
        birthday    =>  "$m->{year}-$m->{month}-$m->{day}",
        occupation  =>  $m->{occupation},
        phone       =>  $m->{phone},
        college     =>  $m->{college},
        uin         =>  $m->{uin},
        constel     =>  $m->{constel},
        blood       =>  $m->{blood},
        homepage    =>  $m->{homepage},
        'stat'      =>  $m->{'stat'}, 
        vip_info    =>  $m->{vip_info},
        country     =>  $m->{country},
        city        =>  $m->{city},
        personal    =>  $m->{personal},
        nick        =>  $m->{nick},
        shengxiao   =>  $m->{shengxiao},
        email       =>  $m->{email},
        client_type =>  $m->{client_type},
        province    =>  $m->{province},
        gender      =>  $m->{gender},
        mobile      =>  $m->{mobile},
    );
    return $msg_obj;  
}
sub parse_error_message{
    my $json = shift;
    my $msg_obj = undef;
    $msg_obj = Webqq::Message::ErrorMessage->new(
                        type        =>  'error_message',
                        errno       =>  $json->{retcode},
                        errormsg    =>  $json->{errmsg},
    );             
    return $msg_obj;
}
1;

