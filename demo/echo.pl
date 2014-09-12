use lib '../src/';
use Webqq::Client;
use Digest::MD5 qw(md5_hex);
my $qq = 12345678;
my $pwd = md5_hex('your password');
my $client = Webqq::Client->new(debug=>1);
$client->login( qq=> $qq, pwd => $pwd);
$client->on_receive_message = sub{
    my $msg = shift;
    # do something after recv friends message
    if($msg->{type} eq 'message'){
        $client->send_message($msg->{from_uin},$msg->{content}) ;
    }
    #do something after recv qun message
    elsif($msg->{type} eq 'group_message'){
        $client->send_group_message($msg->{from_uin},$msg->{content}) ;        
    }
};
$client->run;
