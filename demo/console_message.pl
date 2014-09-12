use lib '../src/';
use POSIX qw(strftime);
use Webqq::Client;
use Encode::Locale;
use Digest::MD5 qw(md5_hex);
if (-t) {
      binmode(STDIN, ":encoding(console_in)");
      binmode(STDOUT, ":encoding(console_out)");
      binmode(STDERR, ":encoding(console_out)");
}

my $qq = 12345678;
my $pwd = md5_hex('your password');
my $client = Webqq::Client->new(debug=>0);
$client->login( qq=> $qq, pwd => $pwd);
$client->on_receive_message = sub{
    my $msg = shift;
    # do something after recv friends message
    if($msg->{type} eq 'message'){
        #$client->send_message($msg->{from_uin},$msg->{content}) ;
        print strftime("[%Y/%m/%d %H:%M:%S]",localtime($msg->{time})),"       MSG ",$msg->{content},"\n";
    }
    #do something after recv qun message
    elsif($msg->{type} eq 'group_message'){
        #$client->send_group_message($msg->{from_uin},$msg->{content}) ;        
        print strftime("[%Y/%m/%d %H:%M:%S]",localtime($msg->{time}))," GROUP_MSG ",$msg->{content},"\n";
    }
};
$client->run;
