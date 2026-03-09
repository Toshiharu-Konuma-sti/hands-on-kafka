DROP STREAM IF EXISTS stream_ksql_output;
DROP STREAM IF EXISTS stream_ksql_input;

CREATE STREAM stream_ksql_input
 (id INT, name VARCHAR, gender VARCHAR, age INT)
 WITH (KAFKA_TOPIC = 'my-stream-ksql-input', VALUE_FORMAT='JSON');

CREATE STREAM stream_ksql_output
 WITH (KAFKA_TOPIC = 'my-stream-ksql-output', VALUE_FORMAT='JSON')
 AS SELECT ski.name as name, ski.gender as gender
 FROM stream_ksql_input ski
 WHERE gender='M' OR gender='X';

SHOW STREAMS;
DESCRIBE stream_ksql_input;
DESCRIBE stream_ksql_output;
