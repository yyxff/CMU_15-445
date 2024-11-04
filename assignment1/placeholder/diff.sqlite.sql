-- 创建临时表并读取第一个 SQL 文件的查询结果
CREATE TEMP TABLE temp1 AS SELECT * FROM (
  .read q1_sample.sqlite.sql
);

-- 创建第二个临时表并读取第二个 SQL 文件的查询结果
CREATE TEMP TABLE temp2 AS SELECT * FROM (
  .read ../hw1-sols/q2_successful_coaches.duckdb.sql
);

-- 检查 temp1 是否有不在 temp2 中的行
SELECT * FROM temp1 EXCEPT SELECT * FROM temp2;

-- 检查 temp2 是否有不在 temp1 中的行
SELECT * FROM temp2 EXCEPT SELECT * FROM temp1;

-- 如果两个查询都返回空集，则结果相同

-- 比较完成后，清除临时表
DROP TABLE temp1;
DROP TABLE temp2;