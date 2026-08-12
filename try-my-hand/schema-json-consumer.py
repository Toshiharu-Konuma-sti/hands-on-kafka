#!/usr/bin/env python3
import sys
# prevent ./kafka/ directory from shadowing the kafka-python package
sys.path = [p for p in sys.path if p]
import json
import struct
import argparse
import uuid
import requests
from kafka import KafkaConsumer

schema_cache = {}


def fetch_schema(registry_url, schema_id):
    if schema_id not in schema_cache:
        r = requests.get(f"{registry_url}/schemas/ids/{schema_id}", timeout=10)
        r.raise_for_status()
        schema_cache[schema_id] = json.loads(r.json()['schema'])
    return schema_cache[schema_id]


def decode(data, registry_url):
    # Confluent wire format: magic byte (0x00) + 4-byte schema_id + JSON payload
    if len(data) >= 5 and data[0] == 0:
        schema_id = struct.unpack('>I', data[1:5])[0]
        fetch_schema(registry_url, schema_id)
        payload = json.loads(data[5:].decode('utf-8'))
        return schema_id, payload
    return None, json.loads(data.decode('utf-8'))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--bootstrap-server', required=True)
    ap.add_argument('--topic', required=True)
    ap.add_argument('--schema-registry-url', required=True)
    ap.add_argument('--from-beginning', action='store_true')
    ap.add_argument('--print-schema-ids', action='store_true')
    args = ap.parse_args()

    offset_reset = 'earliest' if args.from_beginning else 'latest'
    consumer = KafkaConsumer(
        args.topic,
        bootstrap_servers=args.bootstrap_server,
        auto_offset_reset=offset_reset,
        # use a unique group so offset_reset always applies cleanly
        group_id=f"schema-json-cli-{uuid.uuid4()}",
        enable_auto_commit=False,
    )

    try:
        for msg in consumer:
            try:
                schema_id, data = decode(msg.value, args.schema_registry_url)
                line = json.dumps(data, ensure_ascii=False)
                if args.print_schema_ids and schema_id is not None:
                    print(f"schemaId:{schema_id}\t{line}")
                else:
                    print(line)
                sys.stdout.flush()
            except Exception as e:
                print(f"[ERROR] {e}", file=sys.stderr)
    except KeyboardInterrupt:
        pass
    finally:
        consumer.close()


if __name__ == '__main__':
    main()
