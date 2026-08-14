#!/usr/bin/env python3
import sys
# prevent ./kafka/ directory from shadowing the kafka-python package
sys.path = [p for p in sys.path if p]
import json
import struct
import argparse
import requests
import jsonschema
from kafka import KafkaProducer


def fetch_schema(registry_url, schema_id):
    r = requests.get(f"{registry_url}/schemas/ids/{schema_id}", timeout=10)
    r.raise_for_status()
    return json.loads(r.json()['schema'])


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--bootstrap-server', required=True)
    ap.add_argument('--topic', required=True)
    ap.add_argument('--schema-registry-url', required=True)
    ap.add_argument('--schema-id', type=int, required=True)
    args = ap.parse_args()

    schema = fetch_schema(args.schema_registry_url, args.schema_id)
    producer = KafkaProducer(bootstrap_servers=args.bootstrap_server)

    print(f"[INFO] Schema (id={args.schema_id}) loaded. Enter JSON messages (Ctrl+D to exit):", file=sys.stderr)

    while True:
        sys.stderr.write("> ")
        sys.stderr.flush()
        line = sys.stdin.readline()
        if not line:  # Ctrl+D (EOF)
            break
        line = line.strip()
        if not line:
            continue
        try:
            data = json.loads(line)
            jsonschema.validate(data, schema)
            payload = json.dumps(data, ensure_ascii=False).encode('utf-8')
            # Confluent wire format: magic byte (0x00) + 4-byte schema_id + JSON payload
            wire = struct.pack('>bI', 0, args.schema_id) + payload
            producer.send(args.topic, value=wire)
            producer.flush()
        except json.JSONDecodeError as e:
            print(f"[ERROR] Invalid JSON: {e}", file=sys.stderr)
        except jsonschema.ValidationError as e:
            print(f"[ERROR] Schema validation failed: {e.message}", file=sys.stderr)

    producer.close()


if __name__ == '__main__':
    main()
