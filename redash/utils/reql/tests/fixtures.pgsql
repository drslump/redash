--
-- Harvested from PostgreSQL regression tests
-- https://github.com/postgres/postgres/tree/master/src/test/regress/sql
--
------------------------------------------

SELECT 1 AS one;
SELECT true AS true;
SELECT false AS false;
SELECT '' AS t_3, BOOLTBL1.* FROM BOOLTBL1;
SELECT '' AS f_4, BOOLTBL2.* FROM BOOLTBL2;
SELECT '' AS tf_12, BOOLTBL1.*, BOOLTBL2.*
   FROM BOOLTBL1, BOOLTBL2
   WHERE BOOLTBL2.f1 <> BOOLTBL1.f1;
SELECT '' AS tf_12, BOOLTBL1.*, BOOLTBL2.*
   FROM BOOLTBL1, BOOLTBL2
   WHERE boolne(BOOLTBL2.f1,BOOLTBL1.f1);
SELECT '' AS "True", f1
   FROM BOOLTBL1
   WHERE f1 IS TRUE;
SELECT
    d,
    b IS TRUE AS istrue,
    b IS NOT TRUE AS isnottrue,
    b IS FALSE AS isfalse,
    b IS NOT FALSE AS isnotfalse,
    b IS UNKNOWN AS isunknown,
    b IS NOT UNKNOWN AS isnotunknown
    FROM booltbl3 ORDER BY o;
SELECT istrue AND isnul AND istrue FROM booltbl4;
SELECT istrue AND istrue AND isnul FROM booltbl4;
SELECT isnul AND istrue AND istrue FROM booltbl4;
SELECT isfalse AND isnul AND istrue FROM booltbl4;
SELECT istrue AND isfalse AND isnul FROM booltbl4;
SELECT isnul AND istrue AND isfalse FROM booltbl4;
SELECT isfalse OR isnul OR isfalse FROM booltbl4;
SELECT isfalse OR isfalse OR isnul FROM booltbl4;
SELECT isnul OR isfalse OR isfalse FROM booltbl4;
SELECT isfalse OR isnul OR istrue FROM booltbl4;
SELECT istrue OR isfalse OR isnul FROM booltbl4;
SELECT isnul OR istrue OR isfalse FROM booltbl4;

-- abstime.sql
-----------------------------------------

SELECT '' AS eight, * FROM ABSTIME_TBL;
SELECT '' AS six, * FROM ABSTIME_TBL
   WHERE ABSTIME_TBL.f1 < abstime 'Jun 30, 2001';
SELECT '' AS six, * FROM ABSTIME_TBL
   WHERE ABSTIME_TBL.f1 > abstime '-infinity';
SELECT '' AS six, * FROM ABSTIME_TBL
   WHERE abstime 'May 10, 1947 23:59:12' <> ABSTIME_TBL.f1;
SELECT '' AS three, * FROM ABSTIME_TBL
   WHERE abstime 'epoch' >= ABSTIME_TBL.f1;
SELECT '' AS four, * FROM ABSTIME_TBL
   WHERE ABSTIME_TBL.f1 <= abstime 'Jan 14, 1973 03:14:21';

-- #UNSUPPORTED <?>
-- SELECT '' AS four, * FROM ABSTIME_TBL
--  WHERE ABSTIME_TBL.f1 <?>
--	tinterval '["Apr 1 1950 00:00:00" "Dec 30 1999 23:00:00"]'

SELECT '' AS four, f1 AS abstime,
  date_part('year', f1) AS year, date_part('month', f1) AS month,
  date_part('day',f1) AS day, date_part('hour', f1) AS hour,
  date_part('minute', f1) AS minute, date_part('second', f1) AS second
  FROM ABSTIME_TBL
  WHERE isfinite(f1)
  ORDER BY abstime;

--
-- ADVISORY LOCKS
--
SELECT
	pg_advisory_xact_lock(1), pg_advisory_xact_lock_shared(2),
	pg_advisory_xact_lock(1, 1), pg_advisory_xact_lock_shared(2, 2);
SELECT locktype, classid, objid, objsubid, mode, granted
	FROM pg_locks WHERE locktype = 'advisory'
	ORDER BY classid, objid, objsubid;
SELECT pg_advisory_unlock_all();
SELECT count(*) FROM pg_locks WHERE locktype = 'advisory';
SELECT
	pg_advisory_unlock(1), pg_advisory_unlock_shared(2),
	pg_advisory_unlock(1, 1), pg_advisory_unlock_shared(2, 2);
SELECT count(*) FROM pg_locks WHERE locktype = 'advisory';
SELECT
	pg_advisory_xact_lock(1), pg_advisory_xact_lock_shared(2),
	pg_advisory_xact_lock(1, 1), pg_advisory_xact_lock_shared(2, 2);
SELECT locktype, classid, objid, objsubid, mode, granted
	FROM pg_locks WHERE locktype = 'advisory'
	ORDER BY classid, objid, objsubid;
SELECT
	pg_advisory_lock(1), pg_advisory_lock_shared(2),
	pg_advisory_lock(1, 1), pg_advisory_lock_shared(2, 2);
SELECT locktype, classid, objid, objsubid, mode, granted
	FROM pg_locks WHERE locktype = 'advisory'
	ORDER BY classid, objid, objsubid;
SELECT
	pg_advisory_unlock(1), pg_advisory_unlock(1),
	pg_advisory_unlock_shared(2), pg_advisory_unlock_shared(2),
	pg_advisory_unlock(1, 1), pg_advisory_unlock(1, 1),
	pg_advisory_unlock_shared(2, 2), pg_advisory_unlock_shared(2, 2);
SELECT count(*) FROM pg_locks WHERE locktype = 'advisory';
SELECT
	pg_advisory_lock(1), pg_advisory_lock_shared(2),
	pg_advisory_lock(1, 1), pg_advisory_lock_shared(2, 2);
SELECT locktype, classid, objid, objsubid, mode, granted
	FROM pg_locks WHERE locktype = 'advisory'
	ORDER BY classid, objid, objsubid;
SELECT
	pg_advisory_xact_lock(1), pg_advisory_xact_lock_shared(2),
	pg_advisory_xact_lock(1, 1), pg_advisory_xact_lock_shared(2, 2);
SELECT locktype, classid, objid, objsubid, mode, granted
	FROM pg_locks WHERE locktype = 'advisory'
	ORDER BY classid, objid, objsubid;
SELECT pg_advisory_unlock_all();
SELECT count(*) FROM pg_locks WHERE locktype = 'advisory';
SELECT
	pg_advisory_xact_lock(1), pg_advisory_xact_lock(1),
	pg_advisory_xact_lock_shared(2), pg_advisory_xact_lock_shared(2),
	pg_advisory_xact_lock(1, 1), pg_advisory_xact_lock(1, 1),
	pg_advisory_xact_lock_shared(2, 2), pg_advisory_xact_lock_shared(2, 2);
SELECT locktype, classid, objid, objsubid, mode, granted
	FROM pg_locks WHERE locktype = 'advisory'
	ORDER BY classid, objid, objsubid;
SELECT count(*) FROM pg_locks WHERE locktype = 'advisory';
SELECT
	pg_advisory_lock(1), pg_advisory_lock(1),
	pg_advisory_lock_shared(2), pg_advisory_lock_shared(2),
	pg_advisory_lock(1, 1), pg_advisory_lock(1, 1),
	pg_advisory_lock_shared(2, 2), pg_advisory_lock_shared(2, 2);
SELECT locktype, classid, objid, objsubid, mode, granted
	FROM pg_locks WHERE locktype = 'advisory'
	ORDER BY classid, objid, objsubid;
SELECT
	pg_advisory_unlock(1), pg_advisory_unlock(1),
	pg_advisory_unlock_shared(2), pg_advisory_unlock_shared(2),
	pg_advisory_unlock(1, 1), pg_advisory_unlock(1, 1),
	pg_advisory_unlock_shared(2, 2), pg_advisory_unlock_shared(2, 2);
SELECT count(*) FROM pg_locks WHERE locktype = 'advisory';
SELECT
	pg_advisory_lock(1), pg_advisory_lock(1),
	pg_advisory_lock_shared(2), pg_advisory_lock_shared(2),
	pg_advisory_lock(1, 1), pg_advisory_lock(1, 1),
	pg_advisory_lock_shared(2, 2), pg_advisory_lock_shared(2, 2);
SELECT locktype, classid, objid, objsubid, mode, granted
	FROM pg_locks WHERE locktype = 'advisory'
	ORDER BY classid, objid, objsubid;
SELECT pg_advisory_unlock_all();
SELECT count(*) FROM pg_locks WHERE locktype = 'advisory';


--
-- AGGREGATES
--

SELECT avg(four) AS avg_1 FROM onek;
SELECT avg(a) AS avg_32 FROM aggtest WHERE a < 100;
SELECT avg(b)::numeric(10,3) AS avg_107_943 FROM aggtest;
SELECT avg(gpa) AS avg_3_4 FROM ONLY student;
SELECT sum(four) AS sum_1500 FROM onek;
SELECT sum(a) AS sum_198 FROM aggtest;
SELECT sum(b) AS avg_431_773 FROM aggtest;
SELECT sum(gpa) AS avg_6_8 FROM ONLY student;
SELECT max(four) AS max_3 FROM onek;
SELECT max(a) AS max_100 FROM aggtest;
SELECT max(aggtest.b) AS max_324_78 FROM aggtest;
SELECT max(student.gpa) AS max_3_7 FROM student;
SELECT stddev_pop(b) FROM aggtest;
SELECT stddev_samp(b) FROM aggtest;
SELECT var_pop(b) FROM aggtest;
SELECT var_samp(b) FROM aggtest;
SELECT stddev_pop(b::numeric) FROM aggtest;
SELECT stddev_samp(b::numeric) FROM aggtest;
SELECT var_pop(b::numeric) FROM aggtest;
SELECT var_samp(b::numeric) FROM aggtest;
SELECT var_pop(1.0), var_samp(2.0);
SELECT stddev_pop(3.0::numeric), stddev_samp(4.0::numeric);
select sum(null::int4) from generate_series(1,3);
select sum(null::int8) from generate_series(1,3);
select sum(null::numeric) from generate_series(1,3);
select sum(null::float8) from generate_series(1,3);
select avg(null::int4) from generate_series(1,3);
select avg(null::int8) from generate_series(1,3);
select avg(null::numeric) from generate_series(1,3);
select avg(null::float8) from generate_series(1,3);
select sum('NaN'::numeric) from generate_series(1,3);
select avg('NaN'::numeric) from generate_series(1,3);
SELECT regr_count(b, a) FROM aggtest;
SELECT regr_sxx(b, a) FROM aggtest;
SELECT regr_syy(b, a) FROM aggtest;
SELECT regr_sxy(b, a) FROM aggtest;
SELECT regr_avgx(b, a), regr_avgy(b, a) FROM aggtest;
SELECT regr_r2(b, a) FROM aggtest;
SELECT regr_slope(b, a), regr_intercept(b, a) FROM aggtest;
SELECT covar_pop(b, a), covar_samp(b, a) FROM aggtest;
SELECT corr(b, a) FROM aggtest;
SELECT count(four) AS cnt_1000 FROM onek;
SELECT count(DISTINCT four) AS cnt_4 FROM onek;
select ten, count(*), sum(four) from onek
  group by ten order by ten;
select ten, count(four), sum(DISTINCT four) from onek
  group by ten order by ten;
SELECT newavg(four) AS avg_1 FROM onek;
SELECT newsum(four) AS sum_1500 FROM onek;
SELECT newcnt(four) AS cnt_1000 FROM onek;
SELECT newcnt(*) AS cnt_1000 FROM onek;
SELECT oldcnt(*) AS cnt_1000 FROM onek;
SELECT sum2(q1,q2) FROM int8_tbl;
select ten, sum(distinct four) from onek a
  group by ten
  having exists (select 1 from onek b where sum(distinct a.four) = b.four);
select ten, sum(distinct four) from onek a
  group by ten
  having exists (select 1 from onek b
               where sum(distinct a.four + b.four) = b.four);

select
  (select max((select i.unique2 from tenk1 i where i.unique1 = o.unique1)))
  from tenk1 o;

select s1, s2, sm
  from generate_series(1, 3) s1,
     lateral (select s2, sum(s1 + s2) sm
              from generate_series(1, 3) s2 group by s2) ss
  order by 1, 2;
select s1, s2, sm
  from generate_series(1, 3) s1,
     lateral (select s2, sum(s1 + s2) sm
              from generate_series(1, 3) s2 group by s2) ss
  order by 1, 2;

select array(select sum(x+y) s
            from generate_series(1,3) y group by y order by s)
  from generate_series(1,3) x;
select array(select sum(x+y) s
            from generate_series(1,3) y group by y order by s)
  from generate_series(1,3) x;
-- empty case
SELECT
  BIT_AND(i2) AS "?",
  BIT_OR(i4)  AS "?"
  FROM bitwise_test;

SELECT
  BIT_AND(i2) AS "1",
  BIT_AND(i4) AS "1",
  BIT_AND(i8) AS "1",
  BIT_AND(i)  AS "?",
  BIT_AND(x)  AS "0",
  BIT_AND(y)  AS "0100",

  BIT_OR(i2)  AS "7",
  BIT_OR(i4)  AS "7",
  BIT_OR(i8)  AS "7",
  BIT_OR(i)   AS "?",
  BIT_OR(x)   AS "7",
  BIT_OR(y)   AS "1101"
  FROM bitwise_test;

SELECT
  -- boolean and transitions
  -- null because strict
  booland_statefunc(NULL, NULL)  IS NULL AS "t",
  booland_statefunc(TRUE, NULL)  IS NULL AS "t",
  booland_statefunc(FALSE, NULL) IS NULL AS "t",
  booland_statefunc(NULL, TRUE)  IS NULL AS "t",
  booland_statefunc(NULL, FALSE) IS NULL AS "t",
  -- and actual computations
  booland_statefunc(TRUE, TRUE) AS "t",
  NOT booland_statefunc(TRUE, FALSE) AS "t",
  NOT booland_statefunc(FALSE, TRUE) AS "t",
  NOT booland_statefunc(FALSE, FALSE) AS "t";

SELECT
  -- boolean or transitions
  -- null because strict
  boolor_statefunc(NULL, NULL)  IS NULL AS "t",
  boolor_statefunc(TRUE, NULL)  IS NULL AS "t",
  boolor_statefunc(FALSE, NULL) IS NULL AS "t",
  boolor_statefunc(NULL, TRUE)  IS NULL AS "t",
  boolor_statefunc(NULL, FALSE) IS NULL AS "t",
  -- actual computations
  boolor_statefunc(TRUE, TRUE) AS "t",
  boolor_statefunc(TRUE, FALSE) AS "t",
  boolor_statefunc(FALSE, TRUE) AS "t",
  NOT boolor_statefunc(FALSE, FALSE) AS "t";

SELECT
  BOOL_AND(b1)   AS "n",
  BOOL_OR(b3)    AS "n"
  FROM bool_test;

SELECT
  BOOL_AND(b1)     AS "f",
  BOOL_AND(b2)     AS "t",
  BOOL_AND(b3)     AS "f",
  BOOL_AND(b4)     AS "n",
  BOOL_AND(NOT b2) AS "f",
  BOOL_AND(NOT b3) AS "t"
  FROM bool_test;

SELECT
  EVERY(b1)     AS "f",
  EVERY(b2)     AS "t",
  EVERY(b3)     AS "f",
  EVERY(b4)     AS "n",
  EVERY(NOT b2) AS "f",
  EVERY(NOT b3) AS "t"
  FROM bool_test;

SELECT
  BOOL_OR(b1)      AS "t",
  BOOL_OR(b2)      AS "t",
  BOOL_OR(b3)      AS "f",
  BOOL_OR(b4)      AS "n",
  BOOL_OR(NOT b2)  AS "f",
  BOOL_OR(NOT b3)  AS "t"
  FROM bool_test;

select min(unique1) from tenk1;
select min(unique1) from tenk1;
select max(unique1) from tenk1;
select max(unique1) from tenk1;
select max(unique1) from tenk1 where unique1 < 42;
select max(unique1) from tenk1 where unique1 < 42;
select max(unique1) from tenk1 where unique1 > 42;
select max(unique1) from tenk1 where unique1 > 42;

select max(unique1) from tenk1 where unique1 > 42000;
select max(unique1) from tenk1 where unique1 > 42000;

select max(tenthous) from tenk1 where thousand = 33;
select max(tenthous) from tenk1 where thousand = 33;
select min(tenthous) from tenk1 where thousand = 33;
select min(tenthous) from tenk1 where thousand = 33;

select f1, (select min(unique1) from tenk1 where unique1 > f1) AS gt
    from int4_tbl;
select f1, (select min(unique1) from tenk1 where unique1 > f1) AS gt
  from int4_tbl;

select distinct max(unique2) from tenk1;
select distinct max(unique2) from tenk1;
select max(unique2) from tenk1 order by 1;
select max(unique2) from tenk1 order by 1;
select max(unique2) from tenk1 order by max(unique2);
select max(unique2) from tenk1 order by max(unique2);
select max(unique2) from tenk1 order by max(unique2)+1;
select max(unique2) from tenk1 order by max(unique2)+1;
select max(unique2), generate_series(1,3) as g from tenk1 order by g desc;
select max(unique2), generate_series(1,3) as g from tenk1 order by g desc;

select min(f1), max(f1) from minmaxtest;
select min(f1), max(f1) from minmaxtest;

select distinct min(f1), max(f1) from minmaxtest;
select distinct min(f1), max(f1) from minmaxtest;

-- check for correct detection of nested-aggregate errors
select max(min(unique1)) from tenk1;
select (select max(min(unique1)) from int8_tbl) from tenk1;

select * from t1 group by a,b,c,d;

select a,c from t1 group by a,c,d;

select t1.*,t2.x,t2.z
  from t1 inner join t2 on t1.a = t2.x and t1.b = t2.y
  group by t1.a,t1.b,t1.c,t1.d,t2.x,t2.z;

select array_agg(a order by b)
 from (
     values
     (1,4),
 (2,3),(3,1),(4,2)) v(a,b);
select array_agg(a order by a)
   from (values (1,4),(2,3),(3,1),(4,2)) v(a,b);
select array_agg(a order by a desc)
  from (values (1,4),(2,3),(3,1),(4,2)) v(a,b);
select array_agg(b order by a desc)
  from (values (1,4),(2,3),(3,1),(4,2)) v(a,b);

select array_agg(distinct a)
  from (values (1),(2),(1),(3),(null),(2)) v(a);
select array_agg(distinct a order by a)
  from (values (1),(2),(1),(3),(null),(2)) v(a);
select array_agg(distinct a order by a desc)
  from (values (1),(2),(1),(3),(null),(2)) v(a);
select array_agg(distinct a order by a desc nulls last)
  from (values (1),(2),(1),(3),(null),(2)) v(a);

select aggfstr(a,b,c)
  from (values (1,3,'foo'),(0,null,null),(2,2,'bar'),(3,1,'baz')) v(a,b,c);
select aggfns(a,b,c)
  from (values (1,3,'foo'),(0,null,null),(2,2,'bar'),(3,1,'baz')) v(a,b,c);

select aggfstr(distinct a,b,c)
  from (values (1,3,'foo'),(0,null,null),(2,2,'bar'),(3,1,'baz')) v(a,b,c),
       generate_series(1,3) i;
select aggfns(distinct a,b,c)
  from (values (1,3,'foo'),(0,null,null),(2,2,'bar'),(3,1,'baz')) v(a,b,c),
       generate_series(1,3) i;

select aggfstr(distinct a,b,c order by b)
  from (values (1,3,'foo'),(0,null,null),(2,2,'bar'),(3,1,'baz')) v(a,b,c),
       generate_series(1,3) i;
select aggfns(distinct a,b,c order by b)
  from (values (1,3,'foo'),(0,null,null),(2,2,'bar'),(3,1,'baz')) v(a,b,c),
       generate_series(1,3) i;

-- select aggfns(distinct a,a,c order by c using ~<~,a)
--   from (values (1,3,'foo'),(0,null,null),(2,2,'bar'),(3,1,'baz')) v(a,b,c),
--        generate_series(1,2) i;
-- select aggfns(distinct a,a,c order by c using ~<~)
--   from (values (1,3,'foo'),(0,null,null),(2,2,'bar'),(3,1,'baz')) v(a,b,c),
--        generate_series(1,2) i;
-- select aggfns(distinct a,a,c order by a)
--   from (values (1,3,'foo'),(0,null,null),(2,2,'bar'),(3,1,'baz')) v(a,b,c),
--        generate_series(1,2) i;
-- select aggfns(distinct a,b,c order by a,c using ~<~,b)
--   from (values (1,3,'foo'),(0,null,null),(2,2,'bar'),(3,1,'baz')) v(a,b,c),
--        generate_series(1,2) i;

select aggfns(a,b,c)
    from (values (1,3,'foo'),(0,null,null),(2,2,'bar'),(3,1,'baz')) v(a,b,c);

select * from agg_view1;
select pg_get_viewdef('agg_view1'::regclass);

select aggfns(distinct a,b,c)
    from (values (1,3,'foo'),(0,null,null),(2,2,'bar'),(3,1,'baz')) v(a,b,c),
         generate_series(1,3) i;

select * from agg_view1;
select pg_get_viewdef('agg_view1'::regclass);

select aggfns(distinct a,b,c order by b)
    from (values (1,3,'foo'),(0,null,null),(2,2,'bar'),(3,1,'baz')) v(a,b,c),
         generate_series(1,3) i;

select * from agg_view1;
select pg_get_viewdef('agg_view1'::regclass);

select aggfns(a,b,c order by b+1)
    from (values (1,3,'foo'),(0,null,null),(2,2,'bar'),(3,1,'baz')) v(a,b,c);

select * from agg_view1;
select pg_get_viewdef('agg_view1'::regclass);

select aggfns(a,a,c order by b)
    from (values (1,3,'foo'),(0,null,null),(2,2,'bar'),(3,1,'baz')) v(a,b,c);

select * from agg_view1;
select pg_get_viewdef('agg_view1'::regclass);

-- select aggfns(a,b,c order by c using ~<~)
--     from (values (1,3,'foo'),(0,null,null),(2,2,'bar'),(3,1,'baz')) v(a,b,c);

select * from agg_view1;
select pg_get_viewdef('agg_view1'::regclass);

-- select aggfns(distinct a,b,c order by a,c using ~<~,b)
--     from (values (1,3,'foo'),(0,null,null),(2,2,'bar'),(3,1,'baz')) v(a,b,c),
--          generate_series(1,2) i;

select * from agg_view1;
select pg_get_viewdef('agg_view1'::regclass);

select aggfns(distinct a,b,c order by i)
  from (values (1,1,'foo')) v(a,b,c), generate_series(1,2) i;
select aggfns(distinct a,b,c order by a,b+1)
  from (values (1,1,'foo')) v(a,b,c), generate_series(1,2) i;
select aggfns(distinct a,b,c order by a,b,i,c)
  from (values (1,1,'foo')) v(a,b,c), generate_series(1,2) i;
select aggfns(distinct a,a,c order by a,b)
  from (values (1,1,'foo')) v(a,b,c), generate_series(1,2) i;

select string_agg(a,',') from (values('aaaa'),('bbbb'),('cccc')) g(a);
select string_agg(a,',') from (values('aaaa'),(null),('bbbb'),('cccc')) g(a);
select string_agg(a,'AB') from (values(null),(null),('bbbb'),('cccc')) g(a);
select string_agg(a,',') from (values(null),(null)) g(a);

-- check some implicit casting cases, as per bug #5564
select string_agg(distinct f1, ',' order by f1) from varchar_tbl;  -- ok
select string_agg(distinct f1::text, ',' order by f1) from varchar_tbl;  -- not ok
select string_agg(distinct f1, ',' order by f1::text) from varchar_tbl;  -- not ok
select string_agg(distinct f1::text, ',' order by f1::text) from varchar_tbl;  -- ok

select string_agg(v, '') from bytea_test_table;
select string_agg(v, '') from bytea_test_table;
select string_agg(v, '') from bytea_test_table;
select string_agg(v, NULL) from bytea_test_table;
select string_agg(v, decode('ee', 'hex')) from bytea_test_table;
select min(unique1) filter (where unique1 > 100) from tenk1;
select sum(1/ten) filter (where ten > 0) from tenk1;
select ten, sum(distinct four) filter (where four::text ~ '123') from onek a
  group by ten;

select ten, sum(distinct four) filter (where four > 10) from onek a
  group by ten
  having exists (select 1 from onek b where sum(distinct a.four) = b.four);

select max(foo COLLATE "C") filter (where (bar collate "POSIX") > '0')
  from (values ('a', 'b')) AS v(foo,bar);

select (select count(*)
        from (values (1)) t0(inner_c))
  from (values (2),(3)) t1(outer_c); -- inner query is aggregation query
select (select count(*) filter (where outer_c <> 0)
        from (values (1)) t0(inner_c))
  from (values (2),(3)) t1(outer_c); -- outer query is aggregation query
select (select count(inner_c) filter (where outer_c <> 0)
        from (values (1)) t0(inner_c))
  from (values (2),(3)) t1(outer_c); -- inner query is aggregation query
select
  (select max((select i.unique2 from tenk1 i where i.unique1 = o.unique1))
     filter (where o.unique1 < 10))
  from tenk1 o;					-- outer query is aggregation query

select sum(unique1) FILTER (WHERE
  unique1 IN (SELECT unique1 FROM onek where unique1 < 100)) FROM tenk1;
-- select aggfns(distinct a,b,c order by a,c using ~<~,b) filter (where a > 1)
--     from (values (1,3,'foo'),(0,null,null),(2,2,'bar'),(3,1,'baz')) v(a,b,c),
--     generate_series(1,2) i;
select p, percentile_cont(p) within group (order by x::float8)
  from generate_series(1,5) x,
     (values (0::float8),(0.1),(0.25),(0.4),(0.5),(0.6),(0.75),(0.9),(1)) v(p)
  group by p order by p;


select percentile_cont(0.5) within group (order by b) from aggtest;
select percentile_cont(0.5) within group (order by b), sum(b) from aggtest;
select percentile_cont(0.5) within group (order by thousand) from tenk1;
select percentile_disc(0.5) within group (order by thousand) from tenk1;
select rank(3) within group (order by x)
  from (values (1),(1),(2),(2),(3),(3),(4)) v(x);
select cume_dist(3) within group (order by x)
  from (values (1),(1),(2),(2),(3),(3),(4)) v(x);
select percent_rank(3) within group (order by x)
  from (values (1),(1),(2),(2),(3),(3),(4),(5)) v(x);
select dense_rank(3) within group (order by x)
  from (values (1),(1),(2),(2),(3),(3),(4)) v(x);

--#UNSUPPORTED ARRAYS
-- select percentile_disc(array[0,0.1,0.25,0.5,0.75,0.9,1]) within group (order by thousand)
--   from tenk1;
-- select percentile_cont(array[0,0.25,0.5,0.75,1]) within group (order by thousand)
--   from tenk1;
-- select percentile_disc(array[[null,1,0.5],[0.75,0.25,null]]) within group (order by thousand)
--   from tenk1;
-- select percentile_cont(array[0,1,0.25,0.75,0.5,1,0.3,0.32,0.35,0.38,0.4]) within group (order by x)
--   from generate_series(1,6) x;
-- select percentile_disc(array[0.25,0.5,0.75]) within group (order by x)
--   from unnest('{fred,jim,fred,jack,jill,fred,jill,jim,jim,sheila,jim,sheila}'::text[]) u(x);

select ten, mode() within group (order by string4) from tenk1 group by ten;

-- select pg_collation_for(percentile_disc(1) within group (order by x collate "POSIX"))
--   from (values ('fred'),('jim')) v(x);

select test_rank(3) within group (order by x)
  from (values (1),(1),(2),(2),(3),(3),(4)) v(x);
select test_percentile_disc(0.5) within group (order by thousand) from tenk1;
select rank(x) within group (order by x) from generate_series(1,5) x;
select array(select percentile_disc(a) within group (order by x)
               from (values (0.3),(0.7)) v(a) group by a)
  from generate_series(1,5) g(x);
select rank(sum(x)) within group (order by x) from generate_series(1,5) x;
select rank(3) within group (order by x) from (values ('fred'),('jim')) v(x);
select rank(3) within group (order by stringu1,stringu2) from tenk1;
select rank('fred') within group (order by x) from generate_series(1,5) x;
select rank('adam'::text collate "C") within group (order by x collate "POSIX")
  from (values ('fred'),('jim')) v(x);
select rank('adam'::varchar) within group (order by x) from (values ('fred'),('jim')) v(x);
select rank('3') within group (order by x) from generate_series(1,5) x;

select percent_rank(0) within group (order by x) from generate_series(1,0) x;
select ten,
       percentile_disc(0.5) within group (order by thousand) as p50,
       percentile_disc(0.5) within group (order by thousand) filter (where hundred=1) as px,
       rank(5,'AZZZZ',50) within group (order by hundred, string4 desc, hundred)
  from tenk1
  group by ten order by ten;

select pg_get_viewdef('aggordview1');
select * from aggordview1 order by ten;
select least_agg(q1,q2) from int8_tbl;
-- select least_agg(variadic array[q1,q2]) from int8_tbl;

select my_avg(one),my_avg(one) from (values(1),(3)) t(one);
select my_avg(one),my_sum(one) from (values(1),(3)) t(one);
select my_avg(distinct one),my_sum(distinct one) from (values(1),(3),(1)) t(one);

select my_avg(distinct one),my_sum(one) from (values(1),(3)) t(one);
select my_avg(one) filter (where one > 1),my_sum(one) from (values(1),(3)) t(one);
select my_avg(one),my_sum(two) from (values(1,2),(3,4)) t(one,two);
select
  percentile_cont(0.5) within group (order by a),
  percentile_disc(0.5) within group (order by a)
  from (values(1::float8),(3),(5),(7)) t(a);
select
  percentile_cont(0.25) within group (order by a),
  percentile_disc(0.5) within group (order by a)
  from (values(1::float8),(3),(5),(7)) t(a);
select
  rank(4) within group (order by a),
  dense_rank(4) within group (order by a)
  from (values(1),(3),(5),(7)) t(a);
select my_sum_init(one),my_avg_init(one) from (values(1),(3)) t(one);
select my_sum_init(one),my_avg_init2(one) from (values(1),(3)) t(one);
select my_sum(one),my_half_sum(one) from (values(1),(2),(3),(4)) t(one);



--
-- CASE
-- Test the case statement
--

SELECT '3' AS "One",
  CASE
    WHEN 1 < 2 THEN 3
  END AS "Simple WHEN";

SELECT '<NULL>' AS "One",
  CASE
    WHEN 1 > 2 THEN 3
  END AS "Simple default";

SELECT '3' AS "One",
  CASE
    WHEN 1 < 2 THEN 3
    ELSE 4
  END AS "Simple ELSE";

SELECT '4' AS "One",
  CASE
    WHEN 1 > 2 THEN 3
    ELSE 4
  END AS "ELSE default";
SELECT '6' AS "One",
  CASE
    WHEN 1 > 2 THEN 3
    WHEN 4 < 5 THEN 6
    ELSE 7
  END AS "Two WHEN with default";
SELECT '7' AS "None",
   CASE WHEN random() < 0 THEN 1
   END AS "NULL on no matches";
SELECT CASE WHEN 1=0 THEN 1/0 WHEN 1=1 THEN 1 ELSE 2/0 END;
SELECT CASE 1 WHEN 0 THEN 1/0 WHEN 1 THEN 1 ELSE 2/0 END;
SELECT CASE WHEN i > 100 THEN 1/0 ELSE 0 END FROM case_tbl;
SELECT CASE 'a' WHEN 'a' THEN 1 ELSE 2 END;
SELECT '' AS "Five",
  CASE
    WHEN i >= 3 THEN i
  END AS ">= 3 or Null"
  FROM CASE_TBL;

SELECT '' AS "Five",
  CASE WHEN i >= 3 THEN (i + i)
       ELSE i
  END AS "Simplest Math"
  FROM CASE_TBL;

SELECT '' AS "Five", i AS "Value",
  CASE WHEN (i < 0) THEN 'small'
       WHEN (i = 0) THEN 'zero'
       WHEN (i = 1) THEN 'one'
       WHEN (i = 2) THEN 'two'
       ELSE 'big'
  END AS "Category"
  FROM CASE_TBL;
SELECT '' AS "Five",
  CASE WHEN ((i < 0) or (i < 0)) THEN 'small'
       WHEN ((i = 0) or (i = 0)) THEN 'zero'
       WHEN ((i = 1) or (i = 1)) THEN 'one'
       WHEN ((i = 2) or (i = 2)) THEN 'two'
       ELSE 'big'
  END AS "Category"
  FROM CASE_TBL;
SELECT * FROM CASE_TBL WHERE COALESCE(f,i) = 4;
SELECT * FROM CASE_TBL WHERE NULLIF(f,i) = 2;
SELECT COALESCE(a.f, b.i, b.j)
  FROM CASE_TBL a, CASE2_TBL b;
SELECT *
  FROM CASE_TBL a, CASE2_TBL b
  WHERE COALESCE(a.f, b.i, b.j) = 2;
SELECT '' AS Five, NULLIF(a.i,b.i) AS "NULLIF(a.i,b.i)",
  NULLIF(b.i, 4) AS "NULLIF(b.i,4)"
  FROM CASE_TBL a, CASE2_TBL b;
SELECT '' AS "Two", *
  FROM CASE_TBL a, CASE2_TBL b
  WHERE COALESCE(f,b.i) = 2;
SELECT * FROM CASE_TBL;
SELECT * FROM CASE_TBL;
SELECT * FROM CASE_TBL;
SELECT CASE
  (CASE vol('bar')
    WHEN 'foo' THEN 'it was foo!'
    WHEN vol(null) THEN 'null input'
    WHEN 'bar' THEN 'it was bar!' END
  )
  WHEN 'it was foo!' THEN 'foo recognized'
  WHEN 'it was bar!' THEN 'bar recognized'
  ELSE 'unrecognized' END;
SELECT CASE volfoo('bar') WHEN 'foo'::foodomain THEN 'is foo' ELSE 'is not foo' END;
-- SELECT CASE make_ad(1,2)
--   WHEN array[2,4]::arrdomain THEN 'wrong'
--   WHEN array[2,5]::arrdomain THEN 'still wrong'
--   WHEN array[1,2]::arrdomain THEN 'right'
-- END;


--
-- SELECT
--

SELECT * FROM onek
   WHERE onek.unique1 < 10
   ORDER BY onek.unique1;
SELECT onek.unique1, onek.stringu1 FROM onek
   WHERE onek.unique1 < 20
   ORDER BY unique1 using >;
SELECT onek.unique1, onek.stringu1 FROM onek
   WHERE onek.unique1 > 980
   ORDER BY stringu1 using <;
SELECT onek.unique1, onek.string4 FROM onek
   WHERE onek.unique1 > 980
   ORDER BY string4 using <, unique1 using >;
SELECT onek.unique1, onek.string4 FROM onek
   WHERE onek.unique1 > 980
   ORDER BY string4 using >, unique1 using <;
SELECT onek.unique1, onek.string4 FROM onek
   WHERE onek.unique1 < 20
   ORDER BY unique1 using >, string4 using <;
SELECT onek.unique1, onek.string4 FROM onek
   WHERE onek.unique1 < 20
   ORDER BY unique1 using <, string4 using >;
SELECT onek2.* FROM onek2 WHERE onek2.unique1 < 10;
SELECT onek2.unique1, onek2.stringu1 FROM onek2
    WHERE onek2.unique1 < 20
    ORDER BY unique1 using >;
SELECT onek2.unique1, onek2.stringu1 FROM onek2
   WHERE onek2.unique1 > 980;
select foo from (select 1) as foo;
select foo from (select null) as foo;
select foo from (select 'xyzzy',1,null) as foo;
select * from onek, (values(147, 'RFAAAA'), (931, 'VJAAAA')) as v (i, j)
    WHERE onek.unique1 = v.i and onek.stringu1 = v.j;
select * from onek,
  (values ((select i from
    (values(10000), (2), (389), (1000), (2000), ((select 10029))) as foo(i)
    order by i asc limit 1))) bar (i)
  where onek.unique1 = bar.i;
select * from onek
    where (unique1,ten) in (values (1,1), (20,0), (99,9), (17,99))
    order by unique1;
VALUES (1,2), (3,4+4), (7,77.7);
VALUES (1,2), (3,4+4), (7,77.7)
  UNION ALL
  SELECT 2+2, 57
  UNION ALL
  TABLE int8_tbl;
SELECT * FROM foo ORDER BY f1;
SELECT * FROM foo ORDER BY f1 ASC;	-- same thing
SELECT * FROM foo ORDER BY f1 NULLS FIRST;
SELECT * FROM foo ORDER BY f1 DESC;
SELECT * FROM foo ORDER BY f1 DESC NULLS LAST;
SELECT * FROM foo ORDER BY f1;
SELECT * FROM foo ORDER BY f1 NULLS FIRST;
SELECT * FROM foo ORDER BY f1 DESC;
SELECT * FROM foo ORDER BY f1 DESC NULLS LAST;

SELECT * FROM foo ORDER BY f1;
SELECT * FROM foo ORDER BY f1 NULLS FIRST;
SELECT * FROM foo ORDER BY f1 DESC;
SELECT * FROM foo ORDER BY f1 DESC NULLS LAST;
SELECT * FROM foo ORDER BY f1;
SELECT * FROM foo ORDER BY f1 NULLS FIRST;
SELECT * FROM foo ORDER BY f1 DESC;
SELECT * FROM foo ORDER BY f1 DESC NULLS LAST;
select * from onek2 where unique2 = 11 and stringu1 = 'ATAAAA';
select * from onek2 where unique2 = 11 and stringu1 = 'ATAAAA';
select * from onek2 where unique2 = 11 and stringu1 = 'ATAAAA';
select unique2 from onek2 where unique2 = 11 and stringu1 = 'ATAAAA';
select unique2 from onek2 where unique2 = 11 and stringu1 = 'ATAAAA';
select * from onek2 where unique2 = 11 and stringu1 < 'B';
select * from onek2 where unique2 = 11 and stringu1 < 'B';
select unique2 from onek2 where unique2 = 11 and stringu1 < 'B';
select unique2 from onek2 where unique2 = 11 and stringu1 < 'B';
-- select unique2 from onek2 where unique2 = 11 and stringu1 < 'B' for update;
-- select unique2 from onek2 where unique2 = 11 and stringu1 < 'B' for update;
select unique2 from onek2 where unique2 = 11 and stringu1 < 'C';
select unique2 from onek2 where unique2 = 11 and stringu1 < 'C';
select unique2 from onek2 where unique2 = 11 and stringu1 < 'B';
select unique2 from onek2 where unique2 = 11 and stringu1 < 'B';
select unique1, unique2 from onek2
  where (unique2 = 11 or unique1 = 0) and stringu1 < 'B';
select unique1, unique2 from onek2
  where (unique2 = 11 or unique1 = 0) and stringu1 < 'B';
select unique1, unique2 from onek2
  where (unique2 = 11 and stringu1 < 'B') or unique1 = 0;
select unique1, unique2 from onek2
  where (unique2 = 11 and stringu1 < 'B') or unique1 = 0;
SELECT 1 AS x ORDER BY x;
select sillysrf(42);
select sillysrf(-1) order by 1;
select * from (values (2),(null),(1)) v(k) where k = k order by k;
select * from (values (2),(null),(1)) v(k) where k = k;


SELECT DISTINCT two FROM tmp ORDER BY 1;
SELECT DISTINCT ten FROM tmp ORDER BY 1;
SELECT DISTINCT string4 FROM tmp ORDER BY 1;
SELECT DISTINCT two, string4, ten
   FROM tmp
   ORDER BY two using <, string4 using <, ten using <;
SELECT count(*) FROM
  (SELECT DISTINCT two, four, two FROM tenk1) ss;
SELECT count(*) FROM
  (SELECT DISTINCT two, four, two FROM tenk1) ss;
SELECT f1, f1 IS DISTINCT FROM 2 as "not 2" FROM disttable;
SELECT f1, f1 IS DISTINCT FROM NULL as "not null" FROM disttable;
SELECT f1, f1 IS DISTINCT FROM f1 as "false" FROM disttable;
SELECT f1, f1 IS DISTINCT FROM f1+1 as "not null" FROM disttable;
SELECT 1 IS DISTINCT FROM 2 as "yes";
SELECT 2 IS DISTINCT FROM 2 as "no";
SELECT 2 IS DISTINCT FROM null as "yes";
SELECT null IS DISTINCT FROM null as "no";
SELECT 1 IS NOT DISTINCT FROM 2 as "no";
SELECT 2 IS NOT DISTINCT FROM 2 as "yes";
SELECT 2 IS NOT DISTINCT FROM null as "no";
SELECT null IS NOT DISTINCT FROM null as "yes";

SELECT DISTINCT ON (string4) string4, two, ten
   FROM tmp
   ORDER BY string4 using <, two using >, ten using <;
SELECT DISTINCT ON (string4, ten) string4, two, ten
   FROM tmp
   ORDER BY string4 using <, two using <, ten using <;
SELECT DISTINCT ON (string4, ten) string4, ten, two
   FROM tmp
   ORDER BY string4 using <, ten using >, two using <;
select distinct on (1) floor(random()) as r, f1 from int4_tbl order by 1,2;


SELECT b, c FROM test_having
	GROUP BY b, c HAVING count(*) = 1 ORDER BY b, c;
SELECT b, c FROM test_having
	GROUP BY b, c HAVING b = 3 ORDER BY b, c;
SELECT lower(c), count(c) FROM test_having
	GROUP BY lower(c) HAVING count(*) > 2 OR min(a) = max(a)
	ORDER BY lower(c);
SELECT c, max(a) FROM test_having
	GROUP BY c HAVING count(*) > 2 OR min(a) = max(a)
	ORDER BY c;
SELECT min(a), max(a) FROM test_having HAVING min(a) = max(a);
SELECT min(a), max(a) FROM test_having HAVING min(a) < max(a);
SELECT a FROM test_having HAVING min(a) < max(a);
SELECT 1 AS one FROM test_having HAVING a > 1;
SELECT 1 AS one FROM test_having HAVING 1 > 2;
SELECT 1 AS one FROM test_having HAVING 1 < 2;
SELECT 1 AS one FROM test_having WHERE 1/a = 1 HAVING 1 < 2;


SELECT c, count(*) FROM test_missing_target GROUP BY test_missing_target.c ORDER BY c;
SELECT count(*) FROM test_missing_target GROUP BY test_missing_target.c ORDER BY c;
SELECT count(*) FROM test_missing_target GROUP BY a ORDER BY b;
SELECT count(*) FROM test_missing_target GROUP BY b ORDER BY b;
SELECT test_missing_target.b, count(*)
  FROM test_missing_target GROUP BY b ORDER BY b;
SELECT c FROM test_missing_target ORDER BY a;
SELECT count(*) FROM test_missing_target GROUP BY b ORDER BY b desc;
SELECT count(*) FROM test_missing_target ORDER BY 1 desc;
SELECT c, count(*) FROM test_missing_target GROUP BY 1 ORDER BY 1;
SELECT c, count(*) FROM test_missing_target GROUP BY 3;
SELECT count(*) FROM test_missing_target x, test_missing_target y
	WHERE x.a = y.a
	GROUP BY b ORDER BY b;
SELECT a, a FROM test_missing_target
	ORDER BY a;
SELECT a/2, a/2 FROM test_missing_target
	ORDER BY a/2;
SELECT a/2, a/2 FROM test_missing_target
	GROUP BY a/2 ORDER BY a/2;
SELECT x.b, count(*) FROM test_missing_target x, test_missing_target y
	WHERE x.a = y.a
	GROUP BY x.b ORDER BY x.b;
SELECT count(*) FROM test_missing_target x, test_missing_target y
	WHERE x.a = y.a
	GROUP BY x.b ORDER BY x.b;
SELECT * FROM test_missing_target2;
SELECT a%2, count(b) FROM test_missing_target
  GROUP BY test_missing_target.a%2
  ORDER BY test_missing_target.a%2;
SELECT count(c) FROM test_missing_target
GROUP BY lower(test_missing_target.c)
ORDER BY lower(test_missing_target.c);
SELECT count(a) FROM test_missing_target GROUP BY a ORDER BY b;
SELECT count(b) FROM test_missing_target GROUP BY b/2 ORDER BY b/2;
SELECT lower(test_missing_target.c), count(c)
  FROM test_missing_target GROUP BY lower(c) ORDER BY lower(c);
SELECT a FROM test_missing_target ORDER BY upper(d);
SELECT count(b) FROM test_missing_target
	GROUP BY (b + 1) / 2 ORDER BY (b + 1) / 2 desc;
SELECT count(x.a) FROM test_missing_target x, test_missing_target y
	WHERE x.a = y.a
	GROUP BY b/2 ORDER BY b/2;
SELECT x.b/2, count(x.b) FROM test_missing_target x, test_missing_target y
	WHERE x.a = y.a
	GROUP BY x.b/2 ORDER BY x.b/2;
SELECT count(b) FROM test_missing_target x, test_missing_target y
	WHERE x.a = y.a
	GROUP BY x.b/2;
SELECT * FROM test_missing_target3;


--
-- SUBSELECT
--

SELECT 1 AS one WHERE 1 IN (SELECT 1);

SELECT 1 AS zero WHERE 1 NOT IN (SELECT 1);

SELECT 1 AS zero WHERE 1 IN (SELECT 2);

SELECT * FROM (SELECT 1 AS x) ss;
--#UNSUPPORTED
--SELECT * FROM ((SELECT 1 AS x)) ss;

--#UNSUPPORTED
--(SELECT 2) UNION SELECT 2;
--((SELECT 2)) UNION SELECT 2;
--SELECT ((SELECT 2) UNION SELECT 2);
--SELECT (((SELECT 2)) UNION SELECT 2);

--#UNSUPPORTED ARRAYS
--SELECT (SELECT ARRAY[1,2,3])[1];
--SELECT ((SELECT ARRAY[1,2,3]))[2];
--SELECT (((SELECT ARRAY[1,2,3])))[3];

SELECT '' AS eight, * FROM SUBSELECT_TBL;

-- Uncorrelated subselects

SELECT '' AS two, f1 AS "Constant Select" FROM SUBSELECT_TBL
  WHERE f1 IN (SELECT 1);

SELECT '' AS six, f1 AS "Uncorrelated Field" FROM SUBSELECT_TBL
  WHERE f1 IN (SELECT f2 FROM SUBSELECT_TBL);

SELECT '' AS six, f1 AS "Uncorrelated Field" FROM SUBSELECT_TBL
  WHERE f1 IN (SELECT f2 FROM SUBSELECT_TBL WHERE
    f2 IN (SELECT f1 FROM SUBSELECT_TBL));

SELECT '' AS three, f1, f2
  FROM SUBSELECT_TBL
  WHERE (f1, f2) NOT IN (SELECT f2, CAST(f3 AS int4) FROM SUBSELECT_TBL
                         WHERE f3 IS NOT NULL);

SELECT '' AS six, f1 AS "Correlated Field", f2 AS "Second Field"
  FROM SUBSELECT_TBL upper
  WHERE f1 IN (SELECT f2 FROM SUBSELECT_TBL WHERE f1 = upper.f1);

SELECT '' AS six, f1 AS "Correlated Field", f3 AS "Second Field"
  FROM SUBSELECT_TBL upper
  WHERE f1 IN
    (SELECT f2 FROM SUBSELECT_TBL WHERE CAST(upper.f2 AS float) = f3);

SELECT '' AS six, f1 AS "Correlated Field", f3 AS "Second Field"
  FROM SUBSELECT_TBL upper
  WHERE f3 IN (SELECT upper.f1 + f2 FROM SUBSELECT_TBL
               WHERE f2 = CAST(f3 AS integer));

SELECT '' AS five, f1 AS "Correlated Field"
  FROM SUBSELECT_TBL
  WHERE (f1, f2) IN (SELECT f2, CAST(f3 AS int4) FROM SUBSELECT_TBL
                     WHERE f3 IS NOT NULL);

SELECT '' AS eight, ss.f1 AS "Correlated Field", ss.f3 AS "Second Field"
  FROM SUBSELECT_TBL ss
  WHERE f1 NOT IN (SELECT f1+1 FROM INT4_TBL
                   WHERE f1 != ss.f1 AND f1 < 2147483647);

select q1, float8(count(*)) / (select count(*) from int8_tbl)
from int8_tbl group by q1 order by q1;

SELECT *, pg_typeof(f1) FROM
  (SELECT 'foo' AS f1 FROM generate_series(1,3)) ss ORDER BY 1;

--#UNSUPPORTED
-- select 1 = all (select (select 1));
-- select 1 = all (select (select 1));

select * from int4_tbl o where exists
  (select 1 from int4_tbl i where i.f1=o.f1 limit null);
select * from int4_tbl o where not exists
  (select 1 from int4_tbl i where i.f1=o.f1 limit 1);
select * from int4_tbl o where exists
  (select 1 from int4_tbl i where i.f1=o.f1 limit 0);

select count(*) from
  (select 1 from tenk1 a
   where unique1 IN (select hundred from tenk1 b)) ss;
select count(distinct ss.ten) from
  (select ten from tenk1 a
   where unique1 IN (select hundred from tenk1 b)) ss;
select count(*) from
  (select 1 from tenk1 a
   where unique1 IN (select distinct hundred from tenk1 b)) ss;
select count(distinct ss.ten) from
  (select ten from tenk1 a
   where unique1 IN (select distinct hundred from tenk1 b)) ss;

SELECT * FROM foo WHERE id IN
    (SELECT id2 FROM (SELECT DISTINCT id1, id2 FROM bar) AS s);
SELECT * FROM foo WHERE id IN
    (SELECT id2 FROM (SELECT id1,id2 FROM bar GROUP BY id1,id2) AS s);
SELECT * FROM foo WHERE id IN
    (SELECT id2 FROM (SELECT id1, id2 FROM bar UNION
                      SELECT id1, id2 FROM bar) AS s);

-- These cases do not
SELECT * FROM foo WHERE id IN
    (SELECT id2 FROM (SELECT DISTINCT ON (id2) id1, id2 FROM bar) AS s);
SELECT * FROM foo WHERE id IN
    (SELECT id2 FROM (SELECT id2 FROM bar GROUP BY id2) AS s);
SELECT * FROM foo WHERE id IN
    (SELECT id2 FROM (SELECT id2 FROM bar UNION
                      SELECT id2 FROM bar) AS s);

SELECT *,
(SELECT CASE
   WHEN ord.approver_ref=1 THEN '---' ELSE 'Approved'
 END) AS "Approved",
(SELECT CASE
 WHEN ord.ordercanceled
 THEN 'Canceled'
 ELSE
  (SELECT CASE
		WHEN ord.po_ref=1
		THEN
		 (SELECT CASE
				WHEN ord.approver_ref=1
				THEN '---'
				ELSE 'Approved'
			END)
		ELSE 'PO'
	END)
END) AS "Status",
(CASE
 WHEN ord.ordercanceled
 THEN 'Canceled'
 ELSE
  (CASE
		WHEN ord.po_ref=1
		THEN
		 (CASE
				WHEN ord.approver_ref=1
				THEN '---'
				ELSE 'Approved'
			END)
		ELSE 'PO'
	END)
END) AS "Status_OK"
FROM orderstest ord;

select * from shipped_view;

select * from shipped_view;

select f1, ss1 as relabel from
    (select *, (select sum(f1) from int4_tbl b where f1 >= a.f1) as ss1
     from int4_tbl a) ss;

select * from (
  select max(unique1) from tenk1 as a
  where exists (select 1 from tenk1 as b where b.thousand = a.unique2)
) ss;

select * from (
  select min(unique1) from tenk1 as a
  where not exists (select 1 from tenk1 as b where b.unique2 = 10000)
) ss;

select * from float_table
  where float_col in (select num_col from numeric_table);

select * from numeric_table
  where num_col in (select float_col from float_table);

select
  ( select min(tb.id) from tb
    where tb.aval = (select ta.val from ta where ta.id = tc.aid) ) as min_tb_id
from tc;

select * from
  (select distinct f1, f2, (select f2 from t1 x where x.f1 = up.f1) as fs
   from t1 up) ss
group by f1,f2,fs;

select view_a from view_a;
select (select view_a) from view_a;
select (select (select view_a)) from view_a;
select (select (a.*)::text) from view_a a;

select q from (select max(f1) from int4_tbl group by f1 order by f1) q;
with q as (select max(f1) from int4_tbl group by f1 order by f1)
  select q from q;

select
  (select sq1) as qq1
from
  (select exists(select 1 from int4_tbl where f1 = q2) as sq1, 42 as dummy
   from int8_tbl) sq0
  join
  int4_tbl i4 on dummy = i4.f1;

select * from upsert;

select * from outer_7597 where (f1, f2) not in (select * from inner_7597);

select '1'::text in (select '1'::name union all select '1'::name);

select a.thousand from tenk1 a, tenk1 b
where a.thousand = b.thousand
  and exists ( select 1 from tenk1 c where b.hundred = c.hundred
                   and not exists ( select 1 from tenk1 d
                                    where a.thousand = d.thousand ) );

  select x, x from
    (select (select now()) as x from (values(1),(2)) v(y)) ss;
  select x, x from
    (select (select random()) as x from (values(1),(2)) v(y)) ss;
  select x, x from
    (select (select now() where y=y) as x from (values(1),(2)) v(y)) ss;
  select x, x from
    (select (select random() where y=y) as x from (values(1),(2)) v(y)) ss;

select exists(select * from nocolumns);

select val.x
  from generate_series(1,10) as s(i),
  lateral (
    values ((select s.i + 1)), (s.i + 101)
  ) as val(x)
where s.i < 10 and (select val.x) < 110;

select * from int4_tbl where
  (case when f1 in (select unique1 from tenk1 a) then f1 else null end) in
  (select ten from tenk1 b);
select * from int4_tbl where
  (case when f1 in (select unique1 from tenk1 a) then f1 else null end) in
  (select ten from tenk1 b);

select * from int4_tbl o where (f1, f1) in
  (select f1, generate_series(1,2) / 10 g from int4_tbl i group by f1);
select * from int4_tbl o where (f1, f1) in
  (select f1, generate_series(1,2) / 10 g from int4_tbl i group by f1);
select (select q from
         (select 1,2,3 where f1 > 0
          union all
          select 4,5,6.0 where f1 <= 0
         ) q )
from int4_tbl;

select * from
  (select distinct ten from tenk1) ss
  where ten < 10 + nextval('ts1')
  order by 1;

select nextval('ts1');

-- UNSUPPORTED ARRAYS
-- select * from
--   (select 9 as x, unnest(array[1,2,3,11,12,13]) as u) ss
--   where tattle(x, 8);

-- select * from
--   (select 9 as x, unnest(array[1,2,3,11,12,13]) as u) ss
--   where tattle(x, 8);

-- select * from
--   (select 9 as x, unnest(array[1,2,3,11,12,13]) as u) ss
--   where tattle(x, 8);

-- select * from
--   (select 9 as x, unnest(array[1,2,3,11,12,13]) as u) ss
--   where tattle(x, 8);

-- select * from
--   (select 9 as x, unnest(array[1,2,3,11,12,13]) as u) ss
--   where tattle(x, u);

-- select * from
--   (select 9 as x, unnest(array[1,2,3,11,12,13]) as u) ss
-- where tattle(x, u);