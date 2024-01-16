% szy_MailMe(Subject, Content);
% szy_MailMe(Subject, Content, Attachment);
% szy_MailMe(Subject, Content, Attachment, MailServer, MailAddress, Password);
% 发送邮件到我的MatlatResults@163.com邮箱或指定邮箱。
% 其中，主题Subject，正文Content，附件Attachment，邮件服务器MailServer，邮箱地址MailAddress，密码Password
function szy_MailMe(Subject, Content, Attachment, MailServer, MailAddress, Password)
if exist('MailServer', 'var') ~= 1
    MailServer = 'smtp.163.com';
end
if exist('MailAddress', 'var') ~= 1
    MailAddress = 'MatlabResults@163.com';
end
if exist('Password', 'var') ~= 1
    Password = 'szy123123';
end

setpref('Internet','E_mail',MailAddress);
setpref('Internet','SMTP_Server',MailServer);%SMTP服务器
setpref('Internet','SMTP_Username',MailAddress);
setpref('Internet','SMTP_Password',Password);
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');

props.setProperty('mail.smtp.socketFactory.class','javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

if exist('Attachment', 'var') == 1
    sendmail(MailAddress, Subject, Content, Attachment);
else
    sendmail(MailAddress, Subject, Content);
end
end
