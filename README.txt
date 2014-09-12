qq robot for perl (use webqq protocol)
Module Dependencies:
    AnyEvent::UserAgent
    LWP::UserAgent
    HTTP::Cookies
    Digest::MD5
    JSON

Webqq::Client 版本号更新到v1.1，主要改进：
1）debug模式下支持打印send_message，send_group_message的POST提交数据，方便调试
2）修复了无法正常发送中文问题
3）修复了无法正常发送包含换行符的内容
4) on_receive_message on_send_message属性改为是lvalue方法，可以支持getter和setter使用方式
