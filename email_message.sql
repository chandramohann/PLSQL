create or replace procedure email_message(module  varchar2,
                                          message varchar2) is
  l_mailhost  VARCHAR2(64) := '192.168.72.95';
  l_mail_conn UTL_SMTP.connection;
  crlf        VARCHAR2(2) := chr(13) || chr(10);

  v_raw         raw(32767);
  v_length      integer := 0;
  v_buffer_size integer := 32767;
  v_offset      integer := 1;

  lnCcCount       NUMBER(8);
  lnLastSemiColon NUMBER(8);
  lnCurSemiColon  NUMBER(8);
  lvCc            VARCHAR2(100);

  v_email_server VARCHAR2(100);
  v_port         NUMBER := 25;
  v_reply        UTL_SMTP.REPLY;
  v_msg          VARCHAR2(32767);
  v_line         VARCHAR2(32767);
  v_error_msg    VARCHAR2(32767);
  b_connected    BOOLEAN := FALSE;
  v_sender_id    NUMBER;
  v_sender       VARCHAR2(255);

  RECPT_ID  NUMBER;
  RECPT     VARCHAR2(255);
  p_stat    NUMBER := 0;
  pfilename varchar2(50);

  email_sender  varchar2(100);
  email_recv    varchar2(100);
  email_subject varchar2(100);
  email_body    varchar2(1000);
  l_object_type varchar2(50);

BEGIN

  dbms_output.put_line('in email :' || sqlerrm);

  begin
    select sender_cat_id,
           receiver_cat_id,
           email_server,
           email_subject,
           email_body,
           attachment_filename
      into v_sender_id,
           recpt_id,
           v_email_server,
           email_subject,
           email_body,
           pfilename
      from email_config
     where module_code = 'CDRFILE';
  exception
    when others then
      v_sender_id    := 6;
      recpt_id       := 8;
      v_email_server := 'smtp.nextpertise.nl';
  end;

  select email_id into v_sender from email_list where cat_id = v_sender_id;

  select email_id into recpt from email_list where cat_id = recpt_id;

  l_mail_conn := UTL_SMTP.open_connection(l_mailhost, 25);

  utl_smtp.helo(l_mail_conn, l_mailhost);
  utl_smtp.mail(l_mail_conn, v_sender);
  --UTL_SMTP.rcpt(l_mail_conn, recpt);
  IF recpt IS NOT NULL THEN
    lnCcCount := 1;
    LOOP
      IF lnCcCount = 1 THEN
        lnLastSemiColon := 0;
      ELSE
        lnLastSemiColon := INSTR(recpt, ';', 1, lnCcCount - 1);
      END IF;
      lnCurSemicolon := INSTR(recpt, ';', 1, lnCcCount);
      IF lnCurSemicolon = 0 THEN
        lvCc := SUBSTR(recpt, lnLastSemiColon + 1);
        UTL_SMTP.rcpt(l_mail_conn, lvCc);
        EXIT;
      ELSE
        lvCc := SUBSTR(recpt,
                       lnLastSemiColon + 1,
                       lnCurSemicolon - lnLastSemiColon - 1);
        UTL_SMTP.rcpt(l_mail_conn, lvCc);
      END IF;
      lnCcCount := lnCcCount + 1;
    END LOOP;
  END IF;

  --v_reply := UTL_SMTP.MAIL(l_mail_conn, 'chandra.mohan@yestelecom.nl');

  UTL_SMTP.open_data(l_mail_conn);

  --header
  UTL_SMTP.write_data(l_mail_conn,
                      'Date: ' ||
                      TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || Chr(13));
  UTL_SMTP.write_data(l_mail_conn, 'From: ' || v_sender || crlf);
  UTL_SMTP.write_data(l_mail_conn, 'Subject: ' || email_subject || crlf);
  UTL_SMTP.write_data(l_mail_conn, 'To: ' || recpt || crlf);
  UTL_SMTP.write_data(l_mail_conn, 'MIME-Version: 1.0' || crlf); -- Use MIME mail standard
  UTL_SMTP.write_data(l_mail_conn,
                      'Content-Type: multipart/mixed;' || crlf);
  UTL_SMTP.write_data(l_mail_conn,
                      ' boundary="-----SECBOUND"' || crlf || crlf);

  --body
  UTL_SMTP.write_data(l_mail_conn, '-------SECBOUND' || crlf);
  UTL_SMTP.write_data(l_mail_conn, 'Content-Type: text/plain;' || crlf);
  UTL_SMTP.write_data(l_mail_conn,
                      'Content-Transfer_Encoding: 7bit' || crlf || crlf);
  UTL_SMTP.write_data(l_mail_conn, message || crlf || crlf); -- Message body
  UTL_SMTP.write_data(l_mail_conn, crlf);
  dbms_output.put_line('attachment :' || sqlerrm);

  utl_smtp.close_data(l_mail_conn);

  utl_smtp.quit(l_mail_conn);

  dbms_output.put_line('success :' || sqlerrm);

exception
  when others then
    dbms_output.put_line('sqlerrm :' || sqlerrm);
END;
/
