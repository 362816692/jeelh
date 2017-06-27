--查询在线用户数
select  org_no,count(distinct(USER_ID)) cn  from  sp.sp_user_login where login_time>= trunc(SYSDATE) and org_no in('') group by org_no;

--查询日登陆人数
select a.org_no, a.cn1, b.cn2
  from (select org_no, count(1) cn1
          from sp.sp_user_login a
         where a.login_time >= trunc(SYSDATE)
           and a.login_time <= trunc(SYSDATE + 1)
           and org_no in ('')
         group by org_no) a,
       (select org_no, count(1) cn2
          from sp.sp_user_login_his a
         where a.login_time >= trunc(SYSDATE)
           and a.login_time <= trunc(SYSDATE + 1)
           and org_no in ('')
         group by org_no) b
 where a.org_no = b.org_no;

--查询累计访问次数
 select org_no,count(1) cn from sp.sp_user_login_his where org_no in ('') group by org_no;
 
 --查询KPI
 select * from (select row_number() over(partition by org_no order by KPI_DATE DESC NULLS LAST) rno,KPI_ID kpiId,
						       KPI_CLASS kpiClass, 
						       ORG_NO orgNo, 
						       to_char(KPI_DATE, 'yyyy-MM-dd hh24:mi:ss') kpiDate, 
						       AVGSER_RESP_TIME avgserRespTime, 
						       SYSRUN_TIME sysrunTime, 
						       SESS_NO sessNo, 
						       ONLINE_OP_NO onlineOpNo, 
						       REGIST_NO registNo, 
						       TOTAL_VISTNO totalVistno, 
						       BUS_RATE busRate, 
						       D_LOGIN_NO dLoginNo, 
						       DB_RESP_TIME dbRespTime 
						  from QOS_IMS_KPI WHERE ORG_NO in('')) a where rno=1
